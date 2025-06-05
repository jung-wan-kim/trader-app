import axios from 'axios'
import { Redis } from 'ioredis'

/**
 * 주가 데이터 API 통합 클래스
 * 
 * 지원 API:
 * - Yahoo Finance
 * - Alpha Vantage
 * - IEX Cloud
 * - Polygon.io
 */
export class StockDataAPI {
  private redis: Redis
  private cacheExpiry = 60 // 1분 캐시

  constructor() {
    this.redis = new Redis(process.env.REDIS_URL!)
  }

  /**
   * 실시간 주가 조회
   */
  async getQuote(ticker: string): Promise<StockQuote> {
    // 캐시 확인
    const cached = await this.redis.get(`quote:${ticker}`)
    if (cached) {
      return JSON.parse(cached)
    }

    // API 우선순위에 따라 시도
    let quote: StockQuote | null = null

    try {
      // 1. Yahoo Finance (무료, 제한 있음)
      quote = await this.getYahooQuote(ticker)
    } catch (error) {
      console.error('Yahoo Finance error:', error)
      
      try {
        // 2. IEX Cloud (유료, 안정적)
        quote = await this.getIEXQuote(ticker)
      } catch (iexError) {
        console.error('IEX Cloud error:', iexError)
        
        // 3. Alpha Vantage (무료 티어 있음)
        quote = await this.getAlphaVantageQuote(ticker)
      }
    }

    if (!quote) {
      throw new Error(`Failed to get quote for ${ticker}`)
    }

    // 캐시 저장
    await this.redis.setex(
      `quote:${ticker}`, 
      this.cacheExpiry, 
      JSON.stringify(quote)
    )

    return quote
  }

  /**
   * Yahoo Finance API
   */
  private async getYahooQuote(ticker: string): Promise<StockQuote> {
    const response = await axios.get(
      `https://query1.finance.yahoo.com/v8/finance/chart/${ticker}`,
      {
        headers: {
          'User-Agent': 'Mozilla/5.0'
        }
      }
    )

    const data = response.data.chart.result[0]
    const quote = data.meta
    const price = quote.regularMarketPrice

    return {
      ticker,
      price,
      change: price - quote.previousClose,
      changePercent: ((price - quote.previousClose) / quote.previousClose) * 100,
      volume: quote.regularMarketVolume,
      marketCap: quote.marketCap,
      high: quote.regularMarketDayHigh,
      low: quote.regularMarketDayLow,
      open: quote.regularMarketOpen,
      previousClose: quote.previousClose,
      timestamp: new Date(quote.regularMarketTime * 1000)
    }
  }

  /**
   * IEX Cloud API
   */
  private async getIEXQuote(ticker: string): Promise<StockQuote> {
    const token = process.env.IEX_CLOUD_TOKEN
    if (!token) {
      throw new Error('IEX Cloud token not configured')
    }

    const response = await axios.get(
      `https://cloud.iexapis.com/stable/stock/${ticker}/quote`,
      {
        params: { token }
      }
    )

    const data = response.data

    return {
      ticker,
      price: data.latestPrice,
      change: data.change,
      changePercent: data.changePercent * 100,
      volume: data.volume,
      marketCap: data.marketCap,
      high: data.high,
      low: data.low,
      open: data.open,
      previousClose: data.previousClose,
      timestamp: new Date(data.latestUpdate)
    }
  }

  /**
   * Alpha Vantage API
   */
  private async getAlphaVantageQuote(ticker: string): Promise<StockQuote> {
    const apiKey = process.env.ALPHA_VANTAGE_KEY
    if (!apiKey) {
      throw new Error('Alpha Vantage API key not configured')
    }

    const response = await axios.get(
      'https://www.alphavantage.co/query',
      {
        params: {
          function: 'GLOBAL_QUOTE',
          symbol: ticker,
          apikey: apiKey
        }
      }
    )

    const quote = response.data['Global Quote']
    const price = parseFloat(quote['05. price'])
    const previousClose = parseFloat(quote['08. previous close'])

    return {
      ticker,
      price,
      change: parseFloat(quote['09. change']),
      changePercent: parseFloat(quote['10. change percent'].replace('%', '')),
      volume: parseInt(quote['06. volume']),
      marketCap: 0, // Alpha Vantage doesn't provide market cap in quote
      high: parseFloat(quote['03. high']),
      low: parseFloat(quote['04. low']),
      open: parseFloat(quote['02. open']),
      previousClose,
      timestamp: new Date(quote['07. latest trading day'])
    }
  }

