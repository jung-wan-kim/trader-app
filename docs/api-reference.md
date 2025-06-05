# 📊 Trader App API Reference

## 개요
Trader App API는 Professional 플랜 사용자에게 제공되는 RESTful API로, 프로그래매틱하게 추천 데이터에 접근하고 포트폴리오를 관리할 수 있습니다.

### 기본 URL
```
https://api.traderapp.com/v1
```

### 인증
모든 API 요청에는 Bearer 토큰이 필요합니다.

```bash
curl -H "Authorization: Bearer YOUR_API_TOKEN" \
     https://api.traderapp.com/v1/recommendations
```

### API 토큰 발급
1. 웹 대시보드 로그인 (https://dashboard.traderapp.com)
2. Settings > API Keys
3. "Generate New Key" 클릭
4. 토큰을 안전한 곳에 보관

## 엔드포인트

### Recommendations (추천)

#### 추천 목록 조회
```http
GET /recommendations
```

**쿼리 파라미터**
| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| action | string | 아니오 | 필터: BUY, SELL, HOLD |
| strategy | string | 아니오 | 전략: livermore, williams, weinstein |
| risk_level | string | 아니오 | 리스크: low, medium, high |
| limit | integer | 아니오 | 결과 수 제한 (기본값: 20, 최대: 100) |
| offset | integer | 아니오 | 페이지네이션 오프셋 |
| sort | string | 아니오 | 정렬: date, confidence, profit_potential |

**응답 예시**
```json
{
  "success": true,
  "data": [
    {
      "id": "rec_123456",
      "ticker": "AAPL",
      "company_name": "Apple Inc.",
      "action": "BUY",
      "strategy": {
        "name": "livermore",
        "display_name": "Jesse Livermore",
        "confidence": 0.87
      },
      "entry_price": 195.50,
      "current_price": 194.80,
      "target_price": 210.00,
      "stop_loss": 188.00,
      "risk_reward_ratio": 2.1,
      "risk_level": "medium",
      "timeframe": "swing",
      "analysis": {
        "technical": "Breaking out of consolidation pattern...",
        "fundamental": "Strong earnings growth expected..."
      },
      "created_at": "2024-01-15T09:30:00Z",
      "expires_at": "2024-01-22T16:00:00Z"
    }
  ],
  "pagination": {
    "total": 45,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

#### 특정 추천 상세 조회
```http
GET /recommendations/{recommendation_id}
```

**응답 예시**
```json
{
  "success": true,
  "data": {
    "id": "rec_123456",
    "ticker": "AAPL",
    "company_name": "Apple Inc.",
    "action": "BUY",
    "strategy": {
      "name": "livermore",
      "display_name": "Jesse Livermore",
      "confidence": 0.87,
      "details": {
        "pattern": "Cup and Handle",
        "volume_analysis": "Above average volume on breakout",
        "trend_strength": "Strong uptrend",
        "key_levels": {
          "resistance": [200.00, 205.50],
          "support": [190.00, 185.25]
        }
      }
    },
    "entry_price": 195.50,
    "current_price": 194.80,
    "target_price": 210.00,
    "stop_loss": 188.00,
    "position_size": {
      "percentage_of_portfolio": 5,
      "shares": 100,
      "dollar_amount": 19550
    },
    "risk_metrics": {
      "risk_reward_ratio": 2.1,
      "max_loss_amount": 750,
      "max_loss_percentage": 3.8,
      "expected_return_percentage": 7.7
    },
    "technical_indicators": {
      "rsi": 58.2,
      "macd": {
        "value": 1.23,
        "signal": 0.98,
        "histogram": 0.25
      },
      "moving_averages": {
        "sma_20": 192.30,
        "sma_50": 188.45,
        "sma_200": 175.80
      },
      "volume": {
        "current": 45823000,
        "average_30d": 38500000
      }
    },
    "created_at": "2024-01-15T09:30:00Z",
    "updated_at": "2024-01-15T14:45:00Z",
    "expires_at": "2024-01-22T16:00:00Z"
  }
}
```

### Portfolio (포트폴리오)

#### 포트폴리오 조회
```http
GET /portfolio
```

**응답 예시**
```json
{
  "success": true,
  "data": {
    "total_value": 125430.50,
    "total_cost": 118200.00,
    "total_gain": 7230.50,
    "total_gain_percentage": 6.12,
    "positions": [
      {
        "id": "pos_789012",
        "ticker": "AAPL",
        "shares": 100,
        "average_cost": 185.50,
        "current_price": 194.80,
        "market_value": 19480.00,
        "gain": 930.00,
        "gain_percentage": 5.01,
        "recommendation_id": "rec_123456",
        "opened_at": "2024-01-10T10:15:00Z"
      }
    ],
    "performance": {
      "day": 0.82,
      "week": 2.15,
      "month": 6.12,
      "year": 18.45
    }
  }
}
```

#### 포지션 추가
```http
POST /portfolio/positions
```

**요청 본문**
```json
{
  "ticker": "AAPL",
  "shares": 100,
  "price": 195.50,
  "recommendation_id": "rec_123456",
  "notes": "Following Livermore breakout pattern"
}
```

**응답 예시**
```json
{
  "success": true,
  "data": {
    "id": "pos_789013",
    "ticker": "AAPL",
    "shares": 100,
    "price": 195.50,
    "total_cost": 19550.00,
    "recommendation_id": "rec_123456",
    "created_at": "2024-01-15T15:30:00Z"
  }
}
```

#### 포지션 업데이트
```http
PUT /portfolio/positions/{position_id}
```

**요청 본문**
```json
{
  "shares": 150,
  "average_cost": 193.25
}
```

#### 포지션 종료
```http
POST /portfolio/positions/{position_id}/close
```

**요청 본문**
```json
{
  "price": 205.75,
  "notes": "Target reached"
}
```

### Alerts (알림)

#### 알림 목록 조회
```http
GET /alerts
```

**쿼리 파라미터**
| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| type | string | 아니오 | 알림 유형: price, news, recommendation |
| status | string | 아니오 | 상태: active, triggered, cancelled |

#### 알림 생성
```http
POST /alerts
```

**요청 본문**
```json
{
  "ticker": "AAPL",
  "type": "price",
  "condition": "above",
  "value": 200.00,
  "notification_channels": ["push", "email"]
}
```

### Analytics (분석)

#### 성과 분석
```http
GET /analytics/performance
```

**쿼리 파라미터**
| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| period | string | 아니오 | 기간: day, week, month, year, all |
| strategy | string | 아니오 | 특정 전략별 필터 |

**응답 예시**
```json
{
  "success": true,
  "data": {
    "period": "month",
    "total_trades": 24,
    "winning_trades": 18,
    "losing_trades": 6,
    "win_rate": 0.75,
    "average_gain": 8.2,
    "average_loss": -3.1,
    "profit_factor": 2.65,
    "sharpe_ratio": 1.82,
    "max_drawdown": -5.2,
    "by_strategy": {
      "livermore": {
        "trades": 10,
        "win_rate": 0.80,
        "average_return": 9.5
      },
      "williams": {
        "trades": 8,
        "win_rate": 0.625,
        "average_return": 5.8
      },
      "weinstein": {
        "trades": 6,
        "win_rate": 0.833,
        "average_return": 7.2
      }
    }
  }
}
```

#### 백테스트
```http
POST /analytics/backtest
```

**요청 본문**
```json
{
  "strategy": "livermore",
  "start_date": "2023-01-01",
  "end_date": "2023-12-31",
  "initial_capital": 100000,
  "position_size": 5,
  "filters": {
    "min_confidence": 0.7,
    "risk_levels": ["low", "medium"]
  }
}
```

**응답 예시**
```json
{
  "success": true,
  "data": {
    "summary": {
      "total_return": 28.5,
      "annualized_return": 28.5,
      "total_trades": 156,
      "win_rate": 0.712,
      "sharpe_ratio": 1.95,
      "max_drawdown": -8.3,
      "calmar_ratio": 3.43
    },
    "equity_curve": [
      {"date": "2023-01-01", "value": 100000},
      {"date": "2023-01-31", "value": 102500},
      // ... more data points
    ],
    "trades": [
      {
        "ticker": "AAPL",
        "entry_date": "2023-01-15",
        "exit_date": "2023-02-10",
        "return": 7.2
      }
      // ... more trades
    ]
  }
}
```

## 웹소켓 API

### 실시간 추천
```javascript
const ws = new WebSocket('wss://api.traderapp.com/v1/stream');

ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'YOUR_API_TOKEN'
  }));
  
  ws.send(JSON.stringify({
    type: 'subscribe',
    channels: ['recommendations', 'alerts']
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};
```

**메시지 형식**
```json
{
  "type": "recommendation",
  "action": "new",
  "data": {
    "id": "rec_123457",
    "ticker": "TSLA",
    "action": "BUY",
    "strategy": "williams",
    "confidence": 0.82
  }
}
```

## 에러 처리

### 에러 응답 형식
```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMETER",
    "message": "The 'limit' parameter must be between 1 and 100",
    "field": "limit"
  }
}
```

### 에러 코드
| 코드 | HTTP 상태 | 설명 |
|------|----------|------|
| UNAUTHORIZED | 401 | 유효하지 않은 API 토큰 |
| FORBIDDEN | 403 | 권한 없음 (Professional 플랜 필요) |
| NOT_FOUND | 404 | 리소스를 찾을 수 없음 |
| INVALID_PARAMETER | 400 | 잘못된 파라미터 |
| RATE_LIMIT_EXCEEDED | 429 | API 호출 한도 초과 |
| INTERNAL_ERROR | 500 | 서버 내부 오류 |

## Rate Limiting
- Professional 플랜: 분당 300 요청
- 헤더에서 제한 정보 확인 가능:
  ```
  X-RateLimit-Limit: 300
  X-RateLimit-Remaining: 298
  X-RateLimit-Reset: 1642531200
  ```

## SDK

### Python
```bash
pip install traderapp-sdk
```

```python
from traderapp import Client

