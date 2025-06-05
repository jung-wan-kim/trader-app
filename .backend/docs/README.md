# Trading App Backend

AI 기반 주식 추천 및 포트폴리오 관리 백엔드 시스템

## 목차

1. [프로젝트 구조](#프로젝트-구조)
2. [시작하기](#시작하기)
3. [API 엔드포인트](#api-엔드포인트)
4. [Supabase Edge Functions](#supabase-edge-functions)
5. [데이터베이스 스키마](#데이터베이스-스키마)
6. [외부 API 연동](#외부-api-연동)
7. [보안 및 인증](#보안-및-인증)
8. [배포 가이드](#배포-가이드)

## 프로젝트 구조

```
.backend/
├── api/                      # API 엔드포인트
│   ├── auth/                # 인증 관련
│   ├── recommendations/     # AI 추천
│   ├── portfolio/          # 포트폴리오 관리
│   └── subscriptions/      # 구독 관리
├── supabase/               # Supabase 설정
│   ├── functions/          # Edge Functions
│   └── migrations/         # DB 마이그레이션
├── database/               # 데이터베이스 설정
│   ├── policies/          # RLS 정책
│   └── indexes/           # 성능 인덱스
├── external-apis/         # 외부 API 통합
├── tests/                 # 테스트 파일
└── docs/                  # 문서

```

## 시작하기

### 필수 요구사항

- Node.js 18+
- PostgreSQL 15+
- Redis
- Supabase CLI

### 환경 설정

1. 환경 변수 설정 (.env)
```bash
# Supabase
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_KEY=your_service_key

# JWT
JWT_SECRET=your_jwt_secret

# Redis
REDIS_URL=redis://localhost:6379

# Stripe (결제)
STRIPE_SECRET_KEY=your_stripe_key
STRIPE_BASIC_PRICE_ID=price_xxx
STRIPE_PREMIUM_PRICE_ID=price_xxx
STRIPE_VIP_PRICE_ID=price_xxx

# 외부 API 키
ALPHA_VANTAGE_KEY=your_key
IEX_CLOUD_TOKEN=your_token
POLYGON_API_KEY=your_key
```

2. 의존성 설치
```bash
npm install
```

3. 데이터베이스 마이그레이션
```bash
supabase db push
```

4. Edge Functions 배포
```bash
supabase functions deploy
```

## API 엔드포인트

### 인증 (Auth)

#### 회원가입
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword",
  "name": "John Doe",
  "phone": "+821012345678",
  "subscription_type": "free"
}
```

#### 로그인
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword"
}
```

#### 토큰 갱신
```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refresh_token": "your_refresh_token"
}
```

### AI 추천 (Recommendations)

#### 추천 목록 조회
```http
GET /api/recommendations?strategy_type=momentum&risk_level=medium&limit=20
Authorization: Bearer your_token

Response:
{
  "recommendations": [
    {
      "id": "uuid",
      "ticker": "AAPL",
      "action": "BUY",
      "entry_price": 175.50,
      "target_price": 185.00,
      "stop_loss": 170.00,
      "confidence_score": 85,
      "rationale": "강한 상승 모멘텀...",
      "suggested_position_size": 5000
    }
  ],
  "total": 20,
  "subscription_limit": 20
}
```

#### 실시간 추천 생성
```http
POST /api/recommendations/generate
Authorization: Bearer your_token
Content-Type: application/json

{
  "strategy_id": "uuid",
  "market_conditions": {
    "vix": 15.5,
    "market_trend": "bullish"
  }
}
```

### 포트폴리오 (Portfolio)

#### 포트폴리오 조회
```http
GET /api/portfolio?include_positions=true&include_history=false
Authorization: Bearer your_token

Response:
{
  "portfolio": {
    "id": "uuid",
    "name": "내 포트폴리오",
    "total_value": 1000000,
    "total_pnl": 15000,
    "total_pnl_percentage": 1.5,
    "positions_count": 5,
    "win_rate": 65.5
  },
  "positions": [...]
}
```

#### 포지션 생성
```http
POST /api/portfolio/positions
Authorization: Bearer your_token
Content-Type: application/json

{
  "ticker": "AAPL",
  "action": "BUY",
  "quantity": 10,
  "order_type": "market",
  "stop_loss": 170,
  "take_profit": 190
}
```

### 구독 (Subscriptions)

#### 구독 플랜 조회
```http
GET /api/subscriptions/plans

Response:
{
  "plans": [
    {
      "id": "free",
      "name": "무료",
      "price": 0,
      "features": [...],
      "limitations": {...}
    },
    {
      "id": "premium",
      "name": "프리미엄",
      "price": 29900,
      "features": [...],
      "limitations": {...}
    }
  ]
}
```

## Supabase Edge Functions

### 1. generate-recommendations
- 실행 주기: 5분마다
- 기능: AI 기반 실시간 추천 생성
- 트리거: Cron job

### 2. monitor-positions
- 실행 주기: 1분마다
- 기능: 포지션 모니터링 및 손절/익절 실행
- 알림: 실시간 푸시 알림

### 3. send-notifications
- 실행: 이벤트 기반
- 기능: 다양한 알림 발송 (푸시, 이메일)
- 지원: FCM, APNS, SendGrid

## 데이터베이스 스키마

### 주요 테이블

1. **users** - 사용자 정보
2. **trader_strategies** - AI 트레이딩 전략
3. **recommendations** - AI 추천
4. **portfolios** - 포트폴리오
5. **positions** - 포지션 (매수/매도)
6. **subscriptions** - 구독 정보

### Row Level Security (RLS)

모든 테이블에 RLS 적용:
- 사용자는 자신의 데이터만 접근 가능
- 구독 레벨에 따른 데이터 접근 제한
- 관리자 권한 분리

## 외부 API 연동

### 주가 데이터 API

```typescript
const stockAPI = new StockDataAPI()

// 실시간 가격
const quote = await stockAPI.getQuote('AAPL')

// 과거 데이터
const history = await stockAPI.getHistoricalData('AAPL', '1m')

// 실시간 스트리밍
const unsubscribe = await stockAPI.subscribeToRealtime(['AAPL'], (update) => {
  console.log(`${update.ticker}: $${update.price}`)
})
```

### 기술적 지표 API

```typescript
const technicalAPI = new TechnicalIndicatorsAPI(stockAPI)

// RSI
const rsi = await technicalAPI.getRSI('AAPL')

// 종합 분석
const analysis = await technicalAPI.getComprehensiveAnalysis('AAPL')
```

## 보안 및 인증

### JWT 인증
- Access Token: 7일 만료
- Refresh Token: 30일 만료
- 토큰 블랙리스트 관리

### API 사용량 제한
- 무료: 100회/일
- 베이직: 1,000회/일
- 프리미엄: 5,000회/일
- VIP: 무제한

### 보안 체크리스트
- [x] SQL Injection 방지 (Parameterized Queries)
- [x] XSS 방지 (입력값 검증)
- [x] CSRF 토큰
- [x] Rate Limiting
- [x] HTTPS 강제
- [x] 민감 정보 암호화

## 배포 가이드

### 1. Supabase 프로젝트 설정
```bash
# 프로젝트 초기화
supabase init

# 마이그레이션 실행
supabase db push

# Edge Functions 배포
supabase functions deploy --no-verify-jwt
```

### 2. 환경별 설정

#### 개발 환경
```bash
npm run dev
```

#### 스테이징 환경
```bash
npm run build:staging
npm run start:staging
```

#### 프로덕션 환경
```bash
npm run build:prod
npm run start:prod
```

### 3. 모니터링

- Supabase Dashboard: 실시간 쿼리 모니터링
- Sentry: 에러 트래킹
- CloudWatch: 성능 메트릭
- Grafana: 커스텀 대시보드

## 문제 해결

### 일반적인 이슈

1. **연결 풀 고갈**
   - 해결: 연결 풀 크기 증가
   - `max_connections` 설정 조정

2. **느린 쿼리**
   - 해결: 인덱스 추가
   - Query Plan 분석

3. **메모리 누수**
   - 해결: 연결 종료 확인
   - 가비지 컬렉션 모니터링

## 지원

- 이메일: support@tradingapp.com
- Discord: https://discord.gg/tradingapp
- 문서: https://docs.tradingapp.com