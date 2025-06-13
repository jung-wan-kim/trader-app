import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/strategy_detail_screen.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/test_helper.dart';

void main() {
  group('StrategyDetailScreen Widget Tests', () {
    late ProviderContainer container;
    late MockDataService mockDataService;
    late StockRecommendation testRecommendation;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      mockDataService = MockDataService();
      container = ProviderContainer();
      
      // Create test recommendation
      testRecommendation = TestHelper.createMockStockRecommendation(
        id: 'rec_001',
        stockCode: 'AAPL',
        action: 'BUY',
        targetPrice: 200.0,
        currentPrice: 150.0,
        stopLoss: 140.0,
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: StrategyDetailScreen(recommendation: testRecommendation),
        ),
      );
    }

    testWidgets('should display stock recommendation header', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check header info
      expect(find.text('AAPL'), findsOneWidget);
      expect(find.text('Apple Inc.'), findsOneWidget);
      expect(find.text('Jesse Livermore'), findsOneWidget);
      expect(find.text('BUY'), findsOneWidget);
    });

    testWidgets('should display price targets', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check price targets
      expect(find.textContaining('\$150'), findsWidgets); // Current price
      expect(find.textContaining('\$200'), findsWidgets); // Target price
      expect(find.textContaining('\$140'), findsWidgets); // Stop loss
      expect(find.textContaining('85%'), findsWidgets); // Confidence
    });

    testWidgets('should display risk/reward information', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check risk/reward
      expect(find.text('Risk Level'), findsOneWidget);
      expect(find.text('MEDIUM'), findsOneWidget);
      expect(find.text('Timeframe'), findsOneWidget);
      expect(find.textContaining('SWING'), findsWidgets);
    });

    testWidgets('should display reasoning section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check reasoning
      expect(find.text('Analysis'), findsOneWidget);
      expect(find.textContaining('Strong uptrend'), findsWidgets);
    });

    testWidgets('should display candle chart', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for chart
      expect(find.byType(CustomPaint), findsWidgets); // Chart widget
    });

    testWidgets('should display risk calculator button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check risk calculator
      expect(find.text('Risk Calculator'), findsOneWidget);
      expect(find.byIcon(Icons.calculate), findsWidgets);
    });

    testWidgets('should display position size calculator button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check position calculator
      expect(find.text('Position Size'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsWidgets);
    });

    testWidgets('should handle risk calculator toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap risk calculator button
      await tester.tap(find.text('Risk Calculator'));
      await tester.pumpAndSettle();

      // Should show risk calculator
      expect(find.text('Calculate Risk'), findsOneWidget);
    });

    testWidgets('should display execute trade button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check execute button
      expect(find.widgetWithText(ElevatedButton, 'Execute Trade'), findsOneWidget);
    });

    testWidgets('should handle execute trade button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap execute button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Execute Trade'));
      await tester.pump();

      // Should show trade dialog or navigate
      expect(find.byType(StrategyDetailScreen), findsOneWidget);
    });

    testWidgets('should display potential profit', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check potential profit
      expect(find.text('Potential Profit'), findsOneWidget);
      expect(find.textContaining('33.33%'), findsWidgets); // (200-150)/150
    });

    testWidgets('should display risk reward ratio', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check risk/reward ratio
      expect(find.text('Risk/Reward'), findsOneWidget);
      expect(find.textContaining('5.0'), findsWidgets); // (200-150)/(150-140)
    });

    testWidgets('should handle back navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      
      await tester.tap(backButton);
      await tester.pump();

      // Should trigger navigation (in real app)
      expect(find.byType(StrategyDetailScreen), findsOneWidget);
    });

    testWidgets('should handle position calculator toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap position calculator button
      await tester.tap(find.text('Position Size'));
      await tester.pumpAndSettle();

      // Should show position calculator
      expect(find.text('Position Size Calculator'), findsOneWidget);
    });

    testWidgets('should display trader badge', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check trader info
      expect(find.text('Jesse Livermore'), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsWidgets);
    });

    testWidgets('should display share button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check share button
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('should handle share button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();

      // Should trigger share action
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('should display recommendation details', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check recommendation details
      expect(find.textContaining('recommendation'), findsWidgets);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display add to watchlist button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for watchlist button
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    });

    testWidgets('should handle watchlist button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap watchlist button
      await tester.tap(find.byIcon(Icons.bookmark_outline));
      await tester.pump();

      // Should change to bookmarked
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('should display action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for action buttons
      expect(find.byType(ElevatedButton), findsWidgets);
      expect(find.byType(OutlinedButton), findsWidgets);
    });

    testWidgets('should handle scroll behavior', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Perform scroll
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      // Should still show content
      expect(find.byType(StrategyDetailScreen), findsOneWidget);
    });
  });
}