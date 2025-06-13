import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/widgets/candle_chart.dart';
import 'package:trader_app/models/candle_data.dart';

void main() {
  group('CandleChart Widget Tests', () {
    List<CandleData> createTestCandles() {
      final now = DateTime.now();
      return List.generate(10, (index) {
        final date = now.subtract(Duration(days: index));
        final basePrice = 100.0 + index * 2;
        return CandleData(
          date: date,
          open: basePrice,
          high: basePrice + 5,
          low: basePrice - 5,
          close: basePrice + (index.isEven ? 3 : -3),
          volume: 1000000.0 + index * 100000,
        );
      });
    }

    Widget createTestWidget({
      List<CandleData>? candles,
      double currentPrice = 100.0,
      double stopLoss = 90.0,
      double takeProfit = 110.0,
    }) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: CandleChart(
            candles: candles ?? createTestCandles(),
            currentPrice: currentPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
          ),
        ),
      );
    }

    testWidgets('should display chart title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      expect(find.text('Price Chart (60 Days)'), findsOneWidget);
    });

    testWidgets('should display price legend items', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        currentPrice: 105.50,
        stopLoss: 95.00,
        takeProfit: 115.00,
      ));
      
      // Check legend labels
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('Target'), findsOneWidget);
      expect(find.text('Stop Loss'), findsOneWidget);
      
      // Check legend values
      expect(find.text('\$105.50'), findsOneWidget);
      expect(find.text('\$115.00'), findsOneWidget);
      expect(find.text('\$95.00'), findsOneWidget);
    });

    testWidgets('should handle empty candle data', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        candles: [],
      ));
      
      // Should still display without crashing
      expect(find.text('Price Chart (60 Days)'), findsOneWidget);
    });

    testWidgets('should display chart container with correct height', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Find the main container
      final containerFinder = find.byWidgetPredicate(
        (widget) => widget is Container && 
                   widget.constraints?.maxHeight == 400,
      );
      
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('should have correct theme styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      
      // Find the main container with decoration
      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && 
                     widget.decoration is BoxDecoration,
        ).first,
      );
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
    });

    testWidgets('should update when candles data changes', (WidgetTester tester) async {
      // Initial candles
      final initialCandles = createTestCandles();
      await tester.pumpWidget(createTestWidget(candles: initialCandles));
      
      // Update with new candles
      final newCandles = List.generate(5, (index) {
        final date = DateTime.now().subtract(Duration(days: index));
        return CandleData(
          date: date,
          open: 200.0 + index,
          high: 205.0 + index,
          low: 195.0 + index,
          close: 202.0 + index,
          volume: 2000000.0,
        );
      });
      
      await tester.pumpWidget(createTestWidget(candles: newCandles));
      await tester.pumpAndSettle();
      
      // Chart should still be displayed
      expect(find.text('Price Chart (60 Days)'), findsOneWidget);
    });

    testWidgets('should calculate price range including stop loss and take profit', (WidgetTester tester) async {
      final candles = [
        CandleData(
          date: DateTime.now(),
          open: 100,
          high: 105,
          low: 95,
          close: 102,
          volume: 1000000,
        ),
      ];
      
      await tester.pumpWidget(createTestWidget(
        candles: candles,
        currentPrice: 102,
        stopLoss: 85, // Below candle low
        takeProfit: 120, // Above candle high
      ));
      
      // Should include stop loss and take profit in range calculation
      expect(find.text('\$85.00'), findsOneWidget);
      expect(find.text('\$120.00'), findsOneWidget);
    });

    testWidgets('should display with single candle data', (WidgetTester tester) async {
      final singleCandle = [
        CandleData(
          date: DateTime.now(),
          open: 100,
          high: 110,
          low: 90,
          close: 105,
          volume: 1500000,
        ),
      ];
      
      await tester.pumpWidget(createTestWidget(candles: singleCandle));
      
      // Should display without errors
      expect(find.text('Price Chart (60 Days)'), findsOneWidget);
    });

    testWidgets('should handle extreme price values', (WidgetTester tester) async {
      final extremeCandles = [
        CandleData(
          date: DateTime.now(),
          open: 0.01,
          high: 1000000,
          low: 0.001,
          close: 500,
          volume: 1000,
        ),
      ];
      
      await tester.pumpWidget(createTestWidget(
        candles: extremeCandles,
        currentPrice: 500,
        stopLoss: 0.001,
        takeProfit: 1000000,
      ));
      
      // Should handle extreme values without crashing
      expect(find.text('Price Chart (60 Days)'), findsOneWidget);
    });
  });

  group('CandleData Model Tests', () {
    test('should correctly identify bullish candles', () {
      final bullishCandle = CandleData(
        date: DateTime.now(),
        open: 100,
        high: 110,
        low: 95,
        close: 105,
        volume: 1000000,
      );
      
      expect(bullishCandle.isBullish, isTrue);
      expect(bullishCandle.isBearish, isFalse);
    });

    test('should correctly identify bearish candles', () {
      final bearishCandle = CandleData(
        date: DateTime.now(),
        open: 100,
        high: 105,
        low: 90,
        close: 95,
        volume: 1000000,
      );
      
      expect(bearishCandle.isBearish, isTrue);
      expect(bearishCandle.isBullish, isFalse);
    });

    test('should calculate body height correctly', () {
      final candle = CandleData(
        date: DateTime.now(),
        open: 100,
        high: 110,
        low: 90,
        close: 105,
        volume: 1000000,
      );
      
      expect(candle.bodyHeight, equals(5.0));
    });

    test('should calculate wick heights correctly for bullish candle', () {
      final bullishCandle = CandleData(
        date: DateTime.now(),
        open: 100,
        high: 110,
        low: 95,
        close: 105,
        volume: 1000000,
      );
      
      expect(bullishCandle.upperWickHeight, equals(5.0)); // 110 - 105
      expect(bullishCandle.lowerWickHeight, equals(5.0)); // 100 - 95
    });

    test('should calculate wick heights correctly for bearish candle', () {
      final bearishCandle = CandleData(
        date: DateTime.now(),
        open: 100,
        high: 105,
        low: 90,
        close: 95,
        volume: 1000000,
      );
      
      expect(bearishCandle.upperWickHeight, equals(5.0)); // 105 - 100
      expect(bearishCandle.lowerWickHeight, equals(5.0)); // 95 - 90
    });

    test('should serialize to JSON correctly', () {
      final date = DateTime(2024, 1, 1, 12, 0, 0);
      final candle = CandleData(
        date: date,
        open: 100,
        high: 110,
        low: 90,
        close: 105,
        volume: 1000000,
      );
      
      final json = candle.toJson();
      
      expect(json['date'], equals(date.toIso8601String()));
      expect(json['open'], equals(100));
      expect(json['high'], equals(110));
      expect(json['low'], equals(90));
      expect(json['close'], equals(105));
      expect(json['volume'], equals(1000000));
    });

    test('should deserialize from JSON correctly', () {
      final date = DateTime(2024, 1, 1, 12, 0, 0);
      final json = {
        'date': date.toIso8601String(),
        'open': 100,
        'high': 110,
        'low': 90,
        'close': 105,
        'volume': 1000000,
      };
      
      final candle = CandleData.fromJson(json);
      
      expect(candle.date, equals(date));
      expect(candle.open, equals(100));
      expect(candle.high, equals(110));
      expect(candle.low, equals(90));
      expect(candle.close, equals(105));
      expect(candle.volume, equals(1000000));
    });
  });
}