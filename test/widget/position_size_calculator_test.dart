import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/widgets/position_size_calculator.dart';

void main() {
  group('PositionSizeCalculator Widget Tests', () {
    Widget createTestWidget({
      required double currentPrice,
      required double stopLoss,
    }) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: PositionSizeCalculator(
            currentPrice: currentPrice,
            stopLoss: stopLoss,
          ),
        ),
      );
    }

    testWidgets('should display all components correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Check title
      expect(find.text('Position Size Calculator'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);

      // Check input fields
      expect(find.text('Account Balance'), findsOneWidget);
      expect(find.text('Risk Amount'), findsOneWidget);

      // Check toggle buttons
      expect(find.text('Fixed Amount'), findsOneWidget);
      expect(find.text('Percentage'), findsOneWidget);

      // Check default values
      expect(find.text('10000'), findsOneWidget); // Default account balance
      expect(find.text('200'), findsOneWidget); // Default risk amount

      // Check market info
      expect(find.text('Current Price'), findsOneWidget);
      expect(find.text('Stop Loss'), findsOneWidget);
      expect(find.text('Stop Distance'), findsOneWidget);

      // Check results
      expect(find.text('Recommended Position Size'), findsOneWidget);
      expect(find.textContaining('shares'), findsOneWidget);
      expect(find.text('% of Account'), findsOneWidget);
      expect(find.text('Max Loss'), findsOneWidget);
    });

    testWidgets('should calculate position size with fixed amount correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Default: $10,000 account, $200 risk, $5 stop loss distance
      // Position size: 200 / 5 = 40 shares
      expect(find.text('40 shares'), findsOneWidget);
      
      // Total value: 40 * 100 = $4,000
      expect(find.text('Total Value: \$4000.00'), findsOneWidget);
      
      // % of account: 4000 / 10000 = 40%
      expect(find.text('40.00%'), findsOneWidget);
      
      // Max loss: 40 * 5 = $200
      expect(find.text('\$200.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('should switch between fixed amount and percentage modes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Initially in fixed amount mode
      expect(find.text('Risk Amount'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);

      // Switch to percentage mode
      await tester.tap(find.text('Percentage'));
      await tester.pumpAndSettle();

      // Should update label and default value
      expect(find.text('Risk Percentage'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      // With 2% risk on $10,000 = $200 risk
      // Position size: 200 / 5 = 40 shares (same result)
      expect(find.text('40 shares'), findsOneWidget);
    });

    testWidgets('should update calculations when account balance changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Find account balance field
      final textFields = find.byType(TextField).evaluate().toList();
      final accountBalanceField = find.byWidget(textFields[0].widget);

      // Change account balance to $20,000
      await tester.tap(accountBalanceField);
      await tester.pumpAndSettle();
      await tester.enterText(accountBalanceField, '20000');
      await tester.pumpAndSettle();

      // Position size should still be 40 shares (fixed amount mode)
      expect(find.text('40 shares'), findsOneWidget);
      
      // % of account: 4000 / 20000 = 20%
      expect(find.text('20.00%'), findsOneWidget);
    });

    testWidgets('should update calculations when risk amount changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Find risk amount field
      final textFields = find.byType(TextField).evaluate().toList();
      final riskAmountField = find.byWidget(textFields[1].widget);

      // Change risk amount to $400
      await tester.tap(riskAmountField);
      await tester.pumpAndSettle();
      await tester.enterText(riskAmountField, '400');
      await tester.pumpAndSettle();

      // Position size: 400 / 5 = 80 shares
      expect(find.text('80 shares'), findsOneWidget);
      
      // Total value: 80 * 100 = $8,000
      expect(find.text('Total Value: \$8000.00'), findsOneWidget);
    });

    testWidgets('should show warning when position size exceeds 30% of account', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Default setup gives 40% position, should show warning
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(
        find.text('Position size exceeds 30% of account. Consider reducing for better risk management.'),
        findsOneWidget,
      );
    });

    testWidgets('should not show warning when position size is below 30%', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Change risk amount to $100 to get 20% position
      final textFields = find.byType(TextField).evaluate().toList();
      final riskAmountField = find.byWidget(textFields[1].widget);

      await tester.tap(riskAmountField);
      await tester.pumpAndSettle();
      await tester.enterText(riskAmountField, '100');
      await tester.pumpAndSettle();

      // Position size: 100 / 5 = 20 shares
      // Total value: 20 * 100 = $2,000
      // % of account: 2000 / 10000 = 20%
      expect(find.text('20.00%'), findsOneWidget);
      
      // Should not show warning
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets('should handle edge case with zero stop loss distance', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 100.0, // Same as current price
      ));

      // Position size should be 0 when stop loss distance is 0
      expect(find.text('0 shares'), findsOneWidget);
    });

    testWidgets('should display correct colors for position size percentage', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      // Default 40% should be orange/red color
      final percentText = find.text('40.00%').evaluate().first.widget as Text;
      expect(percentText.style?.color, equals(Colors.orange));
    });

    testWidgets('should calculate correctly in percentage mode', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 90.0, // 10% stop loss
      ));

      // Switch to percentage mode
      await tester.tap(find.text('Percentage'));
      await tester.pumpAndSettle();

      // Change risk to 1%
      final textFields = find.byType(TextField).evaluate().toList();
      final riskPercentField = find.byWidget(textFields[1].widget);

      await tester.tap(riskPercentField);
      await tester.pumpAndSettle();
      await tester.enterText(riskPercentField, '1');
      await tester.pumpAndSettle();

      // 1% of $10,000 = $100 risk
      // Stop loss distance: $10
      // Position size: 100 / 10 = 10 shares
      expect(find.text('10 shares'), findsOneWidget);
      
      // Total value: 10 * 100 = $1,000
      expect(find.text('Total Value: \$1000.00'), findsOneWidget);
      
      // % of account: 1000 / 10000 = 10%
      expect(find.text('10.00%'), findsOneWidget);
    });

    testWidgets('should format input with decimal restrictions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
      ));

      final textFields = find.byType(TextField).evaluate().toList();
      final accountBalanceField = find.byWidget(textFields[0].widget);

      // Try to enter more than 2 decimal places
      await tester.tap(accountBalanceField);
      await tester.pumpAndSettle();
      await tester.enterText(accountBalanceField, '10000.999');
      await tester.pumpAndSettle();

      // Should only allow 2 decimal places
      expect(find.text('10000.99'), findsOneWidget);
    });

    testWidgets('should display stop loss information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 90.0,
      ));

      // Check current price display
      expect(find.text('\$100.00'), findsOneWidget);
      
      // Check stop loss display
      expect(find.text('\$90.00'), findsOneWidget);
      
      // Check stop distance: $10 (10%)
      expect(find.text('\$10.00 (10.00%)'), findsOneWidget);
    });
  });
}