import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

interface MarketData {
  ticker: string
  price: number
  volume: number
  change: number
  rsi: number
  macd: {
    value: number
    signal: number
    histogram: number
  }
  moving_averages: {
    ma20: number
    ma50: number
    ma200: number
  }
}

/**
 * 실시간 AI 추천 생성 Edge Function
 * 
 * 이 함수는 5분마다 자동으로 실행되어 새로운 추천을 생성합니다.
 */
serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 활성 전략 조회
    const { data: strategies, error: strategyError } = await supabase
      .from('trader_strategies')
      .select('*')
      .eq('is_active', true)

    if (strategyError) {
      throw strategyError
    }

    // 각 전략별로 추천 생성
    const recommendations = []
    
    for (const strategy of strategies) {
      // 시장 데이터 가져오기 (실제로는 외부 API 호출)
      const marketData = await fetchMarketData(strategy.target_sectors)
      
      // AI 모델로 분석 (실제로는 더 복잡한 로직)
      const analysis = await analyzeMarket(strategy, marketData)
      
      // 추천 생성 조건 확인
      if (analysis.shouldRecommend) {
        const recommendation = {
          trader_strategy_id: strategy.id,
          ticker: analysis.ticker,
          action: analysis.action,
          entry_price: analysis.entry_price,
          target_price: analysis.target_price,
          stop_loss: analysis.stop_loss,
          confidence_score: analysis.confidence_score,
          rationale: analysis.rationale,
          risk_reward_ratio: analysis.risk_reward_ratio,
          time_horizon: analysis.time_horizon,
          premium_only: strategy.minimum_subscription === 'premium' || strategy.minimum_subscription === 'vip',
          market_conditions: {
            vix: marketData.vix,
            trend: marketData.trend,
            volume: marketData.volume
          }
        }
        
        recommendations.push(recommendation)
      }
    }

    // 추천 저장
    if (recommendations.length > 0) {
      const { data: savedRecommendations, error: saveError } = await supabase
        .from('recommendations')
        .insert(recommendations)
        .select()

      if (saveError) {
        throw saveError
      }

      // 구독자에게 알림 발송
      for (const rec of savedRecommendations) {
        await sendNotifications(supabase, rec)
      }

      return new Response(
        JSON.stringify({ 
          success: true, 
          recommendations_count: savedRecommendations.length 
        }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        recommendations_count: 0,
        message: 'No recommendations generated' 
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
 * 시장 데이터 가져오기 (모의)
 */
async function fetchMarketData(sectors: string[]): Promise<any> {
  // 실제로는 Yahoo Finance, Alpha Vantage 등의 API 호출
  return {
    vix: Math.random() * 30 + 10,
    trend: Math.random() > 0.5 ? 'bullish' : 'bearish',
    volume: Math.floor(Math.random() * 1000000),
    stocks: [
      {
        ticker: 'AAPL',
        price: 175 + Math.random() * 10,
        volume: 50000000,
        change: Math.random() * 0.05 - 0.025,
        rsi: Math.random() * 100,
        macd: {
          value: Math.random() * 5 - 2.5,
          signal: Math.random() * 5 - 2.5,
          histogram: Math.random() * 2 - 1
        },
        moving_averages: {
          ma20: 172,
          ma50: 168,
          ma200: 160
        }
      }
      // ... 더 많은 주식 데이터
    ]
  }
}

/**
 * AI 시장 분석 (모의)
 */
async function analyzeMarket(strategy: any, marketData: any): Promise<any> {
  // 전략별 분석 로직
  const analysisRules = {
    momentum: (data: MarketData) => {
      // RSI > 70 and MACD 골든크로스
      return data.rsi > 70 && data.macd.histogram > 0
    },
    value: (data: MarketData) => {
      // P/E < 15 and price < ma200
      return data.price < data.moving_averages.ma200
    },
    growth: (data: MarketData) => {
      // 성장률 > 20% and 거래량 증가
      return data.change > 0.02 && data.volume > 70000000
    }
  }

  // 가장 좋은 기회 찾기
  const opportunities = marketData.stocks
    .filter((stock: MarketData) => analysisRules[strategy.type]?.(stock))
    .sort((a: MarketData, b: MarketData) => b.change - a.change)

  if (opportunities.length === 0) {
    return { shouldRecommend: false }
  }

  const bestStock = opportunities[0]
  const confidence = calculateConfidence(strategy, bestStock, marketData)

  return {
    shouldRecommend: confidence > 70,
    ticker: bestStock.ticker,
    action: marketData.trend === 'bullish' ? 'BUY' : 'SELL',
    entry_price: bestStock.price,
    target_price: bestStock.price * (1 + strategy.expected_return / 100),
    stop_loss: bestStock.price * (1 - strategy.max_drawdown / 100),
    confidence_score: confidence,
    rationale: generateRationale(strategy, bestStock, marketData),
    risk_reward_ratio: strategy.expected_return / strategy.max_drawdown,
    time_horizon: strategy.typical_holding_period
  }
}

/**
 * 신뢰도 점수 계산
 */
function calculateConfidence(strategy: any, stock: MarketData, marketData: any): number {
  let score = 50 // 기본 점수

  // 기술적 지표
  if (stock.rsi > 50 && stock.rsi < 70) score += 10
  if (stock.macd.histogram > 0) score += 10
  if (stock.price > stock.moving_averages.ma50) score += 10
  
  // 시장 상황
  if (marketData.trend === 'bullish') score += 10
  if (marketData.vix < 20) score += 10

  // 전략 특화 조정
  if (strategy.type === 'momentum' && stock.change > 0.03) score += 10
  if (strategy.type === 'value' && stock.price < stock.moving_averages.ma200) score += 10

  return Math.min(score, 100)
}

/**
 * 추천 근거 생성
 */
function generateRationale(strategy: any, stock: MarketData, marketData: any): string {
  const reasons = []
  
  if (stock.rsi > 70) reasons.push('강한 상승 모멘텀')
  if (stock.macd.histogram > 0) reasons.push('MACD 골든크로스')
  if (stock.price > stock.moving_averages.ma50) reasons.push('50일 이평선 돌파')
  if (marketData.trend === 'bullish') reasons.push('전반적 시장 상승세')
  
  return `${strategy.name} 전략 기반 추천. ${reasons.join(', ')}. 
    현재 RSI: ${stock.rsi.toFixed(1)}, 
    거래량: ${(stock.volume / 1000000).toFixed(1)}M`
}

/**
 * 알림 발송
 */
async function sendNotifications(supabase: any, recommendation: any) {
  // 해당 전략 구독자 조회
  const { data: subscribers } = await supabase
    .from('strategy_subscriptions')
    .select('user_id, users(email, notification_preferences)')
    .eq('strategy_id', recommendation.trader_strategy_id)
    .eq('is_active', true)

  if (!subscribers) return

  // 각 구독자에게 알림 발송
  for (const subscriber of subscribers) {
    // 푸시 알림
    if (subscriber.users.notification_preferences?.push_enabled) {
      await supabase.from('push_notifications').insert({
        user_id: subscriber.user_id,
        title: '새로운 AI 추천',
        body: `${recommendation.ticker} ${recommendation.action} 추천 (신뢰도: ${recommendation.confidence_score}%)`,
        data: { recommendation_id: recommendation.id }
      })
    }

    // 이메일 알림
    if (subscriber.users.notification_preferences?.email_enabled) {
      await supabase.from('email_queue').insert({
        to: subscriber.users.email,
        subject: '새로운 AI 트레이딩 추천',
        template: 'recommendation',
        data: recommendation
      })
    }
  }
}