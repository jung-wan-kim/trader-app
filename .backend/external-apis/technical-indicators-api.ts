import axios from 'axios'
import { Redis } from 'ioredis'
import * as technicalIndicators from 'technicalindicators'

/**
 * 기술적 지표 API 통합 클래스
 * 
 * 지원 지표:
 * - RSI (Relative Strength Index)
 * - MACD (Moving Average Convergence Divergence)
 * - Bollinger Bands
 * - Moving Averages (SMA, EMA)
 * - Stochastic
 * - ATR (Average True Range)
 * - Volume indicators
 */
export class TechnicalIndicatorsAPI {
  private redis: Redis
  private stockDataAPI: any // StockDataAPI instance

  constructor(stockDataAPI: any) {
    this.redis = new Redis(process.env.REDIS_URL!)
    this.stockDataAPI = stockDataAPI
  }

  /**
   * RSI (상대강도지수) 계산
   */
  async getRSI(ticker: string, period: number = 14): Promise<RSIData> {
    const cacheKey = `rsi:${ticker}:${period}`
    const cached = await this.redis.get(cacheKey)
    if (cached) {
      return JSON.parse(cached)
    }

    // 과거 데이터 조회 (RSI 계산을 위해 충분한 데이터 필요)
    const historicalData = await this.stockDataAPI.getHistoricalData(ticker, '3m')
    const closePrices = historicalData.map(d => d.close)

    // RSI 계산
    const rsiValues = technicalIndicators.RSI.calculate({
      values: closePrices,
      period: period
    })

    const currentRSI = rsiValues[rsiValues.length - 1]
    const previousRSI = rsiValues[rsiValues.length - 2]

    const result: RSIData = {
      ticker,
      period,
      value: currentRSI,
      previousValue: previousRSI,
      signal: this.interpretRSI(currentRSI),
      overbought: currentRSI > 70,
      oversold: currentRSI < 30,
      timestamp: new Date()
    }

    // 캐시 저장
    await this.redis.setex(cacheKey, 300, JSON.stringify(result)) // 5분 캐시

    return result
  }

  /**
   * MACD 계산
   */
  async getMACD(
    ticker: string, 
    fastPeriod: number = 12, 
    slowPeriod: number = 26, 
    signalPeriod: number = 9
  ): Promise<MACDData> {
    const cacheKey = `macd:${ticker}:${fastPeriod}:${slowPeriod}:${signalPeriod}`
    const cached = await this.redis.get(cacheKey)
    if (cached) {
      return JSON.parse(cached)
    }

    const historicalData = await this.stockDataAPI.getHistoricalData(ticker, '3m')
    const closePrices = historicalData.map(d => d.close)

    // MACD 계산
    const macdResult = technicalIndicators.MACD.calculate({
      values: closePrices,
      fastPeriod,
      slowPeriod,
      signalPeriod,
      SimpleMAOscillator: false,
      SimpleMASignal: false
    })

    const current = macdResult[macdResult.length - 1]
    const previous = macdResult[macdResult.length - 2]

    const result: MACDData = {
      ticker,
      macd: current.MACD,
      signal: current.signal,
      histogram: current.histogram,
      previousHistogram: previous.histogram,
      crossover: this.detectMACDCrossover(current, previous),
      trend: current.histogram > 0 ? 'bullish' : 'bearish',
      timestamp: new Date()
    }

    await this.redis.setex(cacheKey, 300, JSON.stringify(result))

    return result
  }

