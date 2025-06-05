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
 * 포지션 생성 (매수/매도)
 * POST /api/portfolio/positions
 * 
 * @body {
 *   portfolio_id?: string,
 *   recommendation_id?: string,
 *   ticker: string,
 *   action: 'BUY' | 'SELL',
 *   quantity: number,
 *   order_type: 'market' | 'limit',
 *   limit_price?: number,
 *   stop_loss?: number,
 *   take_profit?: number
 * }
 */
export async function createPosition(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { 
      portfolio_id,
      recommendation_id,
      ticker,
      action,
      quantity,
      order_type,
      limit_price,
      stop_loss,
      take_profit
    } = req.body

    // 포트폴리오 확인
    const { data: portfolio, error: portfolioError } = await supabase
      .from('portfolios')
      .select('*')
      .eq('user_id', req.user!.id)
      .eq(portfolio_id ? 'id' : 'is_primary', portfolio_id || true)
      .single()

    if (portfolioError || !portfolio) {
      return res.status(404).json({ error: '포트폴리오를 찾을 수 없습니다.' })
    }

    // 현재 가격 조회
    const currentPrice = await getStockPrice(ticker)
    const executionPrice = order_type === 'limit' && limit_price ? limit_price : currentPrice

    // 구매력 확인 (매수인 경우)
    if (action === 'BUY') {
      const requiredAmount = executionPrice * quantity
      const { data: positions } = await supabase
        .from('positions')
        .select('market_value')
        .eq('portfolio_id', portfolio.id)
        .eq('status', 'open')

      const totalPositionValue = positions?.reduce((sum, p) => sum + p.market_value, 0) || 0
      const availableCash = portfolio.current_value - totalPositionValue

      if (requiredAmount > availableCash) {
        return res.status(400).json({ 
          error: '구매력이 부족합니다.',
          required: requiredAmount,
          available: availableCash
        })
      }
    }

    // 매도인 경우 보유 수량 확인
    if (action === 'SELL') {
      const { data: existingPosition } = await supabase
        .from('positions')
        .select('quantity')
        .eq('portfolio_id', portfolio.id)
        .eq('ticker', ticker)
        .eq('status', 'open')
        .single()

      if (!existingPosition || existingPosition.quantity < quantity) {
        return res.status(400).json({ 
          error: '보유 수량이 부족합니다.',
          requested: quantity,
          available: existingPosition?.quantity || 0
        })
      }
    }

    // 추천 정보 확인 (있는 경우)
    let recommendation = null
    if (recommendation_id) {
      const { data: recData } = await supabase
        .from('recommendations')
        .select('*')
        .eq('id', recommendation_id)
        .single()
      
      recommendation = recData
    }

    // 포지션 생성
    const { data: position, error: positionError } = await supabase
      .from('positions')
      .insert({
        portfolio_id: portfolio.id,
        recommendation_id,
        ticker,
        action,
        quantity,
        entry_price: executionPrice,
        stop_loss: stop_loss || recommendation?.stop_loss,
        take_profit: take_profit || recommendation?.target_price,
        status: 'open',
        opened_at: new Date().toISOString()
      })
      .select()
      .single()

    if (positionError) {
      throw positionError
    }

    // 거래 내역 기록
    await supabase
      .from('transactions')
      .insert({
        portfolio_id: portfolio.id,
        position_id: position.id,
        type: action,
        ticker,
        quantity,
        price: executionPrice,
        total_amount: executionPrice * quantity,
        fees: calculateFees(executionPrice * quantity, req.user!.subscription_type),
        executed_at: new Date().toISOString()
      })

    // 포트폴리오 값 업데이트
    if (action === 'BUY') {
      await supabase
        .from('portfolios')
        .update({
          current_value: portfolio.current_value - (executionPrice * quantity)
        })
        .eq('id', portfolio.id)
    }

    // 실시간 알림
    await supabase.rpc('send_position_notification', {
      user_id: req.user!.id,
      position_id: position.id,
      action: action,
      ticker: ticker
    })

    res.status(201).json({
      position,
      portfolio_update: {
        buying_power: portfolio.current_value - (action === 'BUY' ? executionPrice * quantity : 0)
      }
    })

  } catch (error) {
    console.error('Create position error:', error)
    res.status(500).json({ error: '포지션 생성 중 오류가 발생했습니다.' })
  }
}

/**
 * 주식 현재가 조회 (모의)
 */
async function getStockPrice(ticker: string): Promise<number> {
  // 실제로는 외부 API 호출
  const basePrices: Record<string, number> = {
    'AAPL': 175,
    'MSFT': 380,
    'GOOGL': 140,
    'AMZN': 170,
    'TSLA': 250,
    'NVDA': 480,
    'META': 350
  }

  const basePrice = basePrices[ticker] || 100
  const variation = (Math.random() - 0.5) * 0.02 // ±1% 변동
  
  return basePrice * (1 + variation)
}

/**
 * 거래 수수료 계산
 */
function calculateFees(amount: number, subscriptionType: string): number {
  const feeRates = {
    free: 0.005,    // 0.5%
    basic: 0.003,   // 0.3%
    premium: 0.002, // 0.2%
    vip: 0.001      // 0.1%
  }

  return amount * feeRates[subscriptionType as keyof typeof feeRates]
}