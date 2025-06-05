import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

/**
 * 포지션 모니터링 Edge Function
 * 
 * 이 함수는 1분마다 실행되어 손절/익절 조건을 확인하고 알림을 발송합니다.
 */
serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 열린 포지션 조회
    const { data: positions, error: positionError } = await supabase
      .from('positions')
      .select(`
        *,
        portfolios (
          user_id,
          users (
            email,
            notification_preferences,
            subscription_type
          )
        ),
        recommendations (
          trader_strategies (
            name
          )
        )
      `)
      .eq('status', 'open')

    if (positionError) {
      throw positionError
    }

    const alerts = []
    const positionUpdates = []

    // 각 포지션 확인
    for (const position of positions) {
      // 현재 가격 조회 (실제로는 외부 API)
      const currentPrice = await fetchCurrentPrice(position.ticker)
      
      // 손익 계산
      const pnl = (currentPrice - position.entry_price) * position.quantity
      const pnlPercentage = ((currentPrice - position.entry_price) / position.entry_price) * 100

      // 손절 확인
      if (position.stop_loss && currentPrice <= position.stop_loss) {
        alerts.push({
          type: 'stop_loss',
          position,
          currentPrice,
          pnl,
          pnlPercentage
        })

        positionUpdates.push({
          id: position.id,
          status: 'closed',
          exit_price: currentPrice,
          closed_at: new Date().toISOString(),
          realized_pnl: pnl,
          realized_pnl_percentage: pnlPercentage,
          close_reason: 'stop_loss'
        })
      }
      // 익절 확인
      else if (position.take_profit && currentPrice >= position.take_profit) {
        alerts.push({
          type: 'take_profit',
          position,
          currentPrice,
          pnl,
          pnlPercentage
        })

        positionUpdates.push({
          id: position.id,
          status: 'closed',
          exit_price: currentPrice,
          closed_at: new Date().toISOString(),
          realized_pnl: pnl,
          realized_pnl_percentage: pnlPercentage,
          close_reason: 'take_profit'
        })
      }
      // 위험 알림 (손실 -5% 이상)
      else if (pnlPercentage <= -5 && !position.last_alert_at) {
        alerts.push({
          type: 'risk_warning',
          position,
          currentPrice,
          pnl,
          pnlPercentage
        })

        // 알림 시간 업데이트
        await supabase
          .from('positions')
          .update({ last_alert_at: new Date().toISOString() })
          .eq('id', position.id)
      }
      // 수익 알림 (이익 10% 이상)
      else if (pnlPercentage >= 10 && !position.profit_alert_sent) {
        alerts.push({
          type: 'profit_alert',
          position,
          currentPrice,
          pnl,
          pnlPercentage
        })

        // 수익 알림 플래그 업데이트
        await supabase
          .from('positions')
          .update({ profit_alert_sent: true })
          .eq('id', position.id)
      }

      // 포지션 현재 상태 업데이트
      await supabase
        .from('position_snapshots')
        .insert({
          position_id: position.id,
          ticker: position.ticker,
          current_price: currentPrice,
          pnl,
          pnl_percentage: pnlPercentage,
          snapshot_at: new Date().toISOString()
        })
    }

    // 포지션 종료 처리
    if (positionUpdates.length > 0) {
      for (const update of positionUpdates) {
        const { id, ...updateData } = update
        
        await supabase
          .from('positions')
          .update(updateData)
          .eq('id', id)

        // 포트폴리오 값 업데이트
        const position = positions.find(p => p.id === id)
        if (position) {
          await updatePortfolioValue(supabase, position.portfolio_id, update.realized_pnl)
        }
      }
    }

    // 알림 발송
    if (alerts.length > 0) {
      await sendAlerts(supabase, alerts)
    }

    // 성능 지표 업데이트
    await updatePerformanceMetrics(supabase)

    return new Response(
      JSON.stringify({ 
        success: true,
        positions_checked: positions.length,
        alerts_sent: alerts.length,
        positions_closed: positionUpdates.length
      }),
      { headers: { 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 500,
        headers: { 'Content-Type': 'application/json' } 
      }
    )
  }
})

/**
 * 현재 가격 조회 (모의)
 */
