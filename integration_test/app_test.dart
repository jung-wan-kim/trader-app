import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E App Tests', () {
    testWidgets('complete user journey test', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify app starts on Home screen
      expect(find.text('실시간 추천'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Scroll through recommendations
      final recommendationsList = find.byType(ListView).first;
      await tester.drag(recommendationsList, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Navigate to Discover screen
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();

      // Verify Discover screen content
      expect(find.text('인기 전략'), findsOneWidget);
      expect(find.textContaining('Win Rate'), findsWidgets);

      // Tap on a strategy card to view details
      final strategyCard = find.byType(Card).first;
      await tester.tap(strategyCard);
      await tester.pumpAndSettle();

      // Verify strategy detail screen
      expect(find.text('전략 상세'), findsOneWidget);
      expect(find.text('구독하기'), findsOneWidget);

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to Position screen
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();

      // Verify Position screen content
      expect(find.text('포지션'), findsOneWidget);
      expect(find.text('Portfolio Value'), findsOneWidget);

      // Switch between tabs
      final openTab = find.text('보유중');
      final historyTab = find.text('히스토리');
      
      expect(openTab, findsOneWidget);
      expect(historyTab, findsOneWidget);
      
      await tester.tap(historyTab);
      await tester.pumpAndSettle();

      // Navigate to Profile screen
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // Verify Profile screen content
      expect(find.text('프로필'), findsOneWidget);
      expect(find.text('구독 관리'), findsOneWidget);
      expect(find.text('설정'), findsOneWidget);

      // Return to Home
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      // Verify we're back at Home
      expect(find.text('실시간 추천'), findsOneWidget);
    });

    testWidgets('subscription flow test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Profile
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      // Tap on subscription management
      await tester.tap(find.text('구독 관리'));
      await tester.pumpAndSettle();

      // Verify subscription screen
      expect(find.text('구독 플랜'), findsOneWidget);
      expect(find.text('Pro Trader'), findsOneWidget);
      expect(find.textContaining('\$49.99'), findsOneWidget);

      // Check features list
      expect(find.text('실시간 데이터'), findsOneWidget);
      expect(find.text('무제한 거래'), findsOneWidget);
    });

    testWidgets('strategy subscription test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Discover
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();

      // Tap on first strategy
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Tap subscribe button
      final subscribeButton = find.widgetWithText(ElevatedButton, '구독하기');
      expect(subscribeButton, findsOneWidget);
      
      await tester.tap(subscribeButton);
      await tester.pumpAndSettle();

      // Should show subscription confirmation or dialog
      // (Implementation dependent)
    });

    testWidgets('recommendation action test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Wait for recommendations to load
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find and tap on a recommendation card
      final recommendationCard = find.byType(Container).first;
      await tester.tap(recommendationCard);
      await tester.pumpAndSettle();

      // Should show action options or detail view
      // (Implementation dependent)
    });

    testWidgets('performance test - screen transitions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      // Navigate through all screens quickly
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // All navigation should complete in reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('scroll performance test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final stopwatch = Stopwatch()..start();

      // Perform rapid scrolling
      final scrollable = find.byType(Scrollable).first;
      for (int i = 0; i < 5; i++) {
        await tester.drag(scrollable, const Offset(0, -500));
        await tester.pump();
        await tester.drag(scrollable, const Offset(0, 500));
        await tester.pump();
      }

      await tester.pumpAndSettle();
      stopwatch.stop();

      // Scrolling should be smooth and complete quickly
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });
  });
}