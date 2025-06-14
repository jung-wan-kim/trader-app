import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../base/base_test.dart';
import '../pages/onboarding_page.dart';
import '../pages/login_page.dart';
import '../pages/trader_selection_page.dart';
import '../pages/subscription_page.dart';
import '../pages/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('신규 사용자 완전 여정 테스트', () {
    late BaseUITest baseTest;
    
    setUp(() {
      baseTest = BaseUITest();
    });
    
    testWidgets('온보딩 → 회원가입 → 트레이더 선택 → 구독 → 홈화면', (tester) async {
      await baseTest.setup(tester);
      
      // 1. 앱 최초 실행
      await baseTest.launchApp(
        isFirstLaunch: true,
        locale: 'ko',
      );
      
      // 2. 언어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      // 3. 온보딩 완료
      final onboarding = OnboardingPage(tester);
      
      // 첫 번째 페이지 검증
      onboarding.verifyPageContent(
        pageIndex: 0,
        title: 'AI가 추천하는 주식',
        description: '전문 트레이더의 전략을 AI가 분석하여 최적의 투자 기회를 제공합니다',
      );
      await onboarding.swipeToNextPage();
      
      // 두 번째 페이지 검증
      onboarding.verifyPageContent(
        pageIndex: 1,
        title: '실시간 포지션 관리',
        description: '매수부터 매도까지, 모든 투자 과정을 실시간으로 관리하세요',
      );
      await onboarding.swipeToNextPage();
      
      // 세 번째 페이지 검증
      onboarding.verifyPageContent(
        pageIndex: 2,
        title: '투명한 성과 분석',
        description: '상세한 수익률 분석과 리포트로 투자 성과를 확인하세요',
      );
      
      // 시작하기 버튼 클릭
      await onboarding.tapGetStarted();
      
      // 4. 회원가입
      final loginPage = LoginPage(tester);
      await loginPage.tapSignUp();
      
      // 회원가입 정보 입력
      await tester.enterText(find.byKey(Key('signup_email')), 'newuser@test.com');
      await tester.enterText(find.byKey(Key('signup_password')), 'Test1234!');
      await tester.enterText(find.byKey(Key('signup_password_confirm')), 'Test1234!');
      await tester.enterText(find.byKey(Key('signup_name')), '테스트사용자');
      
      // 약관 동의
      await tester.tap(find.byKey(Key('agree_all')));
      await tester.pumpAndSettle();
      
      // 회원가입 완료
      await tester.tap(find.text('가입하기'));
      await baseTest.waitForLoadingToComplete();
      
      // 5. 트레이더 선택
      final traderSelection = TraderSelectionPage(tester);
      
      // 최소 3명 선택 안내 확인
      expect(find.text('관심있는 트레이더를 3명 이상 선택해주세요'), findsOneWidget);
      
      // 트레이더 3명 선택
      await traderSelection.selectTrader(0);
      await traderSelection.selectTrader(1);
      await traderSelection.selectTrader(2);
      
      // 선택 개수 확인
      traderSelection.verifySelectedCount(3);
      traderSelection.verifyContinueButtonEnabled();
      
      // 다음 단계로
      await traderSelection.continueToNext();
      
      // 6. 구독 플랜 선택
      final subscription = SubscriptionPage(tester);
      
      // Premium 플랜 선택
      await subscription.selectPlan('Premium');
      subscription.verifyPlanSelected('Premium');
      
      // 월간 결제로 변경
      await subscription.toggleBillingCycle();
      subscription.verifyBillingCycle('월간');
      subscription.verifyPrice('Premium', '₩29,900/월');
      
      // 결제 수단 선택
      await subscription.selectPaymentMethod('Credit Card');
      
      // 카드 정보 입력
      await subscription.enterPaymentDetails(
        cardNumber: '4111111111111111',
        expiryDate: '12/25',
        cvv: '123',
        cardholderName: '테스트사용자',
      );
      
      // 구독하기
      await subscription.subscribe();
      await baseTest.waitForLoadingToComplete();
      
      // 7. 홈 화면 도착 확인
      final home = HomePage(tester);
      
      // 환영 메시지 확인
      expect(find.text('테스트사용자님, 환영합니다!'), findsOneWidget);
      
      // 추천 종목 로드 확인
      await baseTest.waitForLoadingToComplete();
      home.verifyRecommendationCount(10);
      
      // 하단 네비게이션 확인
      home.verifyTabSelected(0); // 홈 탭
      
      // 8. 첫 추천 종목 확인
      await home.selectRecommendation(0);
      
      // 상세 화면 이동 확인
      expect(find.text('AI 분석 리포트'), findsOneWidget);
      expect(find.text('포지션 생성'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('소셜 로그인으로 빠른 가입', (tester) async {
      await baseTest.setup(tester);
      
      await baseTest.launchApp(
        isFirstLaunch: true,
        locale: 'ko',
      );
      
      // 언어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      // 온보딩 스킵
      final onboarding = OnboardingPage(tester);
      await onboarding.tapSkip();
      
      // 구글 로그인 선택
      final loginPage = LoginPage(tester);
      await loginPage.tapGoogleLogin();
      
      // 구글 계정 선택 시뮬레이션
      await tester.pumpAndSettle(Duration(seconds: 2));
      
      // 추가 정보 입력 (첫 소셜 로그인)
      await tester.enterText(find.byKey(Key('additional_name')), '구글사용자');
      await tester.tap(find.text('계속'));
      await baseTest.waitForLoadingToComplete();
      
      // 트레이더 선택으로 바로 이동
      final traderSelection = TraderSelectionPage(tester);
      expect(find.text('관심있는 트레이더를 선택해주세요'), findsOneWidget);
      
      await baseTest.teardown();
    });
  });
}