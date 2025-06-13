import 'package:flutter_test/flutter_test.dart';
import '../base/base_test.dart';
import '../pages/onboarding_page.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../helpers/test_helper.dart';
import '../helpers/mock_providers.dart';

class CriticalPathScenarios extends BaseUITest {
  // Scenario 1: New User Complete Journey
  Future<void> newUserCompleteJourney() async {
    await performTest('New User Complete Journey', () async {
      // Launch app as first-time user
      await launchApp(isFirstLaunch: true);
      
      // Language Selection
      await _selectLanguage('한국어');
      
      // Complete Onboarding
      final onboarding = OnboardingPage(tester);
      await onboarding.completeOnboarding();
      
      // Sign Up Process
      await _completeSignUp(
        email: 'newuser@test.com',
        password: 'Test1234!',
        name: '테스트 사용자',
      );
      
      // Select Traders
      await _selectInitialTraders();
      
      // Choose Subscription
      await _selectSubscription('Premium');
      
      // Verify Home Screen
      final home = HomePage(tester);
      home.verifyRecommendationCount(10);
    });
  }
  
  // Scenario 2: Existing User Login and Trade
  Future<void> existingUserLoginAndTrade() async {
    await performTest('Existing User Login and Trade', () async {
      // Launch app as existing user
      await launchApp(isAuthenticated: false);
      
      // Login
      final login = LoginPage(tester);
      await login.login('existing@test.com', 'Test1234!');
      
      // Wait for home screen
      await helper.waitForLoadingToComplete();
      
      // View recommendations
      final home = HomePage(tester);
      home.verifyRecommendationCount(10);
      
      // Select a recommendation
      await home.selectRecommendation(0);
      
      // View details and create position
      await _createPosition(
        symbol: 'AAPL',
        quantity: 10,
        type: 'BUY',
      );
      
      // Verify position created
      await home.navigateToTab(2); // Positions tab
      _verifyPositionExists('AAPL', 10);
    });
  }
  
  // Scenario 3: Subscription Renewal Flow
  Future<void> subscriptionRenewalFlow() async {
    await performTest('Subscription Renewal Flow', () async {
      // Launch with expiring subscription
      container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          MockProviders.subscriptionWithExpiry(Duration(days: 1)),
        ],
      );
      
      await launchApp(isAuthenticated: true);
      
      // Verify renewal banner
      expect(find.text('구독이 곧 만료됩니다'), findsOneWidget);
      
      // Navigate to subscription
      await _navigateToSubscription();
      
      // Renew subscription
      await _renewSubscription('Premium');
      
      // Verify success
      expect(find.text('구독이 갱신되었습니다'), findsOneWidget);
    });
  }
  
  // Scenario 4: Position Management Flow
  Future<void> positionManagementFlow() async {
    await performTest('Position Management Flow', () async {
      await launchApp(isAuthenticated: true);
      
      // Create position from recommendation
      final home = HomePage(tester);
      await home.selectRecommendation(0);
      await _createPosition('AAPL', 10, 'BUY');
      
      // Navigate to positions
      await home.navigateToTab(2);
      
      // Monitor position
      await _waitForPriceUpdate();
      
      // Close position with profit
      await _closePosition('AAPL');
      
      // Verify closed
      expect(find.text('포지션이 종료되었습니다'), findsOneWidget);
      _verifyProfit();
    });
  }
  
  // Helper Methods
  Future<void> _selectLanguage(String language) async {
    await tap(find.text(language));
    await tester.pumpAndSettle();
  }
  
  Future<void> _completeSignUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Implementation for sign up flow
    await tap(find.byKey(Key('signup_button')));
    await enterText(find.byKey(Key('email_field')), email);
    await enterText(find.byKey(Key('password_field')), password);
    await enterText(find.byKey(Key('name_field')), name);
    await tap(find.byKey(Key('agree_terms')));
    await tap(find.byKey(Key('submit_signup')));
    await helper.waitForLoadingToComplete();
  }
  
  Future<void> _selectInitialTraders() async {
    // Select 3 traders
    for (int i = 0; i < 3; i++) {
      await tap(find.byKey(Key('trader_$i')));
    }
    await tap(find.text('다음'));
  }
  
  Future<void> _selectSubscription(String tier) async {
    await tap(find.text(tier));
    await tap(find.text('구독하기'));
    // Handle payment flow
    await helper.waitForLoadingToComplete();
  }
  
  Future<void> _createPosition(String symbol, int quantity, String type) async {
    await tap(find.text('포지션 생성'));
    await enterText(find.byKey(Key('quantity_field')), quantity.toString());
    await tap(find.text(type));
    await tap(find.text('확인'));
    await helper.waitForLoadingToComplete();
  }
  
  void _verifyPositionExists(String symbol, int quantity) {
    expect(find.text(symbol), findsOneWidget);
    expect(find.text('$quantity주'), findsOneWidget);
  }
  
  Future<void> _navigateToSubscription() async {
    await tap(find.byIcon(Icons.person));
    await tap(find.text('구독 관리'));
  }
  
  Future<void> _renewSubscription(String tier) async {
    await tap(find.text('갱신하기'));
    await tap(find.text(tier));
    await tap(find.text('결제하기'));
    await helper.waitForLoadingToComplete();
  }
  
  Future<void> _waitForPriceUpdate() async {
    // Simulate waiting for real-time price update
    await tester.pump(Duration(seconds: 2));
  }
  
  Future<void> _closePosition(String symbol) async {
    await tap(find.byKey(Key('position_$symbol')));
    await tap(find.text('포지션 종료'));
    await tap(find.text('확인'));
    await helper.waitForLoadingToComplete();
  }
  
  void _verifyProfit() {
    final profitText = find.textContaining('+');
    expect(profitText, findsOneWidget);
  }
}