async function fetchCurrentPrice(ticker: string): Promise<number> {
  // 실제로는 Yahoo Finance, IEX Cloud 등의 API 호출
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
  const intraday_variation = (Math.random() - 0.5) * 0.04 // ±2% 일중 변동
  
  return basePrice * (1 + intraday_variation)
}

/**
 * 포트폴리오 값 업데이트
 */
async function updatePortfolioValue(supabase: any, portfolioId: string, realizedPnl: number) {
  const { data: portfolio } = await supabase
    .from('portfolios')
    .select('current_value')
    .eq('id', portfolioId)
    .single()

  if (portfolio) {
    await supabase
      .from('portfolios')
      .update({
        current_value: portfolio.current_value + realizedPnl,
        last_updated: new Date().toISOString()
      })
      .eq('id', portfolioId)
  }
}

/**
 * 알림 발송
 */
async function sendAlerts(supabase: any, alerts: any[]) {
  for (const alert of alerts) {
    const user = alert.position.portfolios.users
    const preferences = user.notification_preferences || {}

    // 알림 메시지 생성
    const messages = {
      stop_loss: {
        title: '손절 실행',
        body: `${alert.position.ticker} 포지션이 손절되었습니다. 손실: ${alert.pnl.toFixed(2)} (${alert.pnlPercentage.toFixed(2)}%)`
      },
      take_profit: {
        title: '익절 실행',
        body: `${alert.position.ticker} 포지션이 익절되었습니다. 수익: ${alert.pnl.toFixed(2)} (${alert.pnlPercentage.toFixed(2)}%)`
      },
      risk_warning: {
        title: '위험 경고',
        body: `${alert.position.ticker} 포지션 손실 ${alert.pnlPercentage.toFixed(2)}%. 현재가: ${alert.currentPrice}`
      },
      profit_alert: {
        title: '수익 알림',
        body: `${alert.position.ticker} 포지션 수익 ${alert.pnlPercentage.toFixed(2)}%. 익절 고려해보세요.`
      }
    }

    const message = messages[alert.type]

    // 푸시 알림
    if (preferences.push_enabled) {
      await supabase.from('push_notifications').insert({
        user_id: alert.position.portfolios.user_id,
        title: message.title,
        body: message.body,
        type: alert.type,
        data: {
          position_id: alert.position.id,
          ticker: alert.position.ticker,
          pnl: alert.pnl,
          pnl_percentage: alert.pnlPercentage
        }
      })
    }

    // 이메일 알림 (중요 알림만)
    if (preferences.email_enabled && ['stop_loss', 'take_profit'].includes(alert.type)) {
      await supabase.from('email_queue').insert({
        to: user.email,
        subject: message.title,
        template: 'position_alert',
        data: {
          ...message,
          position: alert.position,
          current_price: alert.currentPrice,
          pnl: alert.pnl,
          pnl_percentage: alert.pnlPercentage
        }
      })
    }

    // 알림 기록
    await supabase.from('notifications').insert({
      user_id: alert.position.portfolios.user_id,
      type: alert.type,
      title: message.title,
      body: message.body,
      data: {
        position_id: alert.position.id,
        ticker: alert.position.ticker
      },
      is_read: false
    })
  }
}

/**
 * 성능 지표 업데이트
 */
async function updatePerformanceMetrics(supabase: any) {
  // 전략별 성과 집계
  const { data: strategies } = await supabase
    .from('trader_strategies')
    .select('id')

  for (const strategy of strategies || []) {
    // 최근 30일 성과
    const thirtyDaysAgo = new Date()
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

    const { data: closedPositions } = await supabase
      .from('positions')
      .select('realized_pnl_percentage')
      .eq('status', 'closed')
      .eq('recommendations.trader_strategy_id', strategy.id)
      .gte('closed_at', thirtyDaysAgo.toISOString())

    if (closedPositions && closedPositions.length > 0) {
      const winningPositions = closedPositions.filter(p => p.realized_pnl_percentage > 0)
      const avgReturn = closedPositions.reduce((sum, p) => sum + p.realized_pnl_percentage, 0) / closedPositions.length
      
      await supabase
        .from('strategy_performance')
        .upsert({
          strategy_id: strategy.id,
          period: '30d',
          total_trades: closedPositions.length,
          winning_trades: winningPositions.length,
          win_rate: (winningPositions.length / closedPositions.length) * 100,
          avg_return: avgReturn,
          updated_at: new Date().toISOString()
        })
    }
  }
}