import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/providers/portfolio_provider.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';

void main() {
  group('Data Flow Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('recommendations provider should initialize with data', () async {
      // Read the recommendations provider
      final recommendations = await container.read(recommendationsProvider.future);
      
      expect(recommendations, isNotEmpty);
      expect(recommendations.first, isA<StockRecommendation>());
      
      // Verify recommendation structure
      final firstRecommendation = recommendations.first;
      expect(firstRecommendation.stockCode, isNotEmpty);
      expect(firstRecommendation.action, anyOf(['BUY', 'SELL', 'HOLD']));
      expect(firstRecommendation.confidence, greaterThanOrEqualTo(0));
      expect(firstRecommendation.confidence, lessThanOrEqualTo(100));
    });

    test('strategies provider should initialize with data', () async {
      // Read the strategies provider
      final strategies = await container.read(strategiesProvider.future);
      
      expect(strategies, isNotEmpty);
      expect(strategies.first, isA<TraderStrategy>());
      
      // Verify strategy structure
      final firstStrategy = strategies.first;
      expect(firstStrategy.strategyName, isNotEmpty);
      expect(firstStrategy.winRate, greaterThanOrEqualTo(0));
      expect(firstStrategy.winRate, lessThanOrEqualTo(100));
      expect(firstStrategy.rating, greaterThanOrEqualTo(1));
      expect(firstStrategy.rating, lessThanOrEqualTo(5));
    });

    test('subscription provider should have default state', () {
      // Read the subscription provider
      final subscription = container.read(subscriptionProvider);
      
      expect(subscription, isNotNull);
      expect(subscription.isActive, isTrue);
      expect(subscription.tier.name, equals('pro'));
      expect(subscription.features, isNotEmpty);
    });

    test('portfolio provider should maintain portfolio state', () {
      // Read the portfolio provider
      final portfolio = container.read(portfolioProvider);
      
      expect(portfolio, isNotNull);
      expect(portfolio.totalValue, greaterThanOrEqualTo(0));
      expect(portfolio.availableCash, greaterThanOrEqualTo(0));
      expect(portfolio.dayChange, isA<double>());
      expect(portfolio.dayChangePercent, isA<double>());
    });

    testWidgets('data should flow correctly to UI components', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Discover screen to see strategies
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();

      // Should see strategy cards with data
      expect(find.text('Momentum Master'), findsOneWidget);
      expect(find.textContaining('Win Rate'), findsWidgets);
      expect(find.textContaining('followers'), findsWidgets);
    });

    testWidgets('provider state updates should reflect in UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Position screen
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();

      // Should see portfolio data
      expect(find.textContaining('Portfolio Value'), findsOneWidget);
      expect(find.textContaining('\$'), findsWidgets);
      expect(find.textContaining('Today'), findsWidgets);
    });

    test('recommendations should be sorted by date', () async {
      final recommendations = await container.read(recommendationsProvider.future);
      
      for (int i = 0; i < recommendations.length - 1; i++) {
        expect(
          recommendations[i].recommendedAt.isAfter(recommendations[i + 1].recommendedAt) ||
          recommendations[i].recommendedAt.isAtSameMomentAs(recommendations[i + 1].recommendedAt),
          isTrue,
        );
      }
    });

    test('strategies should be sorted by rating', () async {
      final strategies = await container.read(strategiesProvider.future);
      
      for (int i = 0; i < strategies.length - 1; i++) {
        expect(
          strategies[i].rating >= strategies[i + 1].rating,
          isTrue,
        );
      }
    });

    test('portfolio calculations should be accurate', () {
      final portfolio = container.read(portfolioProvider);
      
      // Total value should be sum of positions value + available cash
      final positionsValue = portfolio.positions.fold<double>(
        0,
        (sum, position) => sum + (position.quantity * position.currentPrice),
      );
      
      expect(
        portfolio.totalValue,
        closeTo(positionsValue + portfolio.availableCash, 0.01),
      );
    });

    testWidgets('error states should be handled gracefully', (WidgetTester tester) async {
      // Create a provider scope with overridden error state
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            recommendationsProvider.overrideWith(() {
              return RecommendationsNotifier()..simulateError();
            }),
          ],
          child: const TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Should show error state or empty state, not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}

// Extension to simulate error in recommendations provider for testing
extension on RecommendationsNotifier {
  void simulateError() {
    state = AsyncValue.error(
      Exception('Simulated network error'),
      StackTrace.current,
    );
  }
}