import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:trader_app/screens/home_screen.dart';
import 'package:trader_app/screens/login_screen.dart';
import 'package:trader_app/screens/profile_screen.dart';
import 'package:trader_app/screens/strategy_detail_screen.dart';
import 'package:trader_app/screens/discover_screen.dart';
import 'package:trader_app/screens/inbox_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete App UI Integration Tests', () {
    setUp(() async {
      // Initialize SharedPreferences
      SharedPreferences.setMockInitialValues({
        'has_seen_onboarding': true,
        'selected_traders': ['JESSE_LIVERMORE', 'LARRY_WILLIAMS'],
        'isDemoMode': 'true',
      });
    });

    testWidgets('Full app flow - Login to Strategy Execution', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify login screen is shown
      expect(find.byType(LoginScreen), findsOneWidget);
      
      // Tap demo login button
      final demoButton = find.text('Demo 계정으로 시작하기');
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should navigate to home screen
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Verify recommendations are loaded
      expect(find.text('추천 전략'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find and tap on a recommendation card
      final recommendationCards = find.byKey(const Key('recommendation_card'));
      if (recommendationCards.evaluate().isNotEmpty) {
        await tester.tap(recommendationCards.first);
        await tester.pumpAndSettle();

        // Should navigate to strategy detail
        expect(find.byType(StrategyDetailScreen), findsOneWidget);
        
        // Verify strategy details are displayed
        expect(find.text('Analysis'), findsOneWidget);
        expect(find.text('Execute Trade'), findsOneWidget);

        // Go back to home
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Navigate to profile tab
      final profileTab = find.byIcon(Icons.person);
      expect(profileTab, findsOneWidget);
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Verify profile screen
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('포트폴리오'), findsOneWidget);
    });

    testWidgets('Navigation between main screens', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login with demo account
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test navigation to each tab
      // Home tab (already there)
      expect(find.byType(HomeScreen), findsOneWidget);

      // Discover tab
      final discoverTab = find.byIcon(Icons.explore);
      await tester.tap(discoverTab);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Upload tab (center button)
      final uploadTab = find.byIcon(Icons.add_circle_outline);
      await tester.tap(uploadTab);
      await tester.pumpAndSettle();
      
      // Inbox tab
      final inboxTab = find.byIcon(Icons.inbox);
      await tester.tap(inboxTab);
      await tester.pumpAndSettle();
      expect(find.byType(InboxScreen), findsOneWidget);

      // Profile tab
      final profileTab = find.byIcon(Icons.person);
      await tester.tap(profileTab);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Back to home
      final homeTab = find.byIcon(Icons.home);
      await tester.tap(homeTab);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Risk Calculator interaction', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap a recommendation
      final recommendationCards = find.byKey(const Key('recommendation_card'));
      if (recommendationCards.evaluate().isNotEmpty) {
        await tester.tap(recommendationCards.first);
        await tester.pumpAndSettle();

        // Open risk calculator
        final riskCalculatorButton = find.text('Risk Calculator');
        expect(riskCalculatorButton, findsOneWidget);
        await tester.tap(riskCalculatorButton);
        await tester.pumpAndSettle();

        // Interact with risk calculator
        final accountBalanceField = find.byKey(const Key('account_balance_field'));
        if (accountBalanceField.evaluate().isNotEmpty) {
          await tester.enterText(accountBalanceField, '10000');
          await tester.pumpAndSettle();

          // Calculate button
          final calculateButton = find.text('Calculate Risk');
          if (calculateButton.evaluate().isNotEmpty) {
            await tester.tap(calculateButton);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    testWidgets('Scroll performance in recommendations list', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test scrolling in recommendations
      final scrollableFinder = find.byType(Scrollable).first;
      
      // Scroll down
      await tester.fling(scrollableFinder, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      // Scroll up
      await tester.fling(scrollableFinder, const Offset(0, 500), 1000);
      await tester.pumpAndSettle();

      // Verify still on home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Language change functionality', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Find settings button
      final settingsButton = find.byIcon(Icons.settings);
      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton);
        await tester.pumpAndSettle();

        // Look for language option
        final languageOption = find.textContaining('언어');
        if (languageOption.evaluate().isNotEmpty) {
          await tester.tap(languageOption);
          await tester.pumpAndSettle();

          // Select English
          final englishOption = find.text('English');
          if (englishOption.evaluate().isNotEmpty) {
            await tester.tap(englishOption);
            await tester.pumpAndSettle();

            // Verify language changed
            expect(find.text('Portfolio'), findsWidgets);
          }
        }
      }
    });

    testWidgets('Portfolio display and interaction', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Check portfolio section
      expect(find.text('포트폴리오'), findsOneWidget);
      
      // Look for position cards
      final positionCards = find.byKey(const Key('position_card'));
      if (positionCards.evaluate().isNotEmpty) {
        // Tap on first position
        await tester.tap(positionCards.first);
        await tester.pumpAndSettle();
      }

      // Check for portfolio stats
      expect(find.textContaining('총 수익'), findsWidgets);
    });

    testWidgets('Video player interaction in Discover', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to discover
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();

      // Check for video content
      expect(find.byType(DiscoverScreen), findsOneWidget);
      
      // Simulate video interaction
      final videoArea = find.byType(GestureDetector).first;
      if (videoArea.evaluate().isNotEmpty) {
        // Double tap to like
        await tester.tap(videoArea);
        await tester.tap(videoArea);
        await tester.pumpAndSettle();
      }

      // Check engagement buttons
      expect(find.byIcon(Icons.favorite_border), findsWidgets);
      expect(find.byIcon(Icons.comment), findsWidgets);
      expect(find.byIcon(Icons.share), findsWidgets);
    });

    testWidgets('Notification tabs in Inbox', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to inbox
      await tester.tap(find.byIcon(Icons.inbox));
      await tester.pumpAndSettle();

      // Check tabs
      expect(find.text('활동'), findsOneWidget);
      expect(find.text('메시지'), findsOneWidget);

      // Switch to messages tab
      await tester.tap(find.text('메시지'));
      await tester.pumpAndSettle();

      // Switch back to activity
      await tester.tap(find.text('활동'));
      await tester.pumpAndSettle();
    });

    testWidgets('Execute trade flow', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap a recommendation
      final recommendationCards = find.byKey(const Key('recommendation_card'));
      if (recommendationCards.evaluate().isNotEmpty) {
        await tester.tap(recommendationCards.first);
        await tester.pumpAndSettle();

        // Tap execute trade button
        final executeButton = find.widgetWithText(ElevatedButton, 'Execute Trade');
        expect(executeButton, findsOneWidget);
        await tester.tap(executeButton);
        await tester.pumpAndSettle();

        // Check for trade confirmation dialog or next screen
        // This depends on your app's flow
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
    });

    testWidgets('App performance during heavy scrolling', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Demo 계정으로 시작하기'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Measure performance during scrolling
      final scrollableFinder = find.byType(Scrollable).first;
      
      // Perform multiple rapid scrolls
      for (int i = 0; i < 5; i++) {
        await tester.fling(scrollableFinder, const Offset(0, -300), 2000);
        await tester.pump(const Duration(milliseconds: 500));
      }
      
      await tester.pumpAndSettle();

      // App should still be responsive
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}