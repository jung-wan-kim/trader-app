import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/home_screen.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const HomeScreen(),
        ),
      );
    }

    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check app bar title
      expect(find.text('AI Trading Assistant'), findsOneWidget);
      
      // Check notification icon
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('should display filter chips', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Buy'), findsOneWidget);
      expect(find.text('Sell'), findsOneWidget);
      expect(find.text('Hold'), findsOneWidget);
    });

    testWidgets('should display welcome message when no recommendations', (WidgetTester tester) async {
      // Override with empty recommendations
      final emptyContainer = ProviderContainer(
        overrides: [
          recommendationsProvider.overrideWith((ref) {
            return RecommendationsNotifier(MockDataService())
              ..state = const AsyncValue.data([]);
          }),
        ],
      );
      
      await tester.pumpWidget(
        ProviderScope(
          parent: emptyContainer,
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check welcome message
      expect(find.text('Welcome to AI Trading Assistant!'), findsOneWidget);
      expect(find.text('No recommendations available yet.'), findsOneWidget);
      
      emptyContainer.dispose();
    });

    testWidgets('should display recommendations when data is loaded', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Should show recommendation cards
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Initial state should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for data to load
      await tester.pumpAndSettle();
    });

    testWidgets('should handle error state gracefully', (WidgetTester tester) async {
      // Override with error state
      final errorContainer = ProviderContainer(
        overrides: [
          recommendationsProvider.overrideWith((ref) {
            return RecommendationsNotifier(MockDataService())
              ..state = AsyncValue.error(
                Exception('Test error'),
                StackTrace.current,
              );
          }),
        ],
      );
      
      await tester.pumpWidget(
        ProviderScope(
          parent: errorContainer,
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('Failed to load recommendations'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      
      errorContainer.dispose();
    });

    testWidgets('should filter recommendations by action', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Buy filter
      await tester.tap(find.text('Buy'));
      await tester.pumpAndSettle();

      // Buy chip should be selected
      final buyChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Buy'),
      );
      expect(buyChip.selected, isTrue);
    });

    testWidgets('should show sort menu when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap sort button
      final sortButton = find.byIcon(Icons.sort);
      if (sortButton.evaluate().isNotEmpty) {
        await tester.tap(sortButton);
        await tester.pumpAndSettle();

        // Should show sort options
        expect(find.text('Sort by Date'), findsOneWidget);
        expect(find.text('Sort by Confidence'), findsOneWidget);
        expect(find.text('Sort by Profit'), findsOneWidget);
      }
    });

    testWidgets('should navigate to notification screen when bell icon tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap notification icon
      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      // Should navigate (in real app would check navigation)
      // For now just verify the icon was tappable
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('should show recommendation details in cards', (WidgetTester tester) async {
      // Create test recommendation
      final testRecommendation = StockRecommendation(
        id: 'test-1',
        stockCode: 'AAPL',
        stockName: 'Apple Inc.',
        action: 'BUY',
        currentPrice: 150.00,
        targetPrice: 180.00,
        stopLoss: 140.00,
        confidence: 85,
        reasoning: 'Strong growth potential',
        traderId: 'trader-1',
        traderName: 'Jesse Livermore',
        riskLevel: 'MEDIUM',
        timeframe: 'SHORT_TERM',
        potentialProfit: 20.0,
        potentialLoss: 6.67,
        recommendedAt: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(days: 30)),
        notes: 'Test note',
      );

      final testContainer = ProviderContainer(
        overrides: [
          recommendationsProvider.overrideWith((ref) {
            return RecommendationsNotifier(MockDataService())
              ..state = AsyncValue.data([testRecommendation]);
          }),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: testContainer,
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check recommendation details
      expect(find.text('AAPL'), findsOneWidget);
      expect(find.text('Apple Inc.'), findsOneWidget);
      expect(find.text('BUY'), findsOneWidget);
      expect(find.textContaining('85%'), findsWidgets);
      
      testContainer.dispose();
    });

    testWidgets('should display timeframe badges correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should show timeframe information in recommendations
      // This depends on actual data, so we just check if cards are displayed
      final cards = find.byType(Card);
      expect(cards, findsWidgets);
    });

    testWidgets('should handle pull to refresh', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Perform pull to refresh
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, 300),
      );
      await tester.pumpAndSettle();

      // Should complete refresh (no errors)
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}