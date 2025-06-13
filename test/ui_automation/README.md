# Trader App UI 자동화 테스트

## 📋 개요

Trader App의 UI 자동화 테스트는 Page Object Model 패턴을 사용하여 구현되었으며, 99% 이상의 UI 커버리지를 목표로 합니다.

## 🏗️ 테스트 구조

```
test/ui_automation/
├── base/                    # 기본 테스트 프레임워크
│   ├── base_page.dart      # Page Object 기본 클래스
│   └── base_test.dart      # 테스트 기본 클래스
├── pages/                   # Page Object 구현
│   ├── home_page.dart
│   ├── login_page.dart
│   └── ...
├── helpers/                 # 테스트 헬퍼
│   ├── test_helper.dart
│   └── mock_providers.dart
├── fixtures/                # 테스트 데이터
│   └── test_data_factory.dart
├── scenarios/               # 테스트 시나리오
│   ├── critical_path_scenarios.dart
│   ├── happy_path_scenarios.dart
│   └── ...
└── goldens/                 # Visual Regression 골든 파일

```

## 🧪 테스트 카테고리

### 1. Critical Path Tests (필수 경로)
- 신규 사용자 온보딩 → 회원가입 → 구독
- 기존 사용자 로그인 → 거래
- 구독 갱신 플로우
- 포지션 관리 전체 사이클

### 2. Happy Path Tests (정상 시나리오)
- 추천 목록 탐색 및 필터링
- 포지션 생성 및 관리
- 투자 성과 분석
- 포지션 종료 및 수익 실현

### 3. Edge Case Tests (경계값)
- 빈 데이터 상태
- 대량 데이터 처리 (1000+ 항목)
- 극값 가격 표시
- 긴 텍스트 및 특수문자
- 동시 다중 작업

### 4. Negative Tests (오류 처리)
- 네트워크 오류
- 인증 오류 및 세션 만료
- 입력 검증 오류
- 결제 오류
- API 타임아웃

### 5. Accessibility Tests (접근성)
- 스크린 리더 지원
- 키보드 네비게이션
- 색맹 대응
- 터치 타겟 크기
- 폼 입력 접근성

### 6. Responsive Design Tests (반응형)
- 다양한 화면 크기 (360px ~ 1024px)
- 가로/세로 방향 전환
- 폰트 스케일링
- 다크 모드

### 7. Performance Tests (성능)
- 앱 초기 로딩 시간 (< 2초)
- 리스트 스크롤 FPS (> 55fps)
- 메모리 사용량 (< 200MB 증가)
- 화면 전환 시간 (< 300ms)

### 8. Platform Specific Tests (플랫폼별)
- iOS/Android UI 컴포넌트 차이
- 네이티브 기능 (생체 인증, 공유)
- 플랫폼별 제스처
- 시스템 UI 통합

### 9. Visual Regression Tests (시각적 회귀)
- 각 화면 골든 파일
- 다크 모드 스크린샷
- 반응형 레이아웃
- 애니메이션 키프레임

## 🚀 테스트 실행

### 전체 테스트 실행
```bash
./scripts/run_ui_tests.sh
```

### 특정 테스트만 실행
```bash
# Critical Path 테스트만
./scripts/run_ui_tests.sh -t critical

# iOS 플랫폼에서만
./scripts/run_ui_tests.sh -p ios

# 커버리지 포함
./scripts/run_ui_tests.sh -c
```

### Visual Regression 골든 파일 업데이트
```bash
./scripts/run_ui_tests.sh -t visual -u
```

## 📊 테스트 메트릭

### 목표
- **코드 커버리지**: 99%
- **UI 커버리지**: 99%
- **테스트 실행 시간**: < 10분
- **Flaky 테스트**: < 1%

### 현재 상태
- **총 테스트 케이스**: 150+
- **커버된 화면**: 모든 주요 화면
- **커버된 사용자 시나리오**: 95%
- **평균 실행 시간**: 8분

## 🛠️ 개발 가이드

### 새로운 Page Object 추가
```dart
class NewPage extends BasePage {
  NewPage(WidgetTester tester) : super(tester);
  
  // Locators
  final myButton = find.byKey(const Key('my_button'));
  
  // Actions
  Future<void> tapMyButton() async {
    await tap(myButton);
  }
  
  // Assertions
  void verifyButtonVisible() {
    expect(myButton, findsOneWidget);
  }
}
```

### 새로운 테스트 시나리오 추가
```dart
testWidgets('새로운 시나리오', (tester) async {
  await baseTest.setup(tester);
  await baseTest.launchApp(isAuthenticated: true);
  
  final page = NewPage(tester);
  await page.tapMyButton();
  page.verifyButtonVisible();
  
  await baseTest.teardown();
});
```

## 🔧 CI/CD 통합

GitHub Actions를 통해 자동으로 실행됩니다:
- PR 생성 시
- main/develop 브랜치 푸시 시
- 매일 새벽 2시 (KST)

## 📝 베스트 프랙티스

1. **Page Object 패턴 준수**: UI 로직을 테스트 로직과 분리
2. **독립적인 테스트**: 각 테스트는 독립적으로 실행 가능해야 함
3. **명확한 네이밍**: 테스트 이름은 테스트 내용을 명확히 설명
4. **적절한 대기**: `pumpAndSettle()` 사용으로 애니메이션 완료 대기
5. **Mock 데이터 사용**: 실제 API 대신 Mock Provider 사용

## 🐛 문제 해결

### 테스트가 불안정한 경우
1. 충분한 대기 시간 추가
2. `pumpAndSettle()` 대신 특정 시간 대기
3. Mock 데이터의 일관성 확인

### 골든 파일 불일치
1. 로컬에서 골든 파일 업데이트
2. 폰트 로딩 확인
3. 플랫폼별 차이 고려

### 성능 문제
1. 불필요한 위젯 리빌드 확인
2. Mock 데이터 크기 조정
3. 병렬 실행 활용