import { describe, it, expect, beforeAll, afterAll } from '@jest/globals'
import request from 'supertest'
import { createClient } from '@supabase/supabase-js'
import app from '../app' // Express app

let authToken: string
let testUserId: string
let supabase: any

beforeAll(async () => {
  // Supabase 클라이언트 초기화
  supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!
  )

  // 테스트 사용자 생성
  const testUser = {
    email: 'test@example.com',
    password: 'Test123!@#',
    name: 'Test User'
  }

  const response = await request(app)
    .post('/api/auth/register')
    .send(testUser)

  expect(response.status).toBe(201)
  authToken = response.body.token
  testUserId = response.body.user.id
})

afterAll(async () => {
  // 테스트 데이터 정리
  if (testUserId) {
    await supabase.auth.admin.deleteUser(testUserId)
  }
})

describe('Auth API', () => {
  it('should login with valid credentials', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'Test123!@#'
      })

    expect(response.status).toBe(200)
    expect(response.body).toHaveProperty('token')
    expect(response.body).toHaveProperty('user')
  })

  it('should fail login with invalid credentials', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'wrongpassword'
      })

    expect(response.status).toBe(401)
  })

  it('should refresh token', async () => {
    const loginResponse = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'Test123!@#'
      })

    const refreshToken = loginResponse.body.refresh_token

    const response = await request(app)
      .post('/api/auth/refresh')
      .send({ refresh_token: refreshToken })

    expect(response.status).toBe(200)
    expect(response.body).toHaveProperty('token')
  })
})

describe('Recommendations API', () => {
  it('should get recommendations with auth', async () => {
    const response = await request(app)
      .get('/api/recommendations')
      .set('Authorization', `Bearer ${authToken}`)

    expect(response.status).toBe(200)
    expect(response.body).toHaveProperty('recommendations')
    expect(Array.isArray(response.body.recommendations)).toBe(true)
  })

  it('should fail without auth', async () => {
    const response = await request(app)
      .get('/api/recommendations')

    expect(response.status).toBe(401)
  })

  it('should filter recommendations by strategy type', async () => {
    const response = await request(app)
      .get('/api/recommendations?strategy_type=momentum')
      .set('Authorization', `Bearer ${authToken}`)

    expect(response.status).toBe(200)
    // 모든 추천이 momentum 전략인지 확인
    response.body.recommendations.forEach((rec: any) => {
      expect(rec.trader_strategies.type).toBe('momentum')
    })
  })
})

describe('Portfolio API', () => {
  let portfolioId: string

  it('should get user portfolio', async () => {
    const response = await request(app)
      .get('/api/portfolio')
      .set('Authorization', `Bearer ${authToken}`)

    expect(response.status).toBe(200)
    expect(response.body).toHaveProperty('portfolio')
    portfolioId = response.body.portfolio.id
  })

  it('should create a position', async () => {
    const response = await request(app)
      .post('/api/portfolio/positions')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        ticker: 'AAPL',
        action: 'BUY',
        quantity: 10,
        order_type: 'market'
      })

    expect(response.status).toBe(201)
    expect(response.body).toHaveProperty('position')
    expect(response.body.position.ticker).toBe('AAPL')
  })

  it('should fail to create position with insufficient funds', async () => {
    const response = await request(app)
      .post('/api/portfolio/positions')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        ticker: 'AAPL',
        action: 'BUY',
        quantity: 10000, // 너무 많은 수량
        order_type: 'market'
      })

    expect(response.status).toBe(400)
    expect(response.body.error).toContain('구매력이 부족')
  })
})

describe('Subscription API', () => {
  it('should get subscription plans', async () => {
    const response = await request(app)
      .get('/api/subscriptions/plans')

    expect(response.status).toBe(200)
    expect(response.body).toHaveProperty('plans')
    expect(response.body.plans.length).toBeGreaterThan(0)
  })

  it('should get subscription history', async () => {
    const response = await request(app)
      .get('/api/subscriptions/history')
      .set('Authorization', `Bearer ${authToken}`)

    expect(response.status).toBe(200)
    expect(response.body).toHaveProperty('events')
  })
})

describe('Rate Limiting', () => {
  it('should enforce rate limits for free users', async () => {
    // 무료 사용자의 일일 한도(100)를 초과하는 요청 시뮬레이션
    const requests = []
    
    // 병렬로 많은 요청 보내기
    for (let i = 0; i < 110; i++) {
      requests.push(
        request(app)
          .get('/api/recommendations')
          .set('Authorization', `Bearer ${authToken}`)
      )
    }

    const responses = await Promise.all(requests)
    
    // 일부 요청은 429 상태를 반환해야 함
    const rateLimitedResponses = responses.filter(r => r.status === 429)
    expect(rateLimitedResponses.length).toBeGreaterThan(0)
  })
})

describe('Security', () => {
  it('should reject invalid JWT tokens', async () => {
    const response = await request(app)
      .get('/api/portfolio')
      .set('Authorization', 'Bearer invalid-token')

    expect(response.status).toBe(401)
  })

  it('should handle SQL injection attempts', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: "test@example.com'; DROP TABLE users; --",
        password: 'password'
      })

    expect(response.status).toBe(401)
    
    // 사용자 테이블이 여전히 존재하는지 확인
    const { data } = await supabase.from('users').select('id').limit(1)
    expect(data).toBeDefined()
  })

  it('should enforce CORS policies', async () => {
    const response = await request(app)
      .get('/api/recommendations')
      .set('Origin', 'http://malicious-site.com')
      .set('Authorization', `Bearer ${authToken}`)

    // CORS 헤더 확인
    expect(response.headers['access-control-allow-origin']).not.toBe('http://malicious-site.com')
  })
})