  /**
   * 이동평균선 계산
   */
  async getMovingAverages(ticker: string): Promise<MovingAveragesData> {
    const cacheKey = `ma:${ticker}`
    const cached = await this.redis.get(cacheKey)
    if (cached) {
      return JSON.parse(cached)
    }

    const historicalData = await this.stockDataAPI.getHistoricalData(ticker, '1y')
    const closePrices = historicalData.map(d => d.close)
    const currentPrice = closePrices[closePrices.length - 1]

    // 각 기간별 이동평균 계산
    const sma20 = technicalIndicators.SMA.calculate({
      values: closePrices,
      period: 20
    })

    const sma50 = technicalIndicators.SMA.calculate({
      values: closePrices,
      period: 50
    })

    const sma200 = technicalIndicators.SMA.calculate({
      values: closePrices,
      period: 200
    })

    const ema20 = technicalIndicators.EMA.calculate({
      values: closePrices,
      period: 20
    })

    const result: MovingAveragesData = {
      ticker,
      currentPrice,
      sma: {
        ma20: sma20[sma20.length - 1],
        ma50: sma50[sma50.length - 1],
        ma200: sma200[sma200.length - 1]
      },
      ema: {
        ma20: ema20[ema20.length - 1]
      },
      signals: {
        goldenCross: sma50[sma50.length - 1] > sma200[sma200.length - 1] && 
                     sma50[sma50.length - 2] <= sma200[sma200.length - 2],
        deathCross: sma50[sma50.length - 1] < sma200[sma200.length - 1] && 
                    sma50[sma50.length - 2] >= sma200[sma200.length - 2],
        aboveSMA20: currentPrice > sma20[sma20.length - 1],
        aboveSMA50: currentPrice > sma50[sma50.length - 1],
        aboveSMA200: currentPrice > sma200[sma200.length - 1]
      },
      timestamp: new Date()
    }

    await this.redis.setex(cacheKey, 300, JSON.stringify(result))

    return result
  }

  /**
   * 볼린저 밴드 계산
   */
  async getBollingerBands(
    ticker: string, 
    period: number = 20, 
    stdDev: number = 2
  ): Promise<BollingerBandsData> {
    const cacheKey = `bb:${ticker}:${period}:${stdDev}`
    const cached = await this.redis.get(cacheKey)
    if (cached) {
      return JSON.parse(cached)
    }

    const historicalData = await this.stockDataAPI.getHistoricalData(ticker, '3m')
    const closePrices = historicalData.map(d => d.close)

    const bbResult = technicalIndicators.BollingerBands.calculate({
      values: closePrices,
      period,
      stdDev
    })

    const current = bbResult[bbResult.length - 1]
    const currentPrice = closePrices[closePrices.length - 1]

    const result: BollingerBandsData = {
      ticker,
      upperBand: current.upper,
      middleBand: current.middle,
      lowerBand: current.lower,
      bandwidth: current.upper - current.lower,
      percentB: (currentPrice - current.lower) / (current.upper - current.lower),
      squeeze: this.detectBBSqueeze(bbResult.slice(-20)),
      signal: this.interpretBollingerBands(currentPrice, current),
      timestamp: new Date()
    }

    await this.redis.setex(cacheKey, 300, JSON.stringify(result))

    return result
  }

  /**
   * 종합 기술적 분석
   */
  async getComprehensiveAnalysis(ticker: string): Promise<ComprehensiveAnalysis> {
    const [rsi, macd, ma, bb] = await Promise.all([
      this.getRSI(ticker),
      this.getMACD(ticker),
      this.getMovingAverages(ticker),
      this.getBollingerBands(ticker)
    ])

    // 각 지표의 신호를 종합
    const signals = {
      rsi: rsi.signal,
      macd: macd.trend,
      ma: this.interpretMASignals(ma.signals),
      bb: bb.signal
    }

    // 전체적인 추천
    const recommendation = this.generateRecommendation(signals)

    return {
      ticker,
      indicators: { rsi, macd, ma, bb },
      signals,
      recommendation,
      strength: this.calculateSignalStrength(signals),
      timestamp: new Date()
    }
  }

  /**
   * RSI 해석
   */
  private interpretRSI(value: number): 'buy' | 'sell' | 'neutral' {
    if (value < 30) return 'buy'      // 과매도
    if (value > 70) return 'sell'     // 과매수
    return 'neutral'
  }

  /**
   * MACD 크로스오버 감지
   */
  private detectMACDCrossover(current: any, previous: any): 'golden' | 'death' | 'none' {
    if (current.MACD > current.signal && previous.MACD <= previous.signal) {
      return 'golden' // 골든 크로스
    }
    if (current.MACD < current.signal && previous.MACD >= previous.signal) {
      return 'death' // 데드 크로스
    }
    return 'none'
  }

  /**
   * 볼린저 밴드 수축 감지
   */
  private detectBBSqueeze(bbData: any[]): boolean {
    const bandwidths = bbData.map(d => d.upper - d.lower)
    const avgBandwidth = bandwidths.reduce((a, b) => a + b) / bandwidths.length
    const currentBandwidth = bandwidths[bandwidths.length - 1]
    
    return currentBandwidth < avgBandwidth * 0.8 // 평균의 80% 이하면 수축
  }

