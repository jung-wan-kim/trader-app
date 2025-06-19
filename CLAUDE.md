# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

모든 RP를 활용해서 프로젝트 진행해.

## 프로젝트 개요
- **프로젝트명**: Trader App - AI 기반 주식 추천 애플리케이션
- **Flutter 버전**: SDK '>=3.0.0 <4.0.0'
- **상태관리**: flutter_riverpod
- **백엔드**: Supabase (trader-api 프로젝트)
- **다국어 지원**: 11개 언어 (한국어, 영어, 일본어, 중국어 등)

## 최근 주요 변경사항 (2025-06-19)
1. **TradingView Webhook 연동 구현**
   - `tradingview_webhooks` 테이블에서 실시간 매수/매도 신호 가져오기
   - W%R 지표 기반 자동 매매 액션 설정 (1=buy, 0=sell)
   - Mock 데이터 폴백 지원

2. **에러 핸들링 개선**
   - 환경 변수 사용으로 하드코딩 제거
   - Null 안전성 강화
   - 타입 캐스팅 안전성 개선

## 빌드 및 테스트 명령어

### 기본 명령어
```bash
# 의존성 설치
flutter pub get

# 개발 서버 실행 (.env 파일 필요)
flutter run

# 빌드
flutter build apk --debug       # Android 디버그 빌드
flutter build ios --debug       # iOS 디버그 빌드

# 테스트 실행
flutter test                    # 단위 테스트
flutter test --coverage        # 커버리지 포함
```

## 환경 설정
환경 변수는 `config/development.env` 파일에서 관리:
```env
SUPABASE_URL=https://lgebgddeerpxdjvtqvoi.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 프로젝트 구조

### 주요 디렉토리
```
lib/
├── config/          # 환경 설정
├── models/          # 데이터 모델
├── providers/       # Riverpod 상태 관리
├── screens/         # 화면 구성요소 (19개 화면)
├── services/        # 비즈니스 로직
├── theme/           # 테마 및 스타일
└── widgets/         # 재사용 가능한 위젯
```

### 핵심 서비스
1. **TradingViewWebhookService**: 실시간 매매 신호 처리
2. **MockDataService**: 개발/테스트용 Mock 데이터
3. **MarketService**: 시장 데이터 조회
4. **PortfolioService**: 포트폴리오 관리
5. **TradingService**: 매매 실행

## 현재 구현 상태

### 완료된 기능
- ✅ 사용자 인증 (Supabase Auth)
- ✅ 다국어 지원 (11개 언어)
- ✅ TradingView webhook 연동
- ✅ 실시간 매수/매도 추천
- ✅ 포트폴리오 관리
- ✅ 차트 표시 (fl_chart)
- ✅ 구독 시스템 UI

### 진행 중/미완성 기능
- 🔄 Watchlist 화면 (Mock 데이터 사용 중)
- 🔄 Position 편집 기능 (TODO)
- 🔄  실제 결제 시스템 연동
- 🔄 Push 알림 구현
- 🔄  실시간 가격 업데이트

## 주요 Provider 사용법

### RecommendationsProvider
```dart
// TradingView 웹훅 데이터 우선, 없으면 Mock 데이터 사용
final recommendations = ref.watch(recommendationsProvider);
```

### PortfolioProvider
```dart
// 포트폴리오 데이터 접근
final portfolio = ref.watch(portfolioProvider);
```

## 테스트 전략
- 단위 테스트: `test/unit/`
- 위젯 테스트: `test/widget/`
- 통합 테스트: `test/integration/`
- UI 자동화: `test/ui_automation/`

## 주의사항
1. Supabase 키는 반드시 환경 변수로 관리
2. Mock 데이터는 개발/테스트 환경에서만 사용
3. 프로덕션 빌드 전 모든 TODO 해결 필요
4. 새로운 화면 추가 시 다국어 지원 필수

[... rest of the existing content remains unchanged ...]