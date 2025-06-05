# Backend Development Guide

이 폴더는 Trader App의 백엔드 관련 모든 코드와 설정을 포함합니다. 앱 개발이 완료된 후 백엔드 RP가 이 폴더를 기반으로 실제 백엔드를 구현할 예정입니다.

## 📁 폴더 구조

```
.backend/
├── api/                    # API 엔드포인트 정의
│   ├── stock-recommendations.js
│   └── trading-strategies.js
├── database/              # 데이터베이스 스키마 및 마이그레이션
│   └── schema.sql
├── supabase/             # Supabase 설정 및 마이그레이션
│   ├── config.js
│   └── migrations/
└── docs/                 # 백엔드 관련 문서
```

## 🔑 주요 API 엔드포인트

### 1. 주식 추천 API
- `GET /api/recommendations/:strategy` - 전략별 추천 조회
- `GET /api/recommendations/:id/details` - 추천 상세 정보
- `POST /api/calculate-position` - 포지션 사이즈 계산

### 2. 사용자 관리 API
- `POST /api/auth/signup` - 회원가입
- `POST /api/auth/login` - 로그인
- `GET /api/users/profile` - 프로필 조회
- `PUT /api/users/subscription` - 구독 관리

### 3. 포트폴리오 API
- `GET /api/portfolio` - 포트폴리오 조회
- `POST /api/portfolio/positions` - 포지션 추가
- `PUT /api/portfolio/positions/:id` - 포지션 업데이트

## 💾 데이터베이스 스키마

### 주요 테이블
1. **users** - 사용자 정보
2. **subscription_plans** - 구독 플랜
3. **trading_strategies** - 트레이딩 전략
4. **stock_recommendations** - 주식 추천
5. **user_portfolios** - 사용자 포트폴리오
6. **notification_settings** - 알림 설정
7. **trading_history** - 거래 내역
8. **market_data_cache** - 시장 데이터 캐시

## 🔧 기술 스택 (예정)

- **Backend Framework**: Node.js + Express 또는 Supabase Edge Functions
- **Database**: PostgreSQL (Supabase)
- **Authentication**: Supabase Auth
- **Real-time**: Supabase Realtime
- **Storage**: Supabase Storage
- **External APIs**: 
  - 실시간 주가 데이터 API
  - 기술적 지표 계산 API
  - 뉴스 및 공시 API

## 📝 개발 시 고려사항

1. **보안**
   - API 키 관리
   - 사용자 인증/인가
   - 데이터 암호화

2. **성능**
   - 캐싱 전략
   - 데이터베이스 인덱싱
   - API 요청 제한

3. **확장성**
   - 마이크로서비스 아키텍처 고려
   - 메시지 큐 도입
   - 로드 밸런싱

## 🚀 백엔드 개발 단계

1. **Phase 1**: 기본 API 구현
   - 사용자 인증
   - 기본 CRUD 작업
   - 더미 데이터 제공

2. **Phase 2**: 핵심 기능 구현
   - 실제 주식 데이터 연동
   - 추천 알고리즘 구현
   - 실시간 알림

3. **Phase 3**: 고급 기능
   - AI/ML 모델 통합
   - 백테스트 기능
   - 성능 최적화

## 📌 참고사항

- 이 폴더의 코드는 백엔드 개발을 위한 가이드라인입니다
- 실제 구현 시 보안과 성능을 최우선으로 고려해야 합니다
- 모든 API는 RESTful 원칙을 따르며, 필요시 GraphQL도 고려할 수 있습니다