  /**
   * 볼린저 밴드 해석
   */
  private interpretBollingerBands(price: number, bb: any): 'buy' | 'sell' | 'neutral' {
    if (price < bb.lower) return 'buy'
    if (price > bb.upper) return 'sell'
    return 'neutral'
  }

  /**
   * 이동평균 신호 해석
   */
  private interpretMASignals(signals: any): 'bullish' | 'bearish' | 'neutral' {
    const bullishCount = Object.values(signals).filter(v => v === true).length
    if (bullishCount >= 3) return 'bullish'
    if (bullishCount <= 1) return 'bearish'
    return 'neutral'
  }

  /**
   * 종합 추천 생성
   */
  private generateRecommendation(signals: any): 'strong_buy' | 'buy' | 'hold' | 'sell' | 'strong_sell' {
    let score = 0
    
    // RSI
    if (signals.rsi === 'buy') score += 2
    else if (signals.rsi === 'sell') score -= 2
    
    // MACD
    if (signals.macd === 'bullish') score += 2
    else if (signals.macd === 'bearish') score -= 2
    
    // MA
    if (signals.ma === 'bullish') score += 2
    else if (signals.ma === 'bearish') score -= 2
    
    // BB
    if (signals.bb === 'buy') score += 1
    else if (signals.bb === 'sell') score -= 1

    if (score >= 5) return 'strong_buy'
    if (score >= 2) return 'buy'
    if (score <= -5) return 'strong_sell'
    if (score <= -2) return 'sell'
    return 'hold'
  }

  /**
   * 신호 강도 계산
   */
  private calculateSignalStrength(signals: any): number {
    let alignedSignals = 0
    const signalValues = Object.values(signals)
    
    const bullishSignals = signalValues.filter(s => 
      s === 'buy' || s === 'bullish' || s === 'golden'
    ).length
    
    const bearishSignals = signalValues.filter(s => 
      s === 'sell' || s === 'bearish' || s === 'death'
    ).length
    
    alignedSignals = Math.max(bullishSignals, bearishSignals)
    
    return (alignedSignals / signalValues.length) * 100
  }
}

// 타입 정의
export interface RSIData {
  ticker: string
  period: number
  value: number
  previousValue: number
  signal: 'buy' | 'sell' | 'neutral'
  overbought: boolean
  oversold: boolean
  timestamp: Date
}

export interface MACDData {
  ticker: string
  macd: number
  signal: number
  histogram: number
  previousHistogram: number
  crossover: 'golden' | 'death' | 'none'
  trend: 'bullish' | 'bearish'
  timestamp: Date
}

export interface MovingAveragesData {
  ticker: string
  currentPrice: number
  sma: {
    ma20: number
    ma50: number
    ma200: number
  }
  ema: {
    ma20: number
  }
  signals: {
    goldenCross: boolean
    deathCross: boolean
    aboveSMA20: boolean
    aboveSMA50: boolean
    aboveSMA200: boolean
  }
  timestamp: Date
}

export interface BollingerBandsData {
  ticker: string
  upperBand: number
  middleBand: number
  lowerBand: number
  bandwidth: number
  percentB: number
  squeeze: boolean
  signal: 'buy' | 'sell' | 'neutral'
  timestamp: Date
}

export interface ComprehensiveAnalysis {
  ticker: string
  indicators: {
    rsi: RSIData
    macd: MACDData
    ma: MovingAveragesData
    bb: BollingerBandsData
  }
  signals: Record<string, string>
  recommendation: 'strong_buy' | 'buy' | 'hold' | 'sell' | 'strong_sell'
  strength: number // 0-100
  timestamp: Date
}

// 사용 예시
/*
const stockAPI = new StockDataAPI()
const technicalAPI = new TechnicalIndicatorsAPI(stockAPI)

// RSI 조회
const rsi = await technicalAPI.getRSI('AAPL')

// 종합 분석
const analysis = await technicalAPI.getComprehensiveAnalysis('AAPL')
console.log(`추천: ${analysis.recommendation} (신호 강도: ${analysis.strength}%)`)
*/