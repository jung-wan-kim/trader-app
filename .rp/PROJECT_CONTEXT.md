# 프로젝트 컨텍스트

## 프로젝트 정보
- **프로젝트명**: trader-app
- **설명**: 전설적인 트레이더들의 투자 전략을 기반으로 한 AI 주식 추천 애플리케이션
- **타입**: 모바일 앱 (주식 추천 서비스)
- **생성일**: 2025-06-06

## 프로젝트 개요
제시 리버모어(Jesse Livermore), 래리 윌리엄스(Larry Williams), 스탠 와인스타인(Stan Weinstein) 등 전설적인 트레이더들의 검증된 투자 전략을 AI로 분석하여, 각 전략별로 최적의 매수/매도 포지션을 추천하는 프리미엄 구독 서비스입니다.

### 핵심 가치 제안
- **전략별 맞춤 추천**: 각 트레이더의 고유한 투자 철학과 전략에 기반한 종목 추천
- **리스크 관리 중심**: 모든 추천에 손절가, 목표가, 포지션 사이즈 포함
- **데이터 기반 의사결정**: AI 분석을 통한 객관적이고 확률 높은 매매 기회 포착

## 프로젝트 구조
```
- App.js
- android/
- ios/
- lib/
  - main.dart
  - models/
    - stock_recommendation.dart
    - trader_strategy.dart
    - user_subscription.dart
  - screens/
    - home_screen.dart (추천 목록)
    - strategy_detail_screen.dart (전략별 상세)
    - position_screen.dart (포지션 관리)
    - subscription_screen.dart (구독 관리)
  - widgets/
    - recommendation_card.dart
    - risk_calculator.dart
- src/
  - components/
  - config/
  - screens/
- scripts/
- supabase/
  - migrations/
    - stock_recommendations.sql
    - user_subscriptions.sql
- tests/
```

## 기술 스택
- Frontend: Flutter (Dart), React Native
- Backend: Supabase
- Database: PostgreSQL (Supabase)
- Infrastructure: iOS/Android native
- API Integration: 실시간 주가 데이터, 기술적 지표 API
- AI/ML: 패턴 인식 및 전략 매칭 알고리즘

## 주요 기능
1. **전략별 주식 추천**
   - 제시 리버모어: 추세 추종 및 피라미딩 전략
   - 래리 윌리엄스: 단기 모멘텀 및 변동성 돌파 전략
   - 스탠 와인스타인: 스테이지 분석 기반 중장기 투자 전략

2. **일일/주간 추천 시스템**
   - 각 전략별 최대 5개 종목 추천
   - 매수 이유 및 기술적 분석 제공
   - 실시간 알림 기능

3. **리스크 관리 도구**
   - 손절가(Stop Loss) 자동 계산
   - 목표가(Take Profit) 제안
   - 포지션 사이즈 계산기
   - 계좌 대비 리스크 비율 관리

4. **포트폴리오 추적**
   - 추천 종목 성과 추적
   - 전략별 수익률 분석
   - 거래 히스토리 관리

5. **프리미엄 구독 시스템**
   - 월간/연간 구독 플랜
   - 구독자 전용 심화 분석 리포트
   - 실시간 매매 신호 알림

## 개발 가이드라인
- 코딩 스타일: Flutter/Dart 표준 가이드라인
- 브랜치 전략: Git Flow
- 커밋 규칙: Conventional Commits
- 보안: 금융 데이터 암호화 및 안전한 API 통신
- 성능: 실시간 주가 데이터 처리 최적화

## 비즈니스 모델
- **구독 티어**:
  - Basic: 주간 추천 5개, 기본 분석
  - Premium: 일일 추천, 실시간 알림, 심화 분석
  - Professional: 모든 기능 + API 액세스, 백테스트 도구

## 타겟 사용자
- 개인 투자자 중 체계적인 투자 전략을 원하는 사람
- 전설적인 트레이더들의 전략을 학습하고 싶은 투자자
- 리스크 관리를 중시하는 안정적인 투자자
- 구독형 투자 조언 서비스를 찾는 프리미엄 고객

## RP 활용 가이드
이 프로젝트에서는 다음과 같이 RP를 활용합니다:

### 프로젝트 특화 지시사항
각 RP는 이 프로젝트의 컨텍스트를 이해하고 작업을 수행합니다.
- 금융 앱의 특성상 정확성과 신뢰성을 최우선으로 합니다
- 사용자의 투자 결정을 돕는 도구이므로 명확하고 이해하기 쉬운 UI/UX를 구현합니다
- 실시간 데이터 처리와 알림 시스템의 안정성을 보장합니다
- 구독 결제 시스템과 사용자 데이터 보안을 철저히 관리합니다

### Claude Code 사용 예시
```bash
# 프로젝트 컨텍스트와 함께 특정 RP 활용
claude-code ".rp/PROJECT_CONTEXT.md와 .rp/backend-developer.md를 참고해서 
            주식 추천 API 엔드포인트를 구현해줘"

# 전체 팀 시뮬레이션
claude-code ".rp/PROJECT_CONTEXT.md를 기반으로 모든 RP를 활용해서 
            제시 리버모어 전략 추천 기능을 개발해줘"
```