  /**
   * 과거 가격 데이터 조회
   */
  async getHistoricalData(
    ticker: string, 
    period: '1d' | '1w' | '1m' | '3m' | '1y' = '1m'
  ): Promise<HistoricalData[]> {
    const cacheKey = `historical:${ticker}:${period}`
    const cached = await this.redis.get(cacheKey)
    if (cached) {
      return JSON.parse(cached)
    }

    let data: HistoricalData[] = []

    try {
      // Polygon.io 사용 (가장 상세한 데이터)
      data = await this.getPolygonHistorical(ticker, period)
    } catch (error) {
      // Yahoo Finance 대체
      data = await this.getYahooHistorical(ticker, period)
    }

    // 캐시 저장 (더 긴 시간)
    await this.redis.setex(
      cacheKey, 
      3600, // 1시간
      JSON.stringify(data)
    )

    return data
  }

  /**
   * Polygon.io 과거 데이터
   */
  private async getPolygonHistorical(
    ticker: string, 
    period: string
  ): Promise<HistoricalData[]> {
    const apiKey = process.env.POLYGON_API_KEY
    if (!apiKey) {
      throw new Error('Polygon.io API key not configured')
    }

    const endDate = new Date()
    const startDate = new Date()
    
    switch (period) {
      case '1d': startDate.setDate(endDate.getDate() - 1); break
      case '1w': startDate.setDate(endDate.getDate() - 7); break
      case '1m': startDate.setMonth(endDate.getMonth() - 1); break
      case '3m': startDate.setMonth(endDate.getMonth() - 3); break
      case '1y': startDate.setFullYear(endDate.getFullYear() - 1); break
    }

    const response = await axios.get(
      `https://api.polygon.io/v2/aggs/ticker/${ticker}/range/1/day/${startDate.toISOString().split('T')[0]}/${endDate.toISOString().split('T')[0]}`,
      {
        params: {
          apiKey,
          adjusted: true,
          sort: 'asc'
        }
      }
    )

    return response.data.results.map((bar: any) => ({
      date: new Date(bar.t),
      open: bar.o,
      high: bar.h,
      low: bar.l,
      close: bar.c,
      volume: bar.v,
      adjustedClose: bar.c
    }))
  }

  /**
   * Yahoo Finance 과거 데이터
   */
  private async getYahooHistorical(
    ticker: string, 
    period: string
  ): Promise<HistoricalData[]> {
    const interval = period === '1d' ? '5m' : '1d'
    
    const response = await axios.get(
      `https://query1.finance.yahoo.com/v8/finance/chart/${ticker}`,
      {
        params: {
          range: period,
          interval
        },
        headers: {
          'User-Agent': 'Mozilla/5.0'
        }
      }
    )

    const result = response.data.chart.result[0]
    const timestamps = result.timestamp
    const quotes = result.indicators.quote[0]

    return timestamps.map((timestamp: number, index: number) => ({
      date: new Date(timestamp * 1000),
      open: quotes.open[index],
      high: quotes.high[index],
      low: quotes.low[index],
      close: quotes.close[index],
      volume: quotes.volume[index],
      adjustedClose: quotes.close[index]
    }))
  }

  /**
   * 실시간 스트리밍 연결 (WebSocket)
   */
  async subscribeToRealtime(
    tickers: string[], 
    onUpdate: (data: RealtimeUpdate) => void
  ): Promise<() => void> {
    // Polygon.io WebSocket 사용
    const apiKey = process.env.POLYGON_API_KEY
    if (!apiKey) {
      throw new Error('Polygon.io API key required for realtime data')
    }

    const ws = new WebSocket(`wss://socket.polygon.io/stocks`)
    
    ws.on('open', () => {
      // 인증
      ws.send(JSON.stringify({
        action: 'auth',
        params: apiKey
      }))
    })

    ws.on('message', (data: string) => {
      const message = JSON.parse(data)
      
      if (message[0].ev === 'status' && message[0].status === 'auth_success') {
        // 구독
        ws.send(JSON.stringify({
          action: 'subscribe',
          params: tickers.map(t => `T.${t}`)
        }))
      } else if (message[0].ev === 'T') {
        // 거래 업데이트
        onUpdate({
          ticker: message[0].sym,
          price: message[0].p,
          volume: message[0].s,
          timestamp: new Date(message[0].t)
        })
      }
    })

    // 연결 해제 함수 반환
    return () => {
      ws.close()
    }
  }
}

// 타입 정의
export interface StockQuote {
  ticker: string
  price: number
  change: number
  changePercent: number
  volume: number
  marketCap: number
  high: number
  low: number
  open: number
  previousClose: number
  timestamp: Date
}

export interface HistoricalData {
  date: Date
  open: number
  high: number
  low: number
  close: number
  volume: number
  adjustedClose: number
}

export interface RealtimeUpdate {
  ticker: string
  price: number
  volume: number
  timestamp: Date
}

// 사용 예시
/*
const stockAPI = new StockDataAPI()

// 실시간 가격
const quote = await stockAPI.getQuote('AAPL')

// 과거 데이터
const history = await stockAPI.getHistoricalData('AAPL', '1m')

// 실시간 스트리밍
const unsubscribe = await stockAPI.subscribeToRealtime(['AAPL', 'GOOGL'], (update) => {
  console.log(`${update.ticker}: $${update.price}`)
})
*/