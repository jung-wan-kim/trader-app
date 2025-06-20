# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요
- **프로젝트명**: Trader App - AI 기반 주식 추천 애플리케이션
- **설명**: 전설적인 트레이더들의 투자 전략을 AI로 분석하여 매수/매도 포지션을 추천하는 구독 서비스
- **Flutter 버전**: SDK '>=3.0.0 <4.0.0'
- **상태관리**: flutter_riverpod ^2.4.9
- **백엔드**: Supabase (trader-api 프로젝트)
- **다국어 지원**: 11개 언어 (한국어, 영어, 일본어, 중국어 등)

## 핵심 명령어

### 개발 환경 설정
```bash
# 의존성 설치
flutter pub get

# 개발 서버 실행 (.env 파일 필요)
flutter run

# 특정 디바이스에서 실행
flutter run -d chrome  # 웹
flutter run -d "iPhone 14"  # iOS 시뮬레이터
```

### 빌드 명령어
```bash
# Android
flutter build apk --debug       # 디버그 빌드
flutter build apk --release     # 릴리즈 빌드

# iOS
flutter build ios --debug       # 디버그 빌드
flutter build ios --release     # 릴리즈 빌드
```

### 테스트 명령어
```bash
# 단위 테스트
flutter test test/unit/

# 위젯 테스트
flutter test test/widget/

# 통합 테스트
flutter test test/integration/

# 특정 테스트 파일 실행
flutter test test/unit/providers/portfolio_provider_test.dart

# 커버리지 포함 테스트
flutter test --coverage

# 자동화된 전체 테스트 스위트
./scripts/test-automation.sh

# 전체 앱 플로우 테스트
./scripts/test-automation.sh full

# 성능 테스트 포함
./scripts/test-automation.sh performance
```

### 코드 분석 및 포맷팅
```bash
# 정적 분석
flutter analyze

# 코드 포맷팅
dart format lib/
```

## 환경 설정
환경 변수는 `config/development.env` 파일에서 관리:
```env
SUPABASE_URL=https://lgebgddeerpxdjvtqvoi.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 아키텍처 개요

### 프로젝트 구조
```
lib/
├── main.dart                # 앱 진입점
├── config/                  # 환경 설정 (EnvConfig)
├── models/                  # 데이터 모델
│   ├── stock_recommendation.dart
│   ├── trader_strategy.dart
│   └── user_portfolio.dart
├── providers/               # Riverpod 상태 관리
│   ├── recommendations_provider.dart
│   ├── portfolio_provider.dart
│   └── tradingview_provider.dart
├── screens/                 # 화면 구성요소 (19개 화면)
│   ├── main_screen.dart
│   ├── home_screen.dart
│   └── trader_selection_screen.dart
├── services/                # 비즈니스 로직
│   ├── tradingview_webhook_service.dart
│   ├── mock_data_service.dart
│   └── supabase_auth_service.dart
├── theme/                   # 테마 및 스타일
└── widgets/                 # 재사용 가능한 위젯
```

### 핵심 서비스
1. **TradingViewWebhookService**: TradingView 웹훅에서 실시간 매매 신호 처리
2. **MockDataService**: 개발/테스트용 Mock 데이터 제공
3. **SupabaseAuthService**: 사용자 인증 관리
4. **PortfolioService**: 포트폴리오 CRUD 작업
5. **NotificationService**: 로컬 알림 처리

### 상태 관리 패턴
```dart
// Provider 사용 예시
final recommendations = ref.watch(recommendationsProvider);
final portfolio = ref.watch(portfolioProvider);

// AsyncValue 패턴
recommendations.when(
  data: (data) => /* UI 렌더링 */,
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => /* 에러 처리 */,
);
```

## 최근 주요 변경사항 (2025-06-19)
1. **TradingView Webhook 연동**
   - `tradingview_webhooks` 테이블에서 실시간 신호 가져오기
   - W%R 지표 기반 자동 매매 액션 (1=buy, 0=sell)
   - Webhook 데이터 없을 시 Mock 데이터 폴백

2. **에러 핸들링 개선**
   - 환경 변수 사용으로 하드코딩 제거
   - Null 안전성 강화
   - 타입 캐스팅 안전성 개선

## 데이터베이스 스키마 (Supabase)
- **tradingview_webhooks**: 매매 신호 저장
- **user_portfolios**: 사용자 포트폴리오
- **trader_strategies**: 트레이더별 전략 정보
- **subscriptions**: 구독 정보

## 현재 구현 상태

### 완료된 기능
- ✅ Supabase 인증 시스템
- ✅ 11개 언어 다국어 지원
- ✅ TradingView webhook 실시간 연동
- ✅ 트레이더별 추천 시스템
- ✅ 포트폴리오 관리
- ✅ 차트 시각화 (fl_chart)

### 진행 중/미완성 기능
- 🔄 Watchlist (Mock 데이터 사용 중)
- 🔄 Position 편집 기능
- 🔄 실제 결제 시스템 연동
- 🔄 Push 알림 구현
- 🔄 실시간 가격 업데이트

## 개발 시 주의사항
1. **환경 변수**: Supabase 키는 반드시 환경 변수로 관리
2. **Mock 데이터**: 개발/테스트 환경에서만 사용, 프로덕션에서는 제거
3. **다국어 지원**: 새로운 화면/기능 추가 시 반드시 다국어 지원 구현
4. **에러 핸들링**: AsyncValue 패턴을 활용한 일관된 에러 처리
5. **테스트**: 새로운 기능 추가 시 단위 테스트 작성 필수