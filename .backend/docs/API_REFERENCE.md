# API Reference

## 기본 정보

- Base URL: `https://api.tradingapp.com`
- API Version: `v1`
- Content-Type: `application/json`
- 인증: Bearer Token (JWT)

## 인증 헤더

```http
Authorization: Bearer your_jwt_token
```

## API 엔드포인트

### 1. 인증 (Authentication)

#### 1.1 회원가입

```http
POST /api/auth/register
```

**Request Body:**
```json
{
  "email": "string",
  "password": "string",
  "name": "string",
  "phone": "string?",
  "subscription_type": "free | basic | premium | vip"
}
```

**Response (201):**
```json
{
  "user": {
    "id": "uuid",
    "email": "string",
    "name": "string",
    "subscription_type": "string"
  },
  "token": "jwt_token"
}
```

**Error Responses:**
- `400`: 이미 등록된 이메일
- `500`: 서버 오류

#### 1.2 로그인

```http
POST /api/auth/login
```

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response (200):**
```json
{
  "user": {
    "id": "uuid",
    "email": "string",
    "name": "string",
    "subscription_type": "string",
    "is_verified": "boolean"
  },
  "token": "jwt_token",
  "refresh_token": "string"
}
```

#### 1.3 토큰 갱신

```http
POST /api/auth/refresh
```

**Request Body:**
```json
{
  "refresh_token": "string"
}
```

**Response (200):**
```json
{
  "token": "new_jwt_token",
  "refresh_token": "new_refresh_token"
}
```

### 2. AI 추천 (Recommendations)

#### 2.1 추천 목록 조회

```http
GET /api/recommendations
```

**Query Parameters:**
- `strategy_type`: `momentum | value | growth | dividend | sector_rotation` (optional)
- `risk_level`: `low | medium | high` (optional)
- `limit`: number (default: 20, max varies by subscription)
- `offset`: number (default: 0)

**Response (200):**
```json
{
  "recommendations": [
    {
      "id": "uuid",
      "ticker": "string",
      "action": "BUY | SELL",
      "entry_price": "number",
      "target_price": "number",
      "stop_loss": "number",
      "confidence_score": "number (0-100)",
      "rationale": "string",
      "risk_reward_ratio": "number",
      "time_horizon": "string",
      "suggested_position_size": "number",
      "available_for_level": "boolean",
      "trader_strategies": {
        "id": "uuid",
        "name": "string",
        "type": "string",
        "risk_level": "string",
        "expected_return": "number",
        "win_rate": "number"
      }
    }
  ],
  "total": "number",
  "subscription_limit": "number"
}
```

#### 2.2 실시간 추천 생성

```http
POST /api/recommendations/generate
```

**Request Body:**
```json
{
  "strategy_id": "uuid",
  "market_conditions": {
    "vix": "number",
    "market_trend": "bullish | bearish | neutral",
    "sector_performance": {
      "technology": "number",
      "finance": "number",
      "healthcare": "number"
    }
  }
}
```

**Response (201):**
```json
{
  "recommendation": {
    "id": "uuid",
    "ticker": "string",
    "action": "BUY | SELL",
    "entry_price": "number",
    "target_price": "number",
    "stop_loss": "number",
    "confidence_score": "number",
    "rationale": "string"
  },
  "strategy": {
    "name": "string",
    "type": "string",
    "risk_level": "string"
  }
}
```

### 3. 포트폴리오 (Portfolio)

#### 3.1 포트폴리오 조회

```http
GET /api/portfolio
```

**Query Parameters:**
- `portfolio_id`: uuid (optional, defaults to primary)
- `include_positions`: boolean (default: true)
- `include_history`: boolean (default: false)

**Response (200):**
```json
{
  "portfolio": {
    "id": "uuid",
    "name": "string",
    "initial_capital": "number",
    "current_value": "number",
    "total_value": "number",
    "total_pnl": "number",
    "total_pnl_percentage": "number",
    "today_pnl": "number",
    "today_pnl_percentage": "number",
    "positions_count": "number",
    "win_rate": "number",
    "avg_return": "number",
    "buying_power": "number"
  },
  "positions": [
    {
      "id": "uuid",
      "ticker": "string",
      "quantity": "number",
      "entry_price": "number",
      "current_price": "number",
      "pnl": "number",
      "pnl_percentage": "number",
      "market_value": "number",
      "opened_at": "datetime"
    }
  ],
  "history": []
}
```

#### 3.2 포지션 생성

```http
POST /api/portfolio/positions
```

