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
 * AI 추천 생성 (실시간)
 * POST /api/recommendations/generate
 * 
 * @body {
 *   strategy_id: string,
 *   market_conditions?: {
 *     vix: number,
 *     market_trend: 'bullish' | 'bearish' | 'neutral',
 *     sector_performance: Record<string, number>
 *   }
 * }
 */
export async function generateRecommendation(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { strategy_id, market_conditions } = req.body

    // 전략 정보 조회
    const { data: strategy, error: strategyError } = await supabase
      .from('trader_strategies')
      .select('*')
      .eq('id', strategy_id)
      .single()

    if (strategyError || !strategy) {
      return res.status(404).json({ error: '전략을 찾을 수 없습니다.' })
    }

    // 구독 레벨 확인 (프리미엄 전략인 경우)
    if (strategy.premium_only && !['premium', 'vip'].includes(req.user!.subscription_type)) {
      return res.status(403).json({ 
        error: '이 전략은 프리미엄 이상 회원만 사용 가능합니다.' 
      })
    }

    // AI 모델로 추천 생성 (실제로는 외부 AI API 호출)
    const recommendation = await generateAIRecommendation(
      strategy,
      market_conditions || await fetchMarketConditions()
    )

    // 추천 저장
    const { data: savedRecommendation, error: saveError } = await supabase
      .from('recommendations')
      .insert({
        trader_strategy_id: strategy_id,
        ticker: recommendation.ticker,
        action: recommendation.action,
        entry_price: recommendation.entry_price,
        target_price: recommendation.target_price,
        stop_loss: recommendation.stop_loss,
        confidence_score: recommendation.confidence_score,
        rationale: recommendation.rationale,
        risk_reward_ratio: recommendation.risk_reward_ratio,
        time_horizon: recommendation.time_horizon,
        premium_only: strategy.premium_only,
        generated_by: 'ai_engine_v2',
        market_conditions: market_conditions || await fetchMarketConditions()
      })
      .select()
      .single()

    if (saveError) {
      throw saveError
    }

    // 실시간 알림 발송 (구독자에게)
    await supabase.rpc('send_recommendation_notification', {
      recommendation_id: savedRecommendation.id,
      strategy_id: strategy_id
    })

    // 생성 기록
    await supabase
      .from('recommendation_generations')
      .insert({
        user_id: req.user!.id,
        recommendation_id: savedRecommendation.id,
        strategy_id: strategy_id
      })

    res.status(201).json({
      recommendation: savedRecommendation,
      strategy: {
        name: strategy.name,
        type: strategy.type,
        risk_level: strategy.risk_level
      }
    })

  } catch (error) {
    console.error('Generate recommendation error:', error)
    res.status(500).json({ error: '추천 생성 중 오류가 발생했습니다.' })
  }
}

/**
 * AI 추천 생성 로직 (모의)
 */
async function generateAIRecommendation(strategy: any, marketConditions: any) {
  // 실제로는 복잡한 AI 모델 사용
  // 여기서는 간단한 로직으로 시뮬레이션
  
  const stocks = {
    momentum: ['NVDA', 'TSLA', 'AMD', 'AAPL', 'MSFT'],
    value: ['BRK.B', 'JPM', 'BAC', 'WFC', 'C'],
    growth: ['AMZN', 'GOOGL', 'META', 'NFLX', 'CRM'],
    dividend: ['JNJ', 'PG', 'KO', 'PEP', 'T'],
    sector_rotation: ['XLF', 'XLK', 'XLE', 'XLV', 'XLI']
  }

  const selectedStocks = stocks[strategy.type as keyof typeof stocks] || stocks.momentum
  const ticker = selectedStocks[Math.floor(Math.random() * selectedStocks.length)]
  
  // 현재 가격 시뮬레이션 (실제로는 API 호출)
  const currentPrice = Math.random() * 500 + 50
  
  // 전략별 파라미터
  const params = {
    momentum: { targetGain: 0.15, stopLoss: 0.05 },
    value: { targetGain: 0.20, stopLoss: 0.08 },
    growth: { targetGain: 0.25, stopLoss: 0.10 },
    dividend: { targetGain: 0.10, stopLoss: 0.05 },
    sector_rotation: { targetGain: 0.12, stopLoss: 0.06 }
  }

  const strategyParams = params[strategy.type as keyof typeof params] || params.momentum

  return {
    ticker,
    action: marketConditions.market_trend === 'bearish' ? 'SELL' : 'BUY',
    entry_price: currentPrice,
    target_price: currentPrice * (1 + strategyParams.targetGain),
    stop_loss: currentPrice * (1 - strategyParams.stopLoss),
    confidence_score: Math.floor(Math.random() * 30) + 70, // 70-100
    rationale: `${strategy.type} 전략 기반 추천. 현재 시장 상황: ${marketConditions.market_trend}`,
    risk_reward_ratio: strategyParams.targetGain / strategyParams.stopLoss,
    time_horizon: strategy.type === 'momentum' ? '1-2 weeks' : '3-6 months'
  }
}

/**
 * 시장 상황 조회
 */
async function fetchMarketConditions() {
  // 실제로는 외부 API에서 데이터 조회
  return {
    vix: Math.random() * 30 + 10,
    market_trend: ['bullish', 'bearish', 'neutral'][Math.floor(Math.random() * 3)],
    sector_performance: {
      technology: Math.random() * 0.1 - 0.05,
      finance: Math.random() * 0.1 - 0.05,
      healthcare: Math.random() * 0.1 - 0.05,
      energy: Math.random() * 0.1 - 0.05,
      consumer: Math.random() * 0.1 - 0.05
    }
  }
}