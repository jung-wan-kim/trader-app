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
 * 포트폴리오 조회
 * GET /api/portfolio
 * 
 * @query {
 *   portfolio_id?: string
 *   include_positions?: boolean
 *   include_history?: boolean
 * }
 */
export async function getPortfolio(req: AuthRequest, res: Response) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  try {
    const { 
      portfolio_id, 
      include_positions = true, 
      include_history = false 
    } = req.query

    // 포트폴리오 조회
    let query = supabase
      .from('portfolios')
      .select('*')
      .eq('user_id', req.user!.id)

    if (portfolio_id) {
      query = query.eq('id', portfolio_id).single()
    } else {
      query = query.eq('is_primary', true).single()
    }

    const { data: portfolio, error: portfolioError } = await query

    if (portfolioError || !portfolio) {
      return res.status(404).json({ error: '포트폴리오를 찾을 수 없습니다.' })
    }

    // 포지션 정보 조회
    let positions = []
    if (include_positions) {
      const { data: positionData } = await supabase
        .from('positions')
        .select(`
          *,
          recommendations (
            ticker,
            action,
            entry_price,
            target_price,
            stop_loss,
            trader_strategies (
              name,
              type
            )
          )
        `)
        .eq('portfolio_id', portfolio.id)
        .eq('status', 'open')
        .order('opened_at', { ascending: false })

      positions = positionData || []

      // 현재 가격 및 수익률 계산 (실제로는 외부 API 호출)
      positions = await Promise.all(positions.map(async (position) => {
        const currentPrice = await getStockPrice(position.ticker)
        const pnl = (currentPrice - position.entry_price) * position.quantity
        const pnlPercentage = ((currentPrice - position.entry_price) / position.entry_price) * 100

        return {
          ...position,
          current_price: currentPrice,
          pnl,
          pnl_percentage: pnlPercentage,
          market_value: currentPrice * position.quantity
        }
      }))
    }

    // 거래 내역 조회
    let history = []
    if (include_history) {
      const { data: historyData } = await supabase
        .from('positions')
        .select('*')
        .eq('portfolio_id', portfolio.id)
        .eq('status', 'closed')
        .order('closed_at', { ascending: false })
        .limit(50)

      history = historyData || []
    }

    // 포트폴리오 통계 계산
    const stats = calculatePortfolioStats(portfolio, positions, history)

    res.json({
      portfolio: {
        ...portfolio,
        ...stats
      },
      positions,
      history: include_history ? history : undefined
    })

  } catch (error) {
    console.error('Get portfolio error:', error)
    res.status(500).json({ error: '포트폴리오 조회 중 오류가 발생했습니다.' })
  }
}

/**
 * 주식 현재가 조회 (모의)
 */
async function getStockPrice(ticker: string): Promise<number> {
  // 실제로는 외부 API (Yahoo Finance, Alpha Vantage 등) 호출
  // 여기서는 랜덤 값으로 시뮬레이션
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
  const variation = (Math.random() - 0.5) * 0.1 // ±5% 변동
  
  return basePrice * (1 + variation)
}

/**
 * 포트폴리오 통계 계산
 */
function calculatePortfolioStats(portfolio: any, positions: any[], history: any[]) {
  // 총 시장가치
  const totalMarketValue = positions.reduce((sum, pos) => sum + pos.market_value, 0)
  
  // 총 손익
  const totalPnL = positions.reduce((sum, pos) => sum + pos.pnl, 0)
  
  // 오늘 손익 (실제로는 더 복잡한 계산 필요)
  const todayPnL = totalPnL * 0.02 // 임시로 2%
  
  // 승률 계산 (종료된 포지션 기준)
  const closedWins = history.filter(h => h.realized_pnl > 0).length
  const closedTotal = history.length
  const winRate = closedTotal > 0 ? (closedWins / closedTotal) * 100 : 0

  // 평균 수익률
  const avgReturn = history.length > 0 
    ? history.reduce((sum, h) => sum + h.realized_pnl_percentage, 0) / history.length 
    : 0

  return {
    total_value: portfolio.current_value + totalMarketValue,
    total_pnl: totalPnL,
    total_pnl_percentage: (totalPnL / portfolio.initial_capital) * 100,
    today_pnl: todayPnL,
    today_pnl_percentage: (todayPnL / portfolio.current_value) * 100,
    positions_count: positions.length,
    win_rate: winRate,
    avg_return: avgReturn,
    buying_power: portfolio.current_value - totalMarketValue
  }
}