client = Client(api_key='YOUR_API_KEY')

# 추천 조회
recommendations = client.recommendations.list(
    action='BUY',
    strategy='livermore',
    limit=10
)

# 포지션 추가
position = client.portfolio.add_position(
    ticker='AAPL',
    shares=100,
    price=195.50
)

# 백테스트 실행
backtest = client.analytics.backtest(
    strategy='livermore',
    start_date='2023-01-01',
    end_date='2023-12-31',
    initial_capital=100000
)
```

### JavaScript/TypeScript
```bash
npm install @traderapp/sdk
```

```javascript
import { TraderAppClient } from '@traderapp/sdk';

const client = new TraderAppClient({
  apiKey: 'YOUR_API_KEY'
});

// 추천 조회
const recommendations = await client.recommendations.list({
  action: 'BUY',
  strategy: 'livermore',
  limit: 10
});

// 실시간 스트림
client.stream.connect();
client.stream.subscribe('recommendations', (data) => {
  console.log('New recommendation:', data);
});
```

### cURL 예제
```bash
# 추천 목록 조회
curl -X GET "https://api.traderapp.com/v1/recommendations?action=BUY&limit=5" \
  -H "Authorization: Bearer YOUR_API_KEY"

# 포지션 추가
curl -X POST "https://api.traderapp.com/v1/portfolio/positions" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ticker": "AAPL",
    "shares": 100,
    "price": 195.50
  }'
```

## Webhook

Professional 플랜 사용자는 특정 이벤트 발생 시 Webhook을 통해 알림을 받을 수 있습니다.

### Webhook 설정
대시보드 > Settings > Webhooks에서 설정

### 이벤트 유형
- `recommendation.new` - 새로운 추천
- `recommendation.updated` - 추천 업데이트
- `alert.triggered` - 알림 트리거
- `position.target_reached` - 목표가 도달
- `position.stop_loss_hit` - 손절가 도달

### Webhook 페이로드
```json
{
  "event": "recommendation.new",
  "timestamp": "2024-01-15T09:30:00Z",
  "data": {
    "id": "rec_123456",
    "ticker": "AAPL",
    "action": "BUY",
    "strategy": "livermore"
  }
}
```

## 지원

### API 지원
- **이메일**: api-support@traderapp.com
- **개발자 포럼**: https://developers.traderapp.com
- **API 상태**: https://status.traderapp.com

---

최종 업데이트: 2024년 1월