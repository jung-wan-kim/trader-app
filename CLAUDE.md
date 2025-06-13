# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 빌드 및 테스트 명령어

### 기본 명령어
```bash
# 의존성 설치
flutter pub get

# 개발 서버 실행
flutter run

# 빌드
flutter build apk --debug       # Android 디버그 빌드
flutter build ios --debug       # iOS 디버그 빌드
```

### 테스트 실행
```bash
# 모든 테스트 실행 (커버리지 포함)
flutter test --coverage

# 개별 테스트 타입 실행
./scripts/run-tests.sh --unit         # 단위 테스트만
./scripts/run-tests.sh --widget       # 위젯 테스트만
./scripts/run-tests.sh --integration  # 통합 테스트만
./scripts/run-tests.sh --coverage     # 커버리지 리포트 생성

# 자동화된 전체 테스트 스위트
./scripts/test-automation.sh          # 기본 테스트 스위트
./scripts/test-automation.sh full     # 전체 앱 플로우 테스트 포함
./scripts/test-automation.sh performance  # 성능 테스트 포함

# 특정 테스트 파일 실행
flutter test test/unit/providers/portfolio_provider_test.dart
```

## 고수준 아키텍처

### 상태 관리 패턴
이 앱은 **flutter_riverpod**를 사용한 Provider 패턴으로 구성되어 있으며, 모든 비동기 상태는 **AsyncValue**로 관리됩니다. Provider들은 데이터 로딩, 에러, 성공 상태를 자동으로 처리합니다.

```dart
// Provider 사용 예시
final recommendationsProvider = StateNotifierProvider<RecommendationsNotifier, AsyncValue<List<StockRecommendation>>>
```

### 트레이딩 전략 시스템
세 명의 전설적인 트레이더의 전략을 구현:
- **Jesse Livermore**: 추세 추종 및 피라미딩 전략
- **Larry Williams**: 단기 모멘텀 및 변동성 돌파 전략  
- **Stan Weinstein**: 스테이지 분석 기반 중장기 투자 전략

각 전략은 독립적인 추천 엔진을 가지며, 리스크 수준과 시간 프레임이 다릅니다.

### 구독 시스템 구조
```
Basic → 주간 추천 5개, 기본 분석
Premium → 일일 추천, 실시간 알림, 심화 분석
Professional → 모든 기능 + API 액세스, 백테스트 도구
```

### 데이터 흐름
1. **Mock 모드** (현재): `MockDataService`가 모든 데이터 제공
2. **Production 모드**: Finnhub API + Supabase 백엔드 연동
3. 데이터는 Provider → Screen → Widget 순으로 전달

## 프로젝트별 특수 설정

### 데모 모드 (심사용)
`lib/config/app_config.dart`에서 `isDemoMode = true`로 설정되어 있을 때:
- Mock 데이터 사용 (실제 API 호출 없음)
- 테스트 계정 자동 제공
- 모든 프리미엄 기능 활성화

### Supabase 통합
- **인증**: Google OAuth, 이메일/비밀번호 로그인
- **스토리지**: 비디오 업로드용 (videos 버킷)
- **실시간**: 추천 알림용 (향후 구현)

### 다국어 지원
11개 언어 지원 (한국어, 영어, 중국어, 일본어, 스페인어, 프랑스어, 독일어, 포르투갈어, 힌디어, 아랍어)
```bash
# 언어 파일 재생성
flutter gen-l10n
```

### 환경 변수
```
config/
├── development.env  # 개발 환경
├── staging.env      # 스테이징 환경
└── production.env   # 프로덕션 환경
```

### CI/CD 파이프라인
GitHub Actions로 자동화:
- Flutter 3.32.1 사용
- 테스트 커버리지 목표: 80% 이상
- main/develop 브랜치 push/PR시 자동 실행
- Android APK, iOS 빌드 자동 생성

### 테스트 관련 주의사항
- **SharedPreferences 모킹 필수**: 테스트 시작 전 `SharedPreferences.setMockInitialValues({})` 호출
- **AsyncValue 타이밍**: Provider 초기화 후 `Future.delayed` 필요
- **성능 테스트**: 타임아웃 120초로 설정 필요

### 빌드 시 중요 사항
- Android: `google-services.json` 필요 (example 파일 참고)
- iOS: `GoogleService-Info.plist` 필요 (example 파일 참고)
- Supabase URL/Key는 main.dart에 하드코딩됨 (보안 개선 필요)