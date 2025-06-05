import { Request, Response } from 'express'
import { createClient } from '@supabase/supabase-js'

interface AuthRequest extends Request {
  user?: {
    id: string
    email: string
    subscription_type: string
  }
}

/**
 * AI 추천 목록 조회
 * GET /api/recommendations
 * 
 * @query {
 *   strategy_type?: 'momentum' | 'value' | 'growth' | 'dividend' | 'sector_rotation'
 *   risk_level?: 'low' | 'medium' | 'high'
 *   limit?: number
 *   offset?: number
 * }
 */
export async function getRecommendations(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { 
      strategy_type, 
      risk_level, 
      limit = 20, 
      offset = 0 
    } = req.query

    // 구독 레벨별 필터링
    const subscriptionFilters = {
      free: { limit: 5 },      // 무료: 5개만
      basic: { limit: 20 },    // 기본: 20개
      premium: { limit: 50 },  // 프리미엄: 50개
      vip: { limit: 100 }      // VIP: 100개
    }

    const userLimit = Math.min(
      Number(limit), 
      subscriptionFilters[req.user!.subscription_type as keyof typeof subscriptionFilters].limit
    )

    // 추천 데이터 조회
    let query = supabase
      .from('recommendations')
      .select(`
        *,
        trader_strategies (
          id,
          name,
          description,
          type,
          risk_level,
          expected_return,
          win_rate
        )
      `)
      .eq('is_active', true)
      .order('confidence_score', { ascending: false })
      .range(Number(offset), Number(offset) + userLimit - 1)

    // 필터 적용
    if (strategy_type) {
      query = query.eq('trader_strategies.type', strategy_type)
    }
    if (risk_level) {
      query = query.eq('trader_strategies.risk_level', risk_level)
    }

    const { data: recommendations, error } = await query

    if (error) {
      throw error
    }

    // 사용자의 포트폴리오 정보 조회
    const { data: portfolio } = await supabase
      .from('portfolios')
      .select('current_value, buying_power')
      .eq('user_id', req.user!.id)
      .eq('is_primary', true)
      .single()

    // 추천별 포지션 크기 계산
    const enhancedRecommendations = recommendations.map(rec => ({
      ...rec,
      suggested_position_size: calculatePositionSize(
        portfolio?.current_value || 0,
        rec.confidence_score,
        rec.trader_strategies.risk_level
      ),
      available_for_level: checkAvailability(req.user!.subscription_type, rec.premium_only)
    }))

    // 조회 기록 저장
    await supabase
      .from('recommendation_views')
      .insert({
        user_id: req.user!.id,
        viewed_count: enhancedRecommendations.length,
        filters: { strategy_type, risk_level }
      })

    res.json({
      recommendations: enhancedRecommendations,
      total: enhancedRecommendations.length,
      subscription_limit: subscriptionFilters[req.user!.subscription_type as keyof typeof subscriptionFilters].limit
    })

  } catch (error) {
    console.error('Get recommendations error:', error)
    res.status(500).json({ error: '추천 조회 중 오류가 발생했습니다.' })
  }
}

/**
 * 포지션 크기 계산
 */
function calculatePositionSize(
  portfolioValue: number, 
  confidence: number, 
  riskLevel: string
): number {
  const riskMultipliers = {
    low: 0.02,    // 2%
    medium: 0.05, // 5%
    high: 0.10    // 10%
  }

  const baseSize = portfolioValue * riskMultipliers[riskLevel as keyof typeof riskMultipliers]
  return Math.round(baseSize * (confidence / 100))
}

/**
 * 구독 레벨별 사용 가능 여부 확인
 */
function checkAvailability(userLevel: string, isPremium: boolean): boolean {
  if (!isPremium) return true
  
  const premiumLevels = ['premium', 'vip']
  return premiumLevels.includes(userLevel)
}