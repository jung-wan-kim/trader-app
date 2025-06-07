# Trader App 테스트 자동화 가이드

## 개요

이 문서는 Trader App의 테스트 자동화 시스템에 대해 설명합니다. 로컬 개발 환경과 CI/CD 파이프라인에서 테스트를 실행하고 관리하는 방법을 다룹니다.

## 목차

1. [테스트 구조](#테스트-구조)
2. [로컬 테스트 실행](#로컬-테스트-실행)
3. [테스트 자동화 스크립트](#테스트-자동화-스크립트)
4. [GitHub Actions CI/CD](#github-actions-cicd)
5. [테스트 커버리지](#테스트-커버리지)
6. [문제 해결](#문제-해결)

## 테스트 구조

```
test/
├── unit/               # 단위 테스트
│   ├── models/        # 모델 테스트
│   ├── providers/     # Provider 테스트
│   ├── services/      # 서비스 테스트
│   └── utils/         # 유틸리티 테스트
├── widget/            # 위젯 테스트
├── integration/       # 통합 테스트
├── performance/       # 성능 테스트
├── e2e/              # E2E 테스트
└── helpers/          # 테스트 헬퍼
```

## 로컬 테스트 실행

### 기본 명령어

```bash
# 모든 테스트 실행
flutter test

# 특정 디렉토리 테스트 실행
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/

# 커버리지와 함께 실행
flutter test --coverage

# 특정 파일 실행
flutter test test/unit/providers/subscription_provider_test.dart
```

### 통합 테스트 실행

```bash
# 전체 앱 플로우 테스트
flutter test integration_test/full_app_flow_test.dart

# 실제 디바이스/시뮬레이터에서 실행
flutter drive --target=test_driver/integration_test.dart
```

## 테스트 자동화 스크립트

### test-automation.sh 사용법

```bash
# 기본 실행 (단위, 위젯, 통합 테스트)
./scripts/test-automation.sh

# 전체 앱 플로우 테스트 포함
./scripts/test-automation.sh full

# 성능 테스트 포함
./scripts/test-automation.sh performance
```

### 스크립트 기능

1. **자동 정리**: 이전 테스트 결과 제거
2. **의존성 설치**: Flutter pub get 실행
3. **코드 분석**: Flutter analyze 실행
4. **순차적 테스트**: 단위 → 위젯 → 통합 테스트
5. **커버리지 생성**: HTML 리포트 자동 생성
6. **결과 요약**: 색상으로 구분된 결과 표시

## GitHub Actions CI/CD

### 워크플로우 구성

`.github/workflows/test.yml` 파일이 다음 작업을 수행합니다:

#### 1. 테스트 Job
- Ubuntu 최신 버전에서 실행
- Flutter 3.32.1 설정
- 코드 분석 및 테스트 실행
- 커버리지 리포트 생성 및 업로드

#### 2. 통합 테스트 Job
- macOS에서 실행 (시뮬레이터 지원)
- 통합 테스트 실행

#### 3. 빌드 Jobs
- Android APK 빌드 (디버그)
- iOS 빌드 (코드 서명 없음)

### 트리거 조건

- `main`, `develop` 브랜치에 push
- `main`, `develop` 브랜치로의 Pull Request

### 아티팩트

- **coverage-report**: HTML 커버리지 리포트
- **app-debug**: Android APK 파일

## 테스트 커버리지

### 커버리지 확인

```bash
# 커버리지 생성
flutter test --coverage

# HTML 리포트 생성
genhtml coverage/lcov.info -o coverage/html

# 브라우저에서 열기
open coverage/html/index.html
```

### 커버리지 목표

- **전체**: 80% 이상
- **단위 테스트**: 90% 이상
- **위젯 테스트**: 70% 이상
- **통합 테스트**: 주요 사용자 플로우 100%

## 문제 해결

### 1. SharedPreferences 에러

**문제**: 테스트에서 SharedPreferences 초기화 실패

**해결**:
```dart
setUpAll(() {
  SharedPreferences.setMockInitialValues({});
});
```

### 2. Timer 관련 에러

**문제**: 타이머가 있는 위젯 테스트 실패

**해결**:
```dart
await tester.runAsync(() async {
  // 테스트 코드
});
```

### 3. Provider 비동기 처리

**문제**: AsyncValue 처리 중 타이밍 문제

**해결**:
```dart
// 초기화 대기
await Future.delayed(const Duration(milliseconds: 500));
await tester.pump();

// AsyncValue 상태 확인
final state = container.read(provider);
state.when(
  data: (value) => /* 테스트 */,
  loading: () => /* 로딩 처리 */,
  error: (_, __) => /* 에러 처리 */,
);
```

### 4. 성능 테스트 타임아웃

**문제**: pumpAndSettle 타임아웃

**해결**:
```bash
# 타임아웃 증가
flutter test test/performance/ --timeout 120s
```

## 모범 사례

### 1. 테스트 작성 원칙

- **격리성**: 각 테스트는 독립적으로 실행 가능해야 함
- **반복성**: 동일한 결과를 보장해야 함
- **명확성**: 테스트 이름은 테스트 내용을 명확히 설명해야 함

### 2. Mock 사용

```dart
// 서비스 모킹
final mockService = MockDataService();

// Provider 오버라이드
ProviderScope(
  overrides: [
    mockDataServiceProvider.overrideWithValue(mockService),
  ],
  child: MyApp(),
);
```

### 3. 테스트 데이터 관리

```dart
// TestHelper 사용
final subscription = TestHelper.createMockSubscription();
final recommendation = TestHelper.createMockStockRecommendation();
```

### 4. 비동기 테스트

```dart
// Future 대기
await expectLater(
  container.read(provider.future),
  completion(/* matcher */),
);

// Stream 테스트
await expectLater(
  container.read(provider.stream),
  emitsInOrder([/* expected values */]),
);
```

## 지속적 개선

### 1. 테스트 메트릭 모니터링

- 테스트 실행 시간
- 테스트 안정성 (flaky test 추적)
- 커버리지 추세

### 2. 테스트 최적화

- 병렬 실행 활용
- 중복 테스트 제거
- Mock 재사용

### 3. 문서화

- 복잡한 테스트에 주석 추가
- 테스트 시나리오 문서화
- 실패 사례 기록

## 참고 자료

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Codecov Documentation](https://docs.codecov.io/)
- [Test Coverage Best Practices](https://flutter.dev/docs/testing/coverage)