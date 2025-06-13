import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/widgets/risk_calculator.dart';

void main() {
  group('RiskCalculator Widget Tests', () {
    Widget createTestWidget({
      required double currentPrice,
      required double stopLoss,
      required double takeProfit,
    }) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: RiskCalculator(
            currentPrice: currentPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
          ),
        ),
      );
    }

    testWidgets('should display all input fields and labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      // Check title
      expect(find.text('Risk Calculator'), findsOneWidget);
      expect(find.byIcon(Icons.calculate_outlined), findsOneWidget);

      // Check input fields
      expect(find.text('Account Size'), findsOneWidget);
      expect(find.text('Risk per Trade'), findsOneWidget);

      // Check default values
      expect(find.text('10000'), findsOneWidget); // Default account size
      expect(find.text('2'), findsOneWidget); // Default risk percent

      // Check result labels
      expect(find.text('Risk Amount'), findsOneWidget);
      expect(find.text('Position Size'), findsOneWidget);
      expect(find.text('Total Investment'), findsOneWidget);
      expect(find.text('Potential Profit'), findsOneWidget);
      expect(find.text('Potential Loss'), findsOneWidget);
      expect(find.text('Risk/Reward Ratio'), findsOneWidget);
    });

    testWidgets('should calculate values correctly with default inputs', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      // Default: $10,000 account, 2% risk
      // Risk amount: $200
      // Stop loss amount: $5
      // Position size: 40 shares
      // Total investment: $4,000
      // Potential profit: $400
      // Potential loss: $200
      // Risk/Reward ratio: 2.0

      // Risk amount appears once
      final riskAmountText = find.text('\$200.00').evaluate().where((element) {
        final widget = element.widget;
        if (widget is Text && widget.style?.color == Colors.orange) {
          return true;
        }
        return false;
      });
      expect(riskAmountText.length, equals(1));
      expect(find.text('40 shares'), findsOneWidget); // Position size
      expect(find.text('\$4000.00'), findsOneWidget); // Total investment
      expect(find.text('\$400.00'), findsOneWidget); // Potential profit
      // Potential loss appears once  
      final lossText = find.text('\$200.00').evaluate().where((element) {
        final widget = element.widget;
        if (widget is Text && widget.style?.color == const Color(0xFFFF3B30)) {
          return true;
        }
        return false;
      });
      expect(lossText.length, equals(1));
      expect(find.text('1:2.00'), findsOneWidget); // Risk/Reward ratio
    });

    testWidgets('should update calculations when account size changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      // Find account size input field by finding all TextFields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // First TextField should be account size
      final accountSizeField = textFields.at(0);

      // Clear and enter new value
      await tester.enterText(accountSizeField, '20000');
      await tester.pumpAndSettle();

      // New calculations with $20,000 account
      // Risk amount: $400 (appears twice - as risk amount and potential loss)
      expect(find.text('\$400.00'), findsNWidgets(2));
    });

    testWidgets('should update calculations when risk percent changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      // Find risk percent input field
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      
      // Second TextField should be risk percent
      final riskPercentField = textFields.at(1);

      // Clear and enter new value
      await tester.enterText(riskPercentField, '1');
      await tester.pumpAndSettle();

      // New calculations with 1% risk
      // Risk amount: $100 (appears twice - as risk amount and potential loss)
      expect(find.text('\$100.00'), findsNWidgets(2));
    });

    testWidgets('should show warning when risk/reward ratio is below 1:1', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 90.0, // 10% stop loss
        takeProfit: 105.0, // Only 5% take profit
      ));

      // Risk/Reward ratio should be 0.5
      expect(find.text('1:0.50'), findsOneWidget);

      // Should show warning
      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
      expect(
        find.text('Risk/Reward ratio is below 1:1. Consider adjusting your targets.'),
        findsOneWidget,
      );
    });

    testWidgets('should not show warning when risk/reward ratio is above 1:1', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      // Risk/Reward ratio should be 2.0
      expect(find.text('1:2.00'), findsOneWidget);

      // Should not show warning
      expect(find.byIcon(Icons.warning_amber_outlined), findsNothing);
    });

    testWidgets('should handle edge cases gracefully', (WidgetTester tester) async {
      // Test with zero stop loss difference
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 100.0, // Same as current price
        takeProfit: 110.0,
      ));

      // Position size should be 0 when stop loss amount is 0
      expect(find.text('0 shares'), findsOneWidget);
      expect(find.text('1:0.00'), findsOneWidget);
    });

    testWidgets('should format input with decimal restrictions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      final textFields = find.byType(TextField);
      final accountSizeField = textFields.at(0);

      // Try to enter more than 2 decimal places
      await tester.enterText(accountSizeField, '10000.999');
      await tester.pumpAndSettle();

      // Should only allow 2 decimal places
      expect(find.text('10000.99'), findsOneWidget);
    });

    testWidgets('should display correct colors for profit and loss', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      // Find potential profit text
      final profitText = find.text('\$400.00').evaluate().where((element) {
        final widget = element.widget;
        if (widget is Text) {
          return widget.style?.color == const Color(0xFF00D632);
        }
        return false;
      });
      expect(profitText.length, equals(1));

      // Find potential loss text
      final lossText = find.text('\$200.00').evaluate().where((element) {
        final widget = element.widget;
        if (widget is Text) {
          return widget.style?.color == const Color(0xFFFF3B30);
        }
        return false;
      });
      expect(lossText.length, equals(1));
    });

    testWidgets('should display correct color for risk/reward ratio', (WidgetTester tester) async {
      // Test good ratio (>= 2)
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 110.0,
      ));

      final goodRatioText = find.text('1:2.00').evaluate().first.widget as Text;
      expect(goodRatioText.style?.color, equals(const Color(0xFF00D632)));

      // Test medium ratio (>= 1 but < 2)
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 95.0,
        takeProfit: 107.0, // 1.4 ratio
      ));
      await tester.pumpAndSettle();

      final mediumRatioText = find.text('1:1.40').evaluate().first.widget as Text;
      expect(mediumRatioText.style?.color, equals(Colors.orange));

      // Test bad ratio (< 1)
      await tester.pumpWidget(createTestWidget(
        currentPrice: 100.0,
        stopLoss: 90.0,
        takeProfit: 105.0, // 0.5 ratio
      ));
      await tester.pumpAndSettle();

      final badRatioText = find.text('1:0.50').evaluate().first.widget as Text;
      expect(badRatioText.style?.color, equals(const Color(0xFFFF3B30)));
    });
  });
}