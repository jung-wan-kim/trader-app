import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone_flutter/models/stock_recommendation.dart';
import 'package:tiktok_clone_flutter/widgets/recommendation_card.dart';

void main() {
  group('RecommendationCard Widget Tests', () {
    late StockRecommendation testRecommendation;
    bool wasCardTapped = false;

    setUp(() {
      wasCardTapped = false;
      testRecommendation = StockRecommendation(
        id: 'rec_001',
        stockCode: 'AAPL',
        stockName: 'Apple Inc.',
        traderName: 'John Trader',
        traderId: 'trader_001',
        action: 'BUY',
        targetPrice: 180.0,
        currentPrice: 170.0,
        stopLoss: 165.0,
        takeProfit: 185.0,
        reasoning: 'Strong earnings report and technical breakout pattern',
        recommendedAt: DateTime.now().subtract(const Duration(hours: 2)),
        timeframe: 'MEDIUM',
        confidence: 85.0,
        riskLevel: 'MEDIUM',
        expectedReturn: 5.88,
        likes: 125,
        followers: 3500,
      );
    });

    Widget createTestWidget(StockRecommendation recommendation) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: RecommendationCard(
            recommendation: recommendation,
            onTap: () {
              wasCardTapped = true;
            },
          ),
        ),
      );
    }

    testWidgets('should display all recommendation information', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testRecommendation));

      // Check action badge
      expect(find.text('BUY'), findsOneWidget);
      
      // Check stock code and name
      expect(find.text('AAPL'), findsOneWidget);
      expect(find.text('Apple Inc.'), findsOneWidget);
      
      // Check risk level
      expect(find.text('MEDIUM'), findsOneWidget);
      
      // Check confidence
      expect(find.text('85%'), findsOneWidget);
      
      // Check prices
      expect(find.text('\$170.00'), findsOneWidget); // Current price
      expect(find.text('\$180.00'), findsOneWidget); // Target price
      expect(find.text('+5.9%'), findsOneWidget); // Potential profit
      
      // Check reasoning
      expect(find.text('Strong earnings report and technical breakout pattern'), findsOneWidget);
      
      // Check trader name
      expect(find.text('John Trader'), findsOneWidget);
      
      // Check time ago
      expect(find.text('2h ago'), findsOneWidget);
    });

    testWidgets('should show correct colors for BUY action', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testRecommendation));

      final buyContainer = find.descendant(
        of: find.byType(Container),
        matching: find.text('BUY'),
      ).evaluate().first.widget as Text;

      expect(buyContainer.style?.color, equals(const Color(0xFF00D632)));
    });

    testWidgets('should show correct colors for SELL action', (WidgetTester tester) async {
      testRecommendation = StockRecommendation(
        id: 'rec_002',
        stockCode: 'TSLA',
        stockName: 'Tesla Inc.',
        traderName: 'Jane Trader',
        traderId: 'trader_002',
        action: 'SELL',
        targetPrice: 150.0,
        currentPrice: 170.0,
        stopLoss: 175.0,
        takeProfit: 145.0,
        reasoning: 'Overvalued based on current metrics',
        recommendedAt: DateTime.now(),
        timeframe: 'SHORT',
        confidence: 75.0,
        riskLevel: 'HIGH',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));

      final sellContainer = find.descendant(
        of: find.byType(Container),
        matching: find.text('SELL'),
      ).evaluate().first.widget as Text;

      expect(sellContainer.style?.color, equals(const Color(0xFFFF3B30)));
    });

    testWidgets('should show correct colors for risk levels', (WidgetTester tester) async {
      // Test LOW risk
      testRecommendation = StockRecommendation(
        id: 'rec_003',
        stockCode: 'MSFT',
        stockName: 'Microsoft Corp.',
        traderName: 'Test Trader',
        traderId: 'trader_003',
        action: 'BUY',
        targetPrice: 380.0,
        currentPrice: 370.0,
        stopLoss: 365.0,
        takeProfit: 385.0,
        reasoning: 'Stable growth pattern',
        recommendedAt: DateTime.now(),
        timeframe: 'LONG',
        confidence: 90.0,
        riskLevel: 'LOW',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));
      expect(find.text('LOW'), findsOneWidget);

      // Test HIGH risk
      testRecommendation = StockRecommendation(
        id: 'rec_004',
        stockCode: 'GME',
        stockName: 'GameStop Corp.',
        traderName: 'Risk Trader',
        traderId: 'trader_004',
        action: 'BUY',
        targetPrice: 50.0,
        currentPrice: 30.0,
        stopLoss: 25.0,
        takeProfit: 55.0,
        reasoning: 'High volatility play',
        recommendedAt: DateTime.now(),
        timeframe: 'SHORT',
        confidence: 60.0,
        riskLevel: 'HIGH',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));
      expect(find.text('HIGH'), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testRecommendation));

      expect(wasCardTapped, isFalse);

      await tester.tap(find.byType(RecommendationCard));
      await tester.pumpAndSettle();

      expect(wasCardTapped, isTrue);
    });

    testWidgets('should display trader avatar with first letter', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testRecommendation));

      final avatarFinder = find.byType(CircleAvatar);
      expect(avatarFinder, findsOneWidget);

      final avatarText = find.descendant(
        of: avatarFinder,
        matching: find.text('J'),
      );
      expect(avatarText, findsOneWidget);
    });

    testWidgets('should display correct time ago formats', (WidgetTester tester) async {
      // Test "Just now"
      testRecommendation = StockRecommendation(
        id: 'rec_005',
        stockCode: 'AAPL',
        stockName: 'Apple Inc.',
        traderName: 'Time Trader',
        traderId: 'trader_005',
        action: 'BUY',
        targetPrice: 180.0,
        currentPrice: 170.0,
        stopLoss: 165.0,
        takeProfit: 185.0,
        reasoning: 'Test',
        recommendedAt: DateTime.now(),
        timeframe: 'MEDIUM',
        confidence: 85.0,
        riskLevel: 'MEDIUM',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));
      expect(find.text('Just now'), findsOneWidget);

      // Test minutes ago
      testRecommendation = StockRecommendation(
        id: 'rec_006',
        stockCode: 'AAPL',
        stockName: 'Apple Inc.',
        traderName: 'Time Trader',
        traderId: 'trader_006',
        action: 'BUY',
        targetPrice: 180.0,
        currentPrice: 170.0,
        stopLoss: 165.0,
        takeProfit: 185.0,
        reasoning: 'Test',
        recommendedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        timeframe: 'MEDIUM',
        confidence: 85.0,
        riskLevel: 'MEDIUM',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));
      expect(find.text('30m ago'), findsOneWidget);

      // Test days ago
      testRecommendation = StockRecommendation(
        id: 'rec_007',
        stockCode: 'AAPL',
        stockName: 'Apple Inc.',
        traderName: 'Time Trader',
        traderId: 'trader_007',
        action: 'BUY',
        targetPrice: 180.0,
        currentPrice: 170.0,
        stopLoss: 165.0,
        takeProfit: 185.0,
        reasoning: 'Test',
        recommendedAt: DateTime.now().subtract(const Duration(days: 3)),
        timeframe: 'MEDIUM',
        confidence: 85.0,
        riskLevel: 'MEDIUM',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));
      expect(find.text('3d ago'), findsOneWidget);
    });

    testWidgets('should handle long text with ellipsis', (WidgetTester tester) async {
      testRecommendation = StockRecommendation(
        id: 'rec_008',
        stockCode: 'AAPL',
        stockName: 'Apple Inc. with a very long company name that should be truncated',
        traderName: 'Very Long Trader Name That Should Not Break Layout',
        traderId: 'trader_008',
        action: 'BUY',
        targetPrice: 180.0,
        currentPrice: 170.0,
        stopLoss: 165.0,
        takeProfit: 185.0,
        reasoning: 'This is a very long reasoning text that should be truncated after two lines to maintain consistent card height and good visual appearance',
        recommendedAt: DateTime.now(),
        timeframe: 'MEDIUM',
        confidence: 85.0,
        riskLevel: 'MEDIUM',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));

      // Card should still render without overflow
      expect(find.byType(RecommendationCard), findsOneWidget);
    });

    testWidgets('should display negative potential profit correctly', (WidgetTester tester) async {
      testRecommendation = StockRecommendation(
        id: 'rec_009',
        stockCode: 'XYZ',
        stockName: 'XYZ Corp.',
        traderName: 'Bear Trader',
        traderId: 'trader_009',
        action: 'SELL',
        targetPrice: 90.0,
        currentPrice: 100.0,
        stopLoss: 105.0,
        takeProfit: 85.0,
        reasoning: 'Bearish outlook',
        recommendedAt: DateTime.now(),
        timeframe: 'SHORT',
        confidence: 70.0,
        riskLevel: 'HIGH',
      );

      await tester.pumpWidget(createTestWidget(testRecommendation));

      // Should show negative percentage without double minus
      expect(find.text('-10.0%'), findsOneWidget);
    });
  });
}