**Request Body:**
```json
{
  "portfolio_id": "uuid?",
  "recommendation_id": "uuid?",
  "ticker": "string",
  "action": "BUY | SELL",
  "quantity": "number",
  "order_type": "market | limit",
  "limit_price": "number?",
  "stop_loss": "number?",
  "take_profit": "number?"
}
```

**Response (201):**
```json
{
  "position": {
    "id": "uuid",
    "portfolio_id": "uuid",
    "ticker": "string",
    "action": "string",
    "quantity": "number",
    "entry_price": "number",
    "stop_loss": "number",
    "take_profit": "number",
    "status": "open",
    "opened_at": "datetime"
  },
  "portfolio_update": {
    "buying_power": "number"
  }
}
```

### 4. 구독 (Subscriptions)

#### 4.1 구독 플랜 조회

```http
GET /api/subscriptions/plans
```

**Response (200):**
```json
{
  "plans": [
    {
      "id": "string",
      "name": "string",
      "price": "number",
      "features": ["string"],
      "limitations": {
        "daily_recommendations": "number",
        "portfolios": "number",
        "api_calls": "number",
        "real_time_alerts": "boolean",
        "advanced_analytics": "boolean"
      }
    }
  ]
}
```

#### 4.2 구독 생성/업그레이드

```http
POST /api/subscriptions/subscribe
```

**Request Body:**
```json
{
  "plan_id": "basic | premium | vip",
  "payment_method_id": "string?"
}
```

**Response (201):**
```json
{
  "subscription": {
    "id": "uuid",
    "plan_id": "string",
    "status": "string",
    "current_period_start": "datetime",
    "current_period_end": "datetime"
  },
  "payment_intent": {
    "client_secret": "string"
  }
}
```

#### 4.3 구독 취소

```http
POST /api/subscriptions/cancel
```

**Response (200):**
```json
{
  "message": "string",
  "cancel_at": "datetime"
}
```

#### 4.4 구독 내역 조회

```http
GET /api/subscriptions/history
```

**Response (200):**
```json
{
  "events": [
    {
      "id": "uuid",
      "event_type": "string",
      "from_plan": "string",
      "to_plan": "string",
      "created_at": "datetime"
    }
  ],
  "invoices": [
    {
      "id": "string",
      "amount": "number",
      "currency": "string",
      "status": "string",
      "period_start": "datetime",
      "period_end": "datetime",
      "invoice_pdf": "string"
    }
  ]
}
```

## 에러 응답 형식

모든 에러는 다음 형식을 따릅니다:

```json
{
  "error": "string",
  "message": "string?",
  "details": {}
}
```

### HTTP 상태 코드

- `200`: 성공
- `201`: 생성됨
- `400`: 잘못된 요청
- `401`: 인증 실패
- `403`: 권한 없음
- `404`: 찾을 수 없음
- `429`: 요청 한도 초과
- `500`: 서버 오류

## Rate Limiting

API 호출 제한:

| 구독 레벨 | 일일 한도 | 분당 한도 |
|----------|---------|----------|
| Free     | 100     | 10       |
| Basic    | 1,000   | 60       |
| Premium  | 5,000   | 300      |
| VIP      | 무제한   | 무제한    |

Rate limit 정보는 응답 헤더에 포함됩니다:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

## Webhook Events

구독 가능한 이벤트:

1. `recommendation.created` - 새로운 추천 생성
2. `position.opened` - 포지션 열림
3. `position.closed` - 포지션 종료
4. `alert.triggered` - 알림 발생
5. `subscription.changed` - 구독 변경

Webhook 페이로드:

```json
{
  "event": "string",
  "data": {},
  "timestamp": "datetime",
  "signature": "string"
}
```

## SDK 사용 예시

### JavaScript/TypeScript

```typescript
import { TradingAPI } from '@tradingapp/sdk'

const api = new TradingAPI({
  apiKey: 'your_api_key'
})

// 추천 조회
const recommendations = await api.recommendations.list({
  strategyType: 'momentum',
  limit: 10
})

// 포지션 생성
const position = await api.portfolio.createPosition({
  ticker: 'AAPL',
  action: 'BUY',
  quantity: 10
})
```

### Python

```python
from tradingapp import TradingAPI

api = TradingAPI(api_key='your_api_key')

# 추천 조회
recommendations = api.recommendations.list(
    strategy_type='momentum',
    limit=10
)

# 포지션 생성
position = api.portfolio.create_position(
    ticker='AAPL',
    action='BUY',
    quantity=10
)
```