# 📈 Trader App

AI 기반 주식 추천 애플리케이션 - 전설적인 트레이더들의 투자 전략을 활용한 스마트 투자 도우미

## 🚀 프로젝트 개요

제시 리버모어(Jesse Livermore), 래리 윌리엄스(Larry Williams), 스탠 와인스타인(Stan Weinstein) 등 전설적인 트레이더들의 검증된 투자 전략을 AI로 분석하여, 각 전략별로 최적의 매수/매도 포지션을 추천하는 프리미엄 구독 서비스입니다.

## ✨ 주요 기능

### 1. 전략별 주식 추천
- **제시 리버모어**: 추세 추종 및 피라미딩 전략
- **래리 윌리엄스**: 단기 모멘텀 및 변동성 돌파 전략
- **스탠 와인스타인**: 스테이지 분석 기반 중장기 투자 전략

### 2. 리스크 관리
- 📉 손절가(Stop Loss) 자동 계산
- 📈 목표가(Take Profit) 제안
- 💰 포지션 사이즈 계산기
- ⚖️ 계좌 대비 리스크 비율 관리

### 3. 구독 시스템
- **Basic**: 주간 추천 5개, 기본 분석
- **Premium**: 일일 추천, 실시간 알림, 심화 분석
- **Professional**: 모든 기능 + API 액세스, 백테스트 도구

## 🛠 기술 스택

- **Flutter** 3.0+
- **Dart** 3.0+
- **flutter_riverpod** - State Management
- **supabase_flutter** - Backend Integration
- **PostgreSQL** - Database
- **cached_network_image** - Image Caching

## 📦 설치 방법

### 필수 요구사항
- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- iOS/Android 개발 환경
- Supabase 계정

### 환경 설정

```bash
# 1. 저장소 클론
git clone https://github.com/jung-wan-kim/trader-app.git
cd trader-app

# 2. 환경 파일 설정
cp config/development.env.example config/development.env

# 3. config/development.env 파일을 열어 실제 값으로 업데이트
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_ANON_KEY=your-actual-anon-key

# 4. 의존성 설치
flutter pub get
```

### 앱 실행

```bash
# iOS 시뮬레이터에서 실행
flutter run -d iPhone

# Android 에뮬레이터에서 실행
flutter run -d android

# 웹에서 실행
flutter run -d chrome

# 사용 가능한 디바이스 확인
flutter devices
```

### 빌드

```bash
# Android APK 빌드
flutter build apk --debug    # 디버그 빌드
flutter build apk --release  # 릴리즈 빌드

# iOS 빌드
flutter build ios --debug    # 디버그 빌드
flutter build ios --release  # 릴리즈 빌드 (Xcode에서 추가 설정 필요)

# 웹 빌드
flutter build web --release
```

## 📱 지원 플랫폼

- iOS 11.0+
- Android 5.0+

## 📂 프로젝트 구조

```
lib/
├── main.dart              # 앱 진입점
├── models/               # 데이터 모델
│   ├── stock_recommendation.dart
│   ├── trader_strategy.dart
│   └── user_subscription.dart
├── screens/              # 앱 화면
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── strategy_detail_screen.dart
│   ├── position_screen.dart
│   └── subscription_screen.dart
└── widgets/              # 재사용 가능한 위젯
    ├── recommendation_card.dart
    └── risk_calculator.dart
```

## 🔧 개발 가이드라인

- **코딩 스타일**: Flutter/Dart 표준 가이드라인
- **브랜치 전략**: Git Flow
- **커밋 규칙**: Conventional Commits
- **보안**: 금융 데이터 암호화 및 안전한 API 통신

## 🧪 테스트

### 기본 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 커버리지와 함께 실행
flutter test --coverage

# 특정 테스트 파일 실행
flutter test test/unit/providers/portfolio_provider_test.dart
```

### 자동화된 테스트 스위트

```bash
# 종합 테스트 실행 (단위, 위젯, 통합 테스트)
./scripts/test-automation.sh

# 전체 앱 플로우 테스트 포함
./scripts/test-automation.sh full

# 성능 테스트 포함
./scripts/test-automation.sh performance
```

### CI/CD

- **GitHub Actions**: main/develop 브랜치에 push/PR 시 자동으로 테스트 실행
- **커버리지 리포트**: 테스트 실행 후 `coverage/html/`에서 확인 가능
- **빌드 아티팩트**: Android APK와 iOS 빌드가 자동으로 생성됨

자세한 내용은 [테스트 자동화 가이드](docs/test-automation-guide.md)를 참조하세요.

## 🤝 기여하기

프로젝트에 기여하고 싶으시다면 Pull Request를 보내주세요!

## 📄 라이선스

이 프로젝트는 비공개 프로젝트입니다.

---

Built with ❤️ using Flutter