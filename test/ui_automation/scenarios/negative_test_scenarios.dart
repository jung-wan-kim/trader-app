import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../base/base_test.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/position_page.dart';
import '../pages/subscription_page.dart';
import '../helpers/mock_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Negative 테스트 시나리오 - 오류 상황 처리', () {
    late BaseUITest baseTest;
    
    setUp(() {
      baseTest = BaseUITest();
    });
    
    testWidgets('네트워크 오류 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 네트워크 오류 상태 설정
      baseTest.container = ProviderContainer(
        overrides: MockProviders.getErrorOverrides(),
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 1. 홈 화면 네트워크 오류
      home.verifyErrorState('네트워크 연결을 확인해주세요');
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
      
      // 재시도 버튼 탭
      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();
      
      // 여전히 오류 상태
      home.verifyErrorState('네트워크 연결을 확인해주세요');
      
      // 2. 포지션 탭 네트워크 오류
      await home.navigateToTab(2);
      await tester.pumpAndSettle();
      
      expect(find.text('데이터를 불러올 수 없습니다'), findsOneWidget);
      
      // 3. Pull to refresh 시도
      await tester.drag(
        find.byType(RefreshIndicator).first,
        const Offset(0, 300),
      );
      await tester.pumpAndSettle();
      
      // 오류 스낵바 표시
      expect(find.text('네트워크 오류가 발생했습니다'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('인증 오류 및 세션 만료 처리', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 세션 만료 시뮬레이션
      baseTest.container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) => null),
          ...MockProviders.getUnauthenticatedOverrides(),
        ],
      );
      
      // API 호출 시도 (새로고침)
      await home.pullToRefresh();
      
      // 인증 오류 다이얼로그
      expect(find.text('세션이 만료되었습니다'), findsOneWidget);
      expect(find.text('다시 로그인해주세요'), findsOneWidget);
      
      // 확인 버튼 탭
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();
      
      // 로그인 화면으로 이동 확인
      expect(find.byType(LoginPage), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('로그인 입력 검증 오류', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isFirstLaunch: false);
      
      final login = LoginPage(tester);
      
      // 1. 빈 필드로 로그인 시도
      await login.tapLogin();
      
      login.verifyEmailError('이메일을 입력해주세요');
      login.verifyPasswordError('비밀번호를 입력해주세요');
      login.verifyLoginButtonDisabled();
      
      // 2. 잘못된 이메일 형식
      await login.enterEmail('invalid-email');
      await login.enterPassword('password');
      
      login.verifyEmailError('올바른 이메일 형식이 아닙니다');
      
      // 3. 짧은 비밀번호
      await login.clearFields();
      await login.enterEmail('test@example.com');
      await login.enterPassword('123');
      
      login.verifyPasswordError('비밀번호는 8자 이상이어야 합니다');
      
      // 4. 잘못된 로그인 정보
      await login.clearFields();
      await login.login('wrong@example.com', 'wrongpassword');
      await baseTest.waitForLoadingToComplete();
      
      login.verifyGeneralError('이메일 또는 비밀번호가 올바르지 않습니다');
      
      // 5. 너무 많은 로그인 시도
      for (int i = 0; i < 5; i++) {
        await login.clearFields();
        await login.login('test@example.com', 'wrong$i');
        await tester.pumpAndSettle();
      }
      
      login.verifyGeneralError('너무 많은 시도로 계정이 잠겼습니다. 10분 후 다시 시도해주세요');
      
      await baseTest.teardown();
    });
    
    testWidgets('포지션 생성 시 입력 검증', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 추천 상세로 이동
      await home.selectRecommendation(0);
      await tester.tap(find.text('포지션 생성'));
      
      // 1. 수량 미입력
      await tester.tap(find.text('확인'));
      expect(find.text('수량을 입력해주세요'), findsOneWidget);
      
      // 2. 0 입력
      await tester.enterText(find.byKey(Key('quantity_input')), '0');
      await tester.tap(find.text('확인'));
      expect(find.text('1주 이상 입력해주세요'), findsOneWidget);
      
      // 3. 음수 입력
      await tester.enterText(find.byKey(Key('quantity_input')), '-10');
      await tester.tap(find.text('확인'));
      expect(find.text('올바른 수량을 입력해주세요'), findsOneWidget);
      
      // 4. 너무 큰 수량
      await tester.enterText(find.byKey(Key('quantity_input')), '1000000');
      await tester.tap(find.text('확인'));
      expect(find.text('최대 999,999주까지 가능합니다'), findsOneWidget);
      
      // 5. 잔액 부족
      await tester.enterText(find.byKey(Key('quantity_input')), '10000');
      await tester.tap(find.text('확인'));
      expect(find.text('잔액이 부족합니다'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('결제 오류 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 무료 사용자로 시작
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          MockProviders.subscriptionWithTier(SubscriptionTier.free),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      final subscription = SubscriptionPage(tester);
      
      // 구독 페이지로 이동
      await home.navigateToTab(4); // 프로필
      await tester.tap(find.text('구독 관리'));
      await tester.pumpAndSettle();
      
      // Premium 선택
      await subscription.selectPlan('Premium');
      
      // 1. 잘못된 카드 번호
      await subscription.selectPaymentMethod('Credit Card');
      await subscription.enterPaymentDetails(
        cardNumber: '1234567890123456',
        expiryDate: '12/25',
        cvv: '123',
      );
      await subscription.subscribe();
      await baseTest.waitForLoadingToComplete();
      
      expect(find.text('카드 번호가 올바르지 않습니다'), findsOneWidget);
      
      // 2. 만료된 카드
      await subscription.enterPaymentDetails(
        cardNumber: '4111111111111111',
        expiryDate: '01/20',
        cvv: '123',
      );
      await subscription.subscribe();
      await baseTest.waitForLoadingToComplete();
      
      expect(find.text('카드가 만료되었습니다'), findsOneWidget);
      
      // 3. 결제 거절
      await subscription.enterPaymentDetails(
        cardNumber: '4000000000000002', // 테스트용 거절 카드
        expiryDate: '12/25',
        cvv: '123',
      );
      await subscription.subscribe();
      await baseTest.waitForLoadingToComplete();
      
      expect(find.text('결제가 거절되었습니다'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('API 타임아웃 처리', (tester) async {
      await baseTest.setup(tester);
      
      // 느린 응답 시뮬레이션
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          MockProviders.recommendationsWithDelay(Duration(seconds: 10)),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      // 로딩 표시 확인
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // 5초 후 타임아웃
      await tester.pump(Duration(seconds: 5));
      
      // 타임아웃 오류 메시지
      expect(find.text('요청 시간이 초과되었습니다'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('권한 없는 접근 시도', (tester) async {
      await baseTest.setup(tester);
      
      // Basic 구독자로 설정
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          MockProviders.subscriptionWithTier(SubscriptionTier.basic),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // Premium 기능 접근 시도
      await home.navigateToTab(4); // 프로필
      await tester.tap(find.text('고급 분석 도구'));
      
      // 권한 없음 다이얼로그
      expect(find.text('Premium 구독이 필요합니다'), findsOneWidget);
      expect(find.text('이 기능을 사용하려면 Premium 이상의 구독이 필요합니다'), findsOneWidget);
      expect(find.text('업그레이드'), findsOneWidget);
      
      await baseTest.teardown();
    });
  });
}