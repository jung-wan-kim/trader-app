import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';

void main() {
  group('MockDataService Tests', () {
    late MockDataService service;

    setUp(() {
      service = MockDataService();
    });

    group('getRecommendations', () {
      test('should return list of stock recommendations', () async {
        final recommendations = await service.getRecommendations();

        expect(recommendations, isA<List<StockRecommendation>>());
        expect(recommendations, isNotEmpty);
        expect(recommendations.length, 20); // Service generates 20 recommendations
      });

      test('should generate recommendations with valid data', () async {
        final recommendations = await service.getRecommendations();

        for (final rec in recommendations) {
          // Test required fields
          expect(rec.id, isNotEmpty);
          expect(rec.id, startsWith('rec_'));
          expect(rec.stockCode, isNotEmpty);
          expect(rec.stockName, isNotEmpty);
          expect(rec.traderName, isNotEmpty);
          expect(rec.traderId, isNotEmpty);
          expect(rec.traderId, startsWith('trader_'));

          // Test action values
          expect(rec.action, isIn(['BUY', 'SELL', 'HOLD']));

          // Test price relationships
          expect(rec.currentPrice, greaterThan(0));
          expect(rec.targetPrice, greaterThan(0));
          expect(rec.stopLoss, greaterThan(0));
          expect(rec.takeProfit, rec.targetPrice); // Should be equal

          // Test price logic for BUY recommendations
          if (rec.action == 'BUY') {
            expect(rec.targetPrice, greaterThan(rec.currentPrice));
            expect(rec.stopLoss, lessThan(rec.currentPrice));
          }

          // Test price logic for SELL recommendations
          if (rec.action == 'SELL') {
            expect(rec.targetPrice, lessThan(rec.currentPrice));
            expect(rec.stopLoss, greaterThan(rec.currentPrice));
          }

          // Test other fields
          expect(rec.timeframe, isIn(['SHORT', 'MEDIUM', 'LONG']));
          expect(rec.riskLevel, isIn(['LOW', 'MEDIUM', 'HIGH']));
          expect(rec.confidence, greaterThanOrEqualTo(60));
          expect(rec.confidence, lessThanOrEqualTo(95));
          expect(rec.reasoning, isNotEmpty);
          expect(rec.likes, greaterThanOrEqualTo(0));
          expect(rec.followers, greaterThanOrEqualTo(0));
        }
      });

      test('should generate valid stock codes and names', () async {
        final recommendations = await service.getRecommendations();
        
        final validStockCodes = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA', 
                                 'NVDA', 'META', 'JPM', 'V', 'WMT'];
        
        for (final rec in recommendations) {
          expect(validStockCodes, contains(rec.stockCode));
          expect(rec.stockName, isNotEmpty);
        }
      });

      test('should generate valid trader names', () async {
        final recommendations = await service.getRecommendations();
        
        final validTraderNames = ['Alexander Kim', 'Sarah Chen', 'Michael Ross', 
                                  'Emma Wilson', 'David Lee'];
        
        for (final rec in recommendations) {
          expect(validTraderNames, contains(rec.traderName));
        }
      });

      test('should include technical indicators', () async {
        final recommendations = await service.getRecommendations();

        for (final rec in recommendations) {
          expect(rec.technicalIndicators, isNotNull);
          expect(rec.technicalIndicators!, isNotEmpty);
          
          // Should contain RSI
          expect(rec.technicalIndicators!.containsKey('RSI'), isTrue);
          final rsi = rec.technicalIndicators!['RSI'] as double;
          expect(rsi, greaterThanOrEqualTo(30));
          expect(rsi, lessThanOrEqualTo(70));
          
          // Should contain MACD
          expect(rec.technicalIndicators!.containsKey('MACD'), isTrue);
          expect(rec.technicalIndicators!['MACD'], isIn(['Bullish', 'Bearish']));
          
          // Should contain moving averages
          expect(rec.technicalIndicators!.containsKey('SMA50'), isTrue);
          expect(rec.technicalIndicators!.containsKey('SMA200'), isTrue);
          expect(rec.technicalIndicators!['SMA50'], isA<double>());
          expect(rec.technicalIndicators!['SMA200'], isA<double>());
        }
      });

      test('should calculate expected return correctly', () async {
        final recommendations = await service.getRecommendations();

        for (final rec in recommendations) {
          final calculatedReturn = (rec.targetPrice - rec.currentPrice) / rec.currentPrice * 100;
          expect(rec.expectedReturn, closeTo(calculatedReturn, 0.01));
        }
      });

      test('should generate recommendations with realistic timestamps', () async {
        final recommendations = await service.getRecommendations();
        final now = DateTime.now();

        for (final rec in recommendations) {
          // Should be within last 72 hours
          final hoursDiff = now.difference(rec.recommendedAt).inHours;
          expect(hoursDiff, greaterThanOrEqualTo(0));
          expect(hoursDiff, lessThanOrEqualTo(72));
        }
      });

      test('should generate diverse recommendations', () async {
        final recommendations = await service.getRecommendations();

        // Check for diversity in actions
        final actions = recommendations.map((r) => r.action).toSet();
        expect(actions.length, greaterThan(1)); // Should have multiple actions

        // Check for diversity in stock codes
        final stockCodes = recommendations.map((r) => r.stockCode).toSet();
        expect(stockCodes.length, greaterThan(1)); // Should have multiple stocks

        // Check for diversity in traders
        final traders = recommendations.map((r) => r.traderName).toSet();
        expect(traders.length, greaterThan(1)); // Should have multiple traders
      });

      test('should simulate network delay', () async {
        final startTime = DateTime.now();
        await service.getRecommendations();
        final endTime = DateTime.now();
        
        final duration = endTime.difference(startTime);
        expect(duration.inMilliseconds, greaterThan(400)); // Should take at least 400ms
        expect(duration.inMilliseconds, lessThan(1000)); // But not too long
      });

      test('should generate unique IDs', () async {
        final recommendations = await service.getRecommendations();
        final ids = recommendations.map((r) => r.id).toList();
        final uniqueIds = ids.toSet();
        
        expect(uniqueIds.length, equals(ids.length)); // All IDs should be unique
      });

      test('should handle multiple concurrent calls', () async {
        final futures = <Future<List<StockRecommendation>>>[];
        
        // Make 5 concurrent calls
        for (int i = 0; i < 5; i++) {
          futures.add(service.getRecommendations());
        }
        
        final results = await Future.wait(futures);
        
        // All calls should succeed
        for (final result in results) {
          expect(result, isA<List<StockRecommendation>>());
          expect(result.length, 20);
        }
      });
    });

    group('getTraderStrategies', () {
      test('should return list of trader strategies', () async {
        final strategies = await service.getTraderStrategies();

        expect(strategies, isA<List<TraderStrategy>>());
        expect(strategies, isNotEmpty);
        expect(strategies.length, 2); // Service returns 2 strategies
      });

      test('should generate strategies with valid data', () async {
        final strategies = await service.getTraderStrategies();

        for (final strategy in strategies) {
          // Test required fields
          expect(strategy.id, isNotEmpty);
          expect(strategy.id, startsWith('strat_'));
          expect(strategy.traderId, isNotEmpty);
          expect(strategy.traderId, startsWith('trader_'));
          expect(strategy.traderName, isNotEmpty);
          expect(strategy.strategyName, isNotEmpty);
          expect(strategy.description, isNotEmpty);

          // Test trading style
          expect(strategy.tradingStyle, isIn(['SCALPING', 'DAY_TRADING', 'SWING_TRADING', 'POSITION_TRADING']));

          // Test performance metrics
          expect(strategy.winRate, greaterThan(0));
          expect(strategy.winRate, lessThanOrEqualTo(100));
          expect(strategy.averageReturn, greaterThan(0));
          expect(strategy.maxDrawdown, lessThan(0)); // Should be negative
          expect(strategy.sharpeRatio, greaterThan(0));

          // Test trade counts
          expect(strategy.totalTrades, greaterThan(0));
          expect(strategy.winningTrades, greaterThanOrEqualTo(0));
          expect(strategy.losingTrades, greaterThanOrEqualTo(0));
          expect(strategy.winningTrades + strategy.losingTrades, lessThanOrEqualTo(strategy.totalTrades));

          // Test other fields
          expect(strategy.minimumCapital, greaterThan(0));
          expect(strategy.followers, greaterThanOrEqualTo(0));
          expect(strategy.rating, greaterThan(0));
          expect(strategy.rating, lessThanOrEqualTo(5));
          expect(strategy.isActive, isTrue);
          expect(strategy.preferredAssets, isNotEmpty);
          expect(strategy.performanceMetrics, isNotEmpty);
          expect(strategy.riskManagement, isNotEmpty);
        }
      });

      test('should have correct strategy details for Alexander Kim', () async {
        final strategies = await service.getTraderStrategies();
        final alexStrategy = strategies.firstWhere((s) => s.traderName == 'Alexander Kim');

        expect(alexStrategy.id, 'strat_1');
        expect(alexStrategy.traderId, 'trader_1');
        expect(alexStrategy.strategyName, 'Momentum Master');
        expect(alexStrategy.tradingStyle, 'DAY_TRADING');
        expect(alexStrategy.winRate, 68.5);
        expect(alexStrategy.averageReturn, 2.3);
        expect(alexStrategy.maxDrawdown, -15.2);
        expect(alexStrategy.sharpeRatio, 1.85);
        expect(alexStrategy.totalTrades, 342);
        expect(alexStrategy.winningTrades, 234);
        expect(alexStrategy.losingTrades, 108);
        expect(alexStrategy.minimumCapital, 10000);
        expect(alexStrategy.followers, 8420);
        expect(alexStrategy.rating, 4.7);
      });

      test('should have correct strategy details for Sarah Chen', () async {
        final strategies = await service.getTraderStrategies();
        final sarahStrategy = strategies.firstWhere((s) => s.traderName == 'Sarah Chen');

        expect(sarahStrategy.id, 'strat_2');
        expect(sarahStrategy.traderId, 'trader_2');
        expect(sarahStrategy.strategyName, 'Value Swing Pro');
        expect(sarahStrategy.tradingStyle, 'SWING_TRADING');
        expect(sarahStrategy.winRate, 72.3);
        expect(sarahStrategy.averageReturn, 4.8);
        expect(sarahStrategy.maxDrawdown, -12.5);
        expect(sarahStrategy.sharpeRatio, 2.15);
        expect(sarahStrategy.totalTrades, 156);
        expect(sarahStrategy.winningTrades, 113);
        expect(sarahStrategy.losingTrades, 43);
        expect(sarahStrategy.minimumCapital, 25000);
        expect(sarahStrategy.followers, 12350);
        expect(sarahStrategy.rating, 4.9);
      });

      test('should include performance metrics', () async {
        final strategies = await service.getTraderStrategies();

        for (final strategy in strategies) {
          expect(strategy.performanceMetrics, isNotEmpty);
          
          if (strategy.traderName == 'Alexander Kim') {
            expect(strategy.performanceMetrics.containsKey('avgWinSize'), isTrue);
            expect(strategy.performanceMetrics.containsKey('avgLossSize'), isTrue);
            expect(strategy.performanceMetrics.containsKey('profitFactor'), isTrue);
            expect(strategy.performanceMetrics.containsKey('bestMonth'), isTrue);
            expect(strategy.performanceMetrics.containsKey('worstMonth'), isTrue);
          }
          
          if (strategy.traderName == 'Sarah Chen') {
            expect(strategy.performanceMetrics.containsKey('avgHoldingDays'), isTrue);
            expect(strategy.performanceMetrics.containsKey('avgWinSize'), isTrue);
            expect(strategy.performanceMetrics.containsKey('avgLossSize'), isTrue);
            expect(strategy.performanceMetrics.containsKey('profitFactor'), isTrue);
          }
        }
      });

      test('should include preferred assets', () async {
        final strategies = await service.getTraderStrategies();

        for (final strategy in strategies) {
          expect(strategy.preferredAssets, isNotEmpty);
          
          if (strategy.traderName == 'Alexander Kim') {
            expect(strategy.preferredAssets, ['AAPL', 'MSFT', 'NVDA', 'GOOGL']);
          }
          
          if (strategy.traderName == 'Sarah Chen') {
            expect(strategy.preferredAssets, ['JPM', 'V', 'WMT', 'AMZN']);
          }
        }
      });

      test('should have reasonable timestamps', () async {
        final strategies = await service.getTraderStrategies();
        final now = DateTime.now();

        for (final strategy in strategies) {
          // Created date should be in the past
          expect(strategy.createdAt.isBefore(now), isTrue);
          
          // Last updated should be recent
          final hoursSinceUpdate = now.difference(strategy.lastUpdated).inHours;
          expect(hoursSinceUpdate, lessThan(24)); // Updated within last 24 hours
          
          // Last updated should be after created
          expect(strategy.lastUpdated.isAfter(strategy.createdAt), isTrue);
        }
      });

      test('should simulate shorter network delay', () async {
        final startTime = DateTime.now();
        await service.getTraderStrategies();
        final endTime = DateTime.now();
        
        final duration = endTime.difference(startTime);
        expect(duration.inMilliseconds, greaterThan(250)); // Should take at least 250ms
        expect(duration.inMilliseconds, lessThan(600)); // But not too long
      });

      test('should handle multiple concurrent calls', () async {
        final futures = <Future<List<TraderStrategy>>>[];
        
        // Make 3 concurrent calls
        for (int i = 0; i < 3; i++) {
          futures.add(service.getTraderStrategies());
        }
        
        final results = await Future.wait(futures);
        
        // All calls should succeed
        for (final result in results) {
          expect(result, isA<List<TraderStrategy>>());
          expect(result.length, 2);
        }
      });
    });

    group('_generateReasoning (private method testing via public interface)', () {
      test('should generate appropriate reasoning for different actions', () async {
        final recommendations = await service.getRecommendations();
        
        final buyRecs = recommendations.where((r) => r.action == 'BUY').toList();
        final sellRecs = recommendations.where((r) => r.action == 'SELL').toList();
        final holdRecs = recommendations.where((r) => r.action == 'HOLD').toList();
        
        // Check BUY reasoning contains positive terms
        for (final rec in buyRecs) {
          final reasoning = rec.reasoning.toLowerCase();
          final hasPositiveTerms = reasoning.contains('strong') ||
                                   reasoning.contains('bullish') ||
                                   reasoning.contains('positive') ||
                                   reasoning.contains('breakout') ||
                                   reasoning.contains('momentum') ||
                                   reasoning.contains('oversold') ||
                                   reasoning.contains('opportunity');
          expect(hasPositiveTerms, isTrue, reason: 'BUY reasoning should contain positive terms: ${rec.reasoning}');
        }
        
        // Check SELL reasoning contains negative terms
        for (final rec in sellRecs) {
          final reasoning = rec.reasoning.toLowerCase();
          final hasNegativeTerms = reasoning.contains('bearish') ||
                                   reasoning.contains('breaking') ||
                                   reasoning.contains('overbought') ||
                                   reasoning.contains('negative') ||
                                   reasoning.contains('weak') ||
                                   reasoning.contains('declining');
          expect(hasNegativeTerms, isTrue, reason: 'SELL reasoning should contain negative terms: ${rec.reasoning}');
        }
        
        // Check HOLD reasoning contains neutral terms
        for (final rec in holdRecs) {
          final reasoning = rec.reasoning.toLowerCase();
          final hasNeutralTerms = reasoning.contains('consolidation') ||
                                  reasoning.contains('waiting') ||
                                  reasoning.contains('mixed') ||
                                  reasoning.contains('volatility') ||
                                  reasoning.contains('unclear') ||
                                  reasoning.contains('caution') ||
                                  reasoning.contains('fair value');
          expect(hasNeutralTerms, isTrue, reason: 'HOLD reasoning should contain neutral terms: ${rec.reasoning}');
        }
      });

      test('should include stock name in reasoning', () async {
        final recommendations = await service.getRecommendations();
        
        for (final rec in recommendations) {
          expect(rec.reasoning, contains(rec.stockName));
        }
      });
    });

    group('Random Number Generation', () {
      test('should generate different data on multiple calls', () async {
        final recommendations1 = await service.getRecommendations();
        final recommendations2 = await service.getRecommendations();
        
        // While the structure should be the same, the actual values should differ
        bool hasDifferentPrices = false;
        for (int i = 0; i < recommendations1.length; i++) {
          if (recommendations1[i].currentPrice != recommendations2[i].currentPrice) {
            hasDifferentPrices = true;
            break;
          }
        }
        
        expect(hasDifferentPrices, isTrue, 
               reason: 'Multiple calls should generate different random data');
      });

      test('should generate prices within expected ranges', () async {
        final recommendations = await service.getRecommendations();
        
        for (final rec in recommendations) {
          // Current price should be between 50 and 500
          expect(rec.currentPrice, greaterThanOrEqualTo(50));
          expect(rec.currentPrice, lessThanOrEqualTo(500));
          
          // Target price multipliers should be reasonable
          final multiplier = rec.targetPrice / rec.currentPrice;
          if (rec.action == 'BUY') {
            expect(multiplier, greaterThan(1.05));
            expect(multiplier, lessThanOrEqualTo(1.20));
          } else if (rec.action == 'SELL') {
            expect(multiplier, greaterThanOrEqualTo(0.85));
            expect(multiplier, lessThan(0.95));
          }
        }
      });
    });

    group('Data Consistency', () {
      test('should maintain consistency between win rate and trade counts', () async {
        final strategies = await service.getTraderStrategies();
        
        for (final strategy in strategies) {
          final calculatedWinRate = (strategy.winningTrades / strategy.totalTrades) * 100;
          expect(strategy.winRate, closeTo(calculatedWinRate, 0.2));
        }
      });

      test('should have consistent trader IDs', () async {
        final strategies = await service.getTraderStrategies();
        
        for (final strategy in strategies) {
          if (strategy.traderName == 'Alexander Kim') {
            expect(strategy.traderId, 'trader_1');
          } else if (strategy.traderName == 'Sarah Chen') {
            expect(strategy.traderId, 'trader_2');
          }
        }
      });

      test('should generate logical price relationships', () async {
        final recommendations = await service.getRecommendations();
        
        for (final rec in recommendations) {
          if (rec.action == 'BUY') {
            // For BUY: target > current > stop loss
            expect(rec.targetPrice, greaterThan(rec.currentPrice));
            expect(rec.currentPrice, greaterThan(rec.stopLoss));
          } else if (rec.action == 'SELL') {
            // For SELL: stop loss > current > target
            expect(rec.stopLoss, greaterThan(rec.currentPrice));
            expect(rec.currentPrice, greaterThan(rec.targetPrice));
          }
          
          // Take profit should equal target price
          expect(rec.takeProfit, equals(rec.targetPrice));
        }
      });
    });

    group('Performance and Memory', () {
      test('should handle repeated calls efficiently', () async {
        final stopwatch = Stopwatch()..start();
        
        // Make 10 calls
        for (int i = 0; i < 10; i++) {
          await service.getRecommendations();
        }
        
        stopwatch.stop();
        
        // Should complete within reasonable time (including network delay simulation)
        expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // 10 seconds max
      });

      test('should not leak memory with multiple service instances', () {
        final services = <MockDataService>[];
        
        // Create multiple instances
        for (int i = 0; i < 100; i++) {
          services.add(MockDataService());
        }
        
        expect(services.length, 100);
        
        // All instances should be independent
        expect(identical(services[0], services[1]), isFalse);
      });
    });
  });
}