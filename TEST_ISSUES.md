# 테스트 커버리지 달성을 위한 이슈 및 해결 방안

## 현재 상태
- 테스트 커버리지: 27.2% (목표: 95%)
- 통과한 테스트: 약 290개
- 실패한 테스트: 약 192개

### 진행 사항
- UI 통합 테스트 추가 완료 (integration_test/ui_integration_test.dart)
- Portfolio Provider 테스트 에러 수정 완료
- Strategy Detail Screen 테스트 에러 수정 완료
- 테스트 실행 자동화 스크립트 추가 (scripts/run-ui-tests.sh)
- TradingService 테스트 작성 완료 (100% 커버리지 달성)
- MarketService 테스트 작성 완료 (96.6% 커버리지 달성)
- PortfolioService 테스트 부분 작성 (복잡한 query builder는 skip)
- Mockito를 사용한 Supabase 모킹 구현
- FunctionResponse mock 추가로 서비스 테스트 가능

## 주요 이슈 및 해결 필요 사항

### 1. 컴파일 에러

#### Portfolio Provider 관련
- **문제**: `Portfolio` 모델이 존재하지 않음. `portfolioProvider`는 `List<Position>`을 반환
- **해결 방안**: 
  - Portfolio 모델을 생성하거나
  - 테스트를 현재 구조에 맞게 수정

#### Strategy Detail Screen 관련
- **문제**: test helper 파일 경로 오류
- **해결 방안**: `import '../helpers/test_helper.dart';`로 경로 수정

#### User Subscription 관련
- **문제**: PaymentMethod가 nullable이 아닌데 null을 할당하려고 함
- **해결 방안**: 모든 테스트에서 유효한 PaymentMethod 객체 생성

### 2. 성능 테스트 타임아웃
- **문제**: Animation performance test와 data loading performance test에서 타이머가 남아있음
- **해결 방안**: 
  - 모든 타이머를 명시적으로 취소
  - `addTearDown`으로 cleanup 보장

### 3. Mock Data 일관성
- **문제**: MockDataService의 reasoning 생성 로직이 테스트 기댓값과 불일치
- **해결 방안**: 
  - Mock 데이터 생성 로직 수정 또는
  - 테스트 기댓값을 더 유연하게 변경

### 4. 누락된 테스트 영역

#### 높은 우선순위
1. **Screens** (약 19개 화면)
   - splash_screen
   - main_screen
   - onboarding_screen
   - trader_selection_screen
   - subscription_screen
   - investment_performance_screen
   - watchlist_screen
   - position_screen
   - language_selection_screen/language_settings_screen
   - privacy_policy_screen/terms_of_service_screen

2. **Providers** 
   - stock_data_provider
   - language_provider
   - supabase_auth_provider
   - mock_data_provider

3. **Widgets**
   - 모든 커스텀 위젯들 (candle_chart 외)

4. **Services**
   - Supabase 관련 서비스
   - 실제 API 서비스 (있다면)

#### 중간 우선순위
1. **Utils/Helpers**
   - 날짜/시간 유틸리티
   - 숫자 포맷팅
   - 검증 로직

2. **Models**
   - 남은 모델들의 JSON 직렬화/역직렬화

### 5. 테스트 실행 전략

#### 단계별 접근
1. **컴파일 에러 해결** (최우선)
   - Portfolio 모델 생성 또는 테스트 수정
   - Import 경로 수정
   - Nullable 관련 이슈 해결

2. **기존 테스트 안정화**
   - 실패하는 테스트 수정
   - 타임아웃 이슈 해결

3. **새로운 테스트 추가**
   - 화면별 위젯 테스트
   - Provider 테스트
   - 서비스 레이어 테스트

4. **커버리지 측정 및 보완**
   - 부족한 부분 파악
   - 집중적으로 테스트 추가

### 6. 추정 작업량
- 컴파일 에러 수정: 2-3시간 ✓ 완료
- 기존 테스트 안정화: 3-4시간 (진행중)
- 새로운 테스트 작성: 10-15시간 (진행중)
- 총 예상 시간: 15-22시간

### 7. 현재까지 달성한 성과
- 초기 커버리지 9.11% → 27.2%로 향상 (약 3배 증가)
- 서비스 레이어 테스트 강화:
  - TradingService: 100% 커버리지
  - MarketService: 96.6% 커버리지
  - MockDataService: 100% 커버리지
- UI 통합 테스트 프레임워크 구축
- 테스트 자동화 스크립트 작성

### 7. 권장 사항
1. **Portfolio 모델 생성**: 더 체계적인 포트폴리오 관리를 위해 권장
2. **테스트 헬퍼 통합**: 모든 테스트에서 공통으로 사용할 수 있는 헬퍼 함수 정리
3. **Mock 데이터 표준화**: 일관된 테스트 데이터 생성을 위한 팩토리 패턴 적용
4. **CI/CD 통합**: 테스트 자동화 및 커버리지 리포트 자동 생성

## 즉시 해결 가능한 항목
1. Import 경로 수정
2. PaymentMethod nullable 이슈
3. 간단한 모델 테스트 추가
4. 기본적인 화면 테스트 추가

## 수동 개입이 필요한 항목
1. **Portfolio 모델 설계 결정**: 새로 만들 것인지, 현재 구조를 유지할 것인지
2. **Supabase 테스트 전략**: 실제 API 호출을 어떻게 모킹할 것인지
3. **성능 테스트 기준**: 어느 정도의 성능을 목표로 할 것인지
4. **통합 테스트 범위**: 어디까지를 통합 테스트로 커버할 것인지