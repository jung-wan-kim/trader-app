import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Trader App UI Tests', () {
    setUp(() async {
      // SharedPreferences 초기화
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Language selection and main navigation test', (tester) async {
      // 앱 실행
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      print('✅ 1. App launched - Language selection screen');

      // 언어 선택 화면 확인
      expect(find.text('Choose Your Language'), findsOneWidget);
      expect(find.text('한국어'), findsOneWidget);

      // 한국어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      print('✅ 2. Selected Korean language');

      // Continue 버튼 클릭
      final continueButton = find.text('Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ 3. Clicked Continue button');
      }

      // 온보딩 또는 로그인 화면 확인
      await tester.pumpAndSettle();
      
      // Demo 로그인 시도
      final demoLoginButton = find.textContaining('Demo');
      if (demoLoginButton.evaluate().isNotEmpty) {
        await tester.tap(demoLoginButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ 4. Logged in with Demo account');
      }

      // 메인 화면 확인
      await tester.pumpAndSettle();
      
      // 하단 네비게이션 확인
      final bottomNav = find.byType(NavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        print('✅ 5. Found bottom navigation bar');

        // 각 탭 테스트
        // Discover 탭
        final discoverTab = find.byIcon(Icons.explore);
        if (discoverTab.evaluate().isNotEmpty) {
          await tester.tap(discoverTab);
          await tester.pumpAndSettle();
          print('✅ 6. Navigated to Discover tab');
          
          // 스크린샷 (시뮬레이션)
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }

        // Analytics/Position 탭
        final analyticsTab = find.byIcon(Icons.analytics_outlined);
        if (analyticsTab.evaluate().isNotEmpty) {
          await tester.tap(analyticsTab);
          await tester.pumpAndSettle();
          print('✅ 7. Navigated to Analytics tab');
          
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }

        // Profile 탭
        final profileTab = find.byIcon(Icons.person_outline);
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();
          print('✅ 8. Navigated to Profile tab');
          
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }

        // Home 탭으로 돌아가기
        final homeTab = find.byIcon(Icons.home);
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();
          print('✅ 9. Returned to Home tab');
        }
      }

      // 트레이딩 전략 카드 찾기
      await tester.pumpAndSettle();
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        print('✅ 10. Found ${cards.evaluate().length} cards');
        
        // 첫 번째 카드 클릭
        await tester.tap(cards.first);
        await tester.pumpAndSettle();
        print('✅ 11. Clicked on first trading strategy card');
        
        // 상세 화면 확인
        await tester.pumpAndSettle(const Duration(seconds: 1));
        
        // 뒤로 가기
        final backButton = find.byIcon(Icons.arrow_back);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();
          print('✅ 12. Returned from detail screen');
        }
      }

      print('✅ UI Test completed successfully!');
    });

    testWidgets('Trading features test', (tester) async {
      // 앱 실행 및 Demo 로그인
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 한국어 선택 및 진행
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      final continueButton = find.text('Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Demo 로그인
      final demoLoginButton = find.textContaining('Demo');
      if (demoLoginButton.evaluate().isNotEmpty) {
        await tester.tap(demoLoginButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // 메인 화면에서 트레이딩 관련 기능 테스트
      await tester.pumpAndSettle();

      // 추천 종목 확인
      final recommendationText = find.textContaining('추천');
      if (recommendationText.evaluate().isNotEmpty) {
        print('✅ Found recommendation section');
      }

      // 전략 관련 텍스트 확인
      final strategyTexts = ['Jesse Livermore', 'Larry Williams', 'Stan Weinstein'];
      for (final strategy in strategyTexts) {
        final strategyWidget = find.textContaining(strategy);
        if (strategyWidget.evaluate().isNotEmpty) {
          print('✅ Found $strategy strategy');
        }
      }

      // 스크롤 테스트
      final scrollable = find.byType(Scrollable).first;
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable, const Offset(0, -300));
        await tester.pumpAndSettle();
        print('✅ Performed scroll gesture');
        
        await tester.drag(scrollable, const Offset(0, 300));
        await tester.pumpAndSettle();
        print('✅ Scrolled back');
      }

      print('✅ Trading features test completed!');
    });
  });
}