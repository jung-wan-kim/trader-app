import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/models/trader_strategy.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('TraderStrategy Model Tests', () {
    late TraderStrategy mockStrategy;
    late Map<String, dynamic> validJson;

    setUp(() {
      mockStrategy = TestHelper.createMockTraderStrategy();
      validJson = TestHelper.mockTraderStrategyJson;
    });

    group('Constructor', () {
      test('should create instance with all required fields', () {
        expect(mockStrategy.id, 'strategy-1');
        expect(mockStrategy.traderId, 'trader-1');
        expect(mockStrategy.traderName, 'Jesse Livermore');
        expect(mockStrategy.strategyName, 'Trend Following Strategy');
        expect(mockStrategy.tradingStyle, 'SWING_TRADING');
        expect(mockStrategy.winRate, 75.0);
        expect(mockStrategy.averageReturn, 15.5);
        expect(mockStrategy.totalTrades, 100);
        expect(mockStrategy.winningTrades, 75);
        expect(mockStrategy.losingTrades, 25);
        expect(mockStrategy.isActive, isTrue);
      });

      test('should handle optional profileImageUrl', () {
        final strategy = TraderStrategy(
          id: 'test',
          traderId: 'trader-test',
          traderName: 'Test Trader',
          strategyName: 'Test Strategy',
          description: 'Test description',
          tradingStyle: 'DAY_TRADING',
          winRate: 60.0,
          averageReturn: 10.0,
          maxDrawdown: -5.0,
          sharpeRatio: 1.2,
          totalTrades: 50,
          winningTrades: 30,
          losingTrades: 20,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
          preferredAssets: ['stocks'],
          performanceMetrics: {},
          riskManagement: 'Test risk management',
          minimumCapital: 5000.0,
          followers: 1000,
          rating: 4.0,
          isActive: true,
          // profileImageUrl is null by default
        );

        expect(strategy.profileImageUrl, isNull);
      });
    });

    group('Computed Properties', () {
      test('lossRate should calculate correctly', () {
        // winRate = 75.0, so lossRate = 100 - 75 = 25.0
        expect(mockStrategy.lossRate, 25.0);
      });

      test('lossRate should handle edge cases', () {
        final perfectStrategy = TestHelper.createMockTraderStrategy(winRate: 100.0);
        expect(perfectStrategy.lossRate, 0.0);

        final losingStrategy = TestHelper.createMockTraderStrategy(winRate: 0.0);
        expect(losingStrategy.lossRate, 100.0);
      });

      test('profitFactor should calculate correctly with positive returns', () {
        // Given the mock data: 75 winning trades, 25 losing trades, averageReturn = 15.5
        // profitFactor = (75 * 15.5) / (25 * 15.5) = 1162.5 / 387.5 = 3.0
        expect(mockStrategy.profitFactor, 3.0);
      });

      test('profitFactor should handle negative average returns', () {
        final strategy = TraderStrategy(
          id: 'test',
          traderId: 'trader-test',
          traderName: 'Test Trader',
          strategyName: 'Test Strategy',
          description: 'Test',
          tradingStyle: 'SCALPING',
          winRate: 40.0,
          averageReturn: -5.0, // negative average return
          maxDrawdown: -15.0,
          sharpeRatio: 0.5,
          totalTrades: 100,
          winningTrades: 40,
          losingTrades: 60,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
          preferredAssets: ['futures'],
          performanceMetrics: {},
          riskManagement: 'Test',
          minimumCapital: 1000.0,
          followers: 100,
          rating: 2.0,
          isActive: true,
        );

        // (40 * -5.0) / (60 * 5.0) = -200 / 300 = -0.667
        expect(strategy.profitFactor, closeTo(-0.667, 0.001));
      });

      test('profitFactor should return 0 when no winning or losing trades', () {
        final noWinStrategy = TestHelper.createMockTraderStrategy();
        final strategy = TraderStrategy(
          id: noWinStrategy.id,
          traderId: noWinStrategy.traderId,
          traderName: noWinStrategy.traderName,
          strategyName: noWinStrategy.strategyName,
          description: noWinStrategy.description,
          tradingStyle: noWinStrategy.tradingStyle,
          winRate: noWinStrategy.winRate,
          averageReturn: noWinStrategy.averageReturn,
          maxDrawdown: noWinStrategy.maxDrawdown,
          sharpeRatio: noWinStrategy.sharpeRatio,
          totalTrades: noWinStrategy.totalTrades,
          winningTrades: 0, // no winning trades
          losingTrades: noWinStrategy.losingTrades,
          createdAt: noWinStrategy.createdAt,
          lastUpdated: noWinStrategy.lastUpdated,
          preferredAssets: noWinStrategy.preferredAssets,
          performanceMetrics: noWinStrategy.performanceMetrics,
          riskManagement: noWinStrategy.riskManagement,
          minimumCapital: noWinStrategy.minimumCapital,
          followers: noWinStrategy.followers,
          rating: noWinStrategy.rating,
          isActive: noWinStrategy.isActive,
        );

        expect(strategy.profitFactor, 0);
      });

      test('profitFactor should return 0 when no losing trades', () {
        final noLossStrategy = TestHelper.createMockTraderStrategy();
        final strategy = TraderStrategy(
          id: noLossStrategy.id,
          traderId: noLossStrategy.traderId,
          traderName: noLossStrategy.traderName,
          strategyName: noLossStrategy.strategyName,
          description: noLossStrategy.description,
          tradingStyle: noLossStrategy.tradingStyle,
          winRate: noLossStrategy.winRate,
          averageReturn: noLossStrategy.averageReturn,
          maxDrawdown: noLossStrategy.maxDrawdown,
          sharpeRatio: noLossStrategy.sharpeRatio,
          totalTrades: noLossStrategy.totalTrades,
          winningTrades: noLossStrategy.winningTrades,
          losingTrades: 0, // no losing trades
          createdAt: noLossStrategy.createdAt,
          lastUpdated: noLossStrategy.lastUpdated,
          preferredAssets: noLossStrategy.preferredAssets,
          performanceMetrics: noLossStrategy.performanceMetrics,
          riskManagement: noLossStrategy.riskManagement,
          minimumCapital: noLossStrategy.minimumCapital,
          followers: noLossStrategy.followers,
          rating: noLossStrategy.rating,
          isActive: noLossStrategy.isActive,
        );

        expect(strategy.profitFactor, 0);
      });
    });

    group('JSON Serialization', () {
      test('fromJson should create correct instance from valid JSON', () {
        final strategy = TraderStrategy.fromJson(validJson);

        expect(strategy.id, validJson['id']);
        expect(strategy.traderId, validJson['traderId']);
        expect(strategy.traderName, validJson['traderName']);
        expect(strategy.strategyName, validJson['strategyName']);
        expect(strategy.tradingStyle, validJson['tradingStyle']);
        expect(strategy.winRate, validJson['winRate']);
        expect(strategy.averageReturn, validJson['averageReturn']);
        expect(strategy.totalTrades, validJson['totalTrades']);
        expect(strategy.isActive, validJson['isActive']);
      });

      test('fromJson should parse DateTime fields correctly', () {
        final strategy = TraderStrategy.fromJson(validJson);
        expect(strategy.createdAt, DateTime.parse(validJson['createdAt']));
        expect(strategy.lastUpdated, DateTime.parse(validJson['lastUpdated']));
      });

      test('fromJson should handle List<String> for preferredAssets', () {
        final strategy = TraderStrategy.fromJson(validJson);
        expect(strategy.preferredAssets, isA<List<String>>());
        expect(strategy.preferredAssets, equals(validJson['preferredAssets']));
      });

      test('fromJson should handle Map for performanceMetrics', () {
        final strategy = TraderStrategy.fromJson(validJson);
        expect(strategy.performanceMetrics, isA<Map<String, dynamic>>());
        expect(strategy.performanceMetrics, equals(validJson['performanceMetrics']));
      });

      test('fromJson should handle null profileImageUrl', () {
        final jsonWithNullImage = Map<String, dynamic>.from(validJson);
        jsonWithNullImage['profileImageUrl'] = null;

        final strategy = TraderStrategy.fromJson(jsonWithNullImage);
        expect(strategy.profileImageUrl, isNull);
      });

      test('fromJson should convert numeric fields to correct types', () {
        final jsonWithInts = Map<String, dynamic>.from(validJson);
        jsonWithInts['winRate'] = 75; // int instead of double
        jsonWithInts['averageReturn'] = 15;
        jsonWithInts['rating'] = 4;

        final strategy = TraderStrategy.fromJson(jsonWithInts);
        expect(strategy.winRate, isA<double>());
        expect(strategy.averageReturn, isA<double>());
        expect(strategy.rating, isA<double>());
      });

      test('toJson should create correct JSON representation', () {
        final json = mockStrategy.toJson();

        expect(json['id'], mockStrategy.id);
        expect(json['traderId'], mockStrategy.traderId);
        expect(json['strategyName'], mockStrategy.strategyName);
        expect(json['winRate'], mockStrategy.winRate);
        expect(json['isActive'], mockStrategy.isActive);
        expect(json['createdAt'], mockStrategy.createdAt.toIso8601String());
        expect(json['lastUpdated'], mockStrategy.lastUpdated.toIso8601String());
        expect(json['preferredAssets'], mockStrategy.preferredAssets);
        expect(json['performanceMetrics'], mockStrategy.performanceMetrics);
      });

      test('JSON round-trip should preserve data', () {
        final json = mockStrategy.toJson();
        final reconstructed = TraderStrategy.fromJson(json);

        expect(reconstructed.id, mockStrategy.id);
        expect(reconstructed.traderId, mockStrategy.traderId);
        expect(reconstructed.winRate, mockStrategy.winRate);
        expect(reconstructed.totalTrades, mockStrategy.totalTrades);
        expect(reconstructed.isActive, mockStrategy.isActive);
        expect(reconstructed.createdAt, mockStrategy.createdAt);
        expect(reconstructed.preferredAssets, mockStrategy.preferredAssets);
      });
    });

    group('Trading Style Validation', () {
      test('should accept valid trading styles', () {
        final validStyles = ['SCALPING', 'DAY_TRADING', 'SWING_TRADING', 'POSITION_TRADING'];
        
        for (String style in validStyles) {
          final strategy = TestHelper.createMockTraderStrategy(tradingStyle: style);
          expect(strategy.tradingStyle, style);
        }
      });

      test('should handle custom trading styles', () {
        final strategy = TestHelper.createMockTraderStrategy(tradingStyle: 'CUSTOM_STYLE');
        expect(strategy.tradingStyle, 'CUSTOM_STYLE');
      });
    });

    group('Performance Metrics Validation', () {
      test('should validate win rate boundaries', () {
        expect(() => TestHelper.createMockTraderStrategy(winRate: 0.0), returnsNormally);
        expect(() => TestHelper.createMockTraderStrategy(winRate: 100.0), returnsNormally);
        expect(() => TestHelper.createMockTraderStrategy(winRate: 50.5), returnsNormally);
      });

      test('should handle extreme win rates', () {
        final perfectStrategy = TestHelper.createMockTraderStrategy(winRate: 100.0);
        expect(perfectStrategy.lossRate, 0.0);

        final failingStrategy = TestHelper.createMockTraderStrategy(winRate: 0.0);
        expect(failingStrategy.lossRate, 100.0);
      });

      test('should validate consistency between total and individual trades', () {
        final strategy = TestHelper.createMockTraderStrategy();
        expect(strategy.winningTrades + strategy.losingTrades, lessThanOrEqualTo(strategy.totalTrades));
      });
    });

    group('Edge Cases', () {
      test('should handle zero trades scenario', () {
        final strategy = TraderStrategy(
          id: 'zero-trades',
          traderId: 'trader-new',
          traderName: 'New Trader',
          strategyName: 'New Strategy',
          description: 'Brand new strategy',
          tradingStyle: 'SWING_TRADING',
          winRate: 0.0,
          averageReturn: 0.0,
          maxDrawdown: 0.0,
          sharpeRatio: 0.0,
          totalTrades: 0,
          winningTrades: 0,
          losingTrades: 0,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
          preferredAssets: [],
          performanceMetrics: {},
          riskManagement: 'Not established',
          minimumCapital: 1000.0,
          followers: 0,
          rating: 0.0,
          isActive: true,
        );

        expect(strategy.totalTrades, 0);
        expect(strategy.profitFactor, 0);
        expect(strategy.lossRate, 100.0);
      });

      test('should handle extreme values', () {
        final extremeStrategy = TraderStrategy(
          id: 'extreme',
          traderId: 'trader-extreme',
          traderName: 'Extreme Trader',
          strategyName: 'Extreme Strategy',
          description: 'Extreme values test',
          tradingStyle: 'SCALPING',
          winRate: 99.9,
          averageReturn: 1000.0,
          maxDrawdown: -50.0,
          sharpeRatio: 10.0,
          totalTrades: 10000,
          winningTrades: 9990,
          losingTrades: 10,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
          preferredAssets: ['crypto', 'forex', 'commodities'],
          performanceMetrics: {'extreme_metric': 9999.99},
          riskManagement: 'Extreme risk management',
          minimumCapital: 1000000.0,
          followers: 100000,
          rating: 5.0,
          isActive: true,
        );

        expect(extremeStrategy.winRate, 99.9);
        expect(extremeStrategy.lossRate, closeTo(0.1, 0.01));
        expect(extremeStrategy.profitFactor, 999.0); // (9990 * 1000) / (10 * 1000)
      });

      test('should handle inactive strategies', () {
        final inactiveStrategy = TestHelper.createMockTraderStrategy(isActive: false);
        expect(inactiveStrategy.isActive, isFalse);
      });

      test('should handle empty preferred assets', () {
        final strategy = TraderStrategy(
          id: 'empty-assets',
          traderId: 'trader-1',
          traderName: 'Test Trader',
          strategyName: 'Test Strategy',
          description: 'Test',
          tradingStyle: 'DAY_TRADING',
          winRate: 60.0,
          averageReturn: 10.0,
          maxDrawdown: -5.0,
          sharpeRatio: 1.0,
          totalTrades: 50,
          winningTrades: 30,
          losingTrades: 20,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
          preferredAssets: [], // empty list
          performanceMetrics: {},
          riskManagement: 'Test',
          minimumCapital: 1000.0,
          followers: 100,
          rating: 3.0,
          isActive: true,
        );

        expect(strategy.preferredAssets, isEmpty);
      });
    });

    group('Error Handling', () {
      test('fromJson should throw when required fields are missing', () {
        final incompleteJson = <String, dynamic>{
          'id': 'test',
          'traderId': 'trader-1',
          // missing other required fields
        };

        expect(() => TraderStrategy.fromJson(incompleteJson), throwsA(isA<Error>()));
      });

      test('fromJson should throw on invalid DateTime format', () {
        final invalidJson = Map<String, dynamic>.from(validJson);
        invalidJson['createdAt'] = 'invalid-date-format';

        expect(() => TraderStrategy.fromJson(invalidJson), throwsA(isA<FormatException>()));
      });

      test('fromJson should throw on null required fields', () {
        final nullJson = Map<String, dynamic>.from(validJson);
        nullJson['id'] = null;

        expect(() => TraderStrategy.fromJson(nullJson), throwsA(isA<TypeError>()));
      });

      test('fromJson should handle malformed preferredAssets', () {
        final malformedJson = Map<String, dynamic>.from(validJson);
        malformedJson['preferredAssets'] = 'not-a-list';

        expect(() => TraderStrategy.fromJson(malformedJson), throwsA(isA<TypeError>()));
      });
    });

    group('Business Logic Validation', () {
      test('should identify high-performance strategies', () {
        final highPerformance = TestHelper.createMockTraderStrategy(
          winRate: 80.0,
        );
        expect(highPerformance.winRate, greaterThan(75.0));
        expect(highPerformance.lossRate, lessThan(25.0));
      });

      test('should identify risky strategies', () {
        final riskyStrategy = TraderStrategy(
          id: 'risky',
          traderId: 'trader-risky',
          traderName: 'Risky Trader',
          strategyName: 'High Risk Strategy',
          description: 'High risk high reward',
          tradingStyle: 'SCALPING',
          winRate: 45.0,
          averageReturn: 25.0,
          maxDrawdown: -30.0,
          sharpeRatio: 0.8,
          totalTrades: 200,
          winningTrades: 90,
          losingTrades: 110,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
          preferredAssets: ['crypto'],
          performanceMetrics: {'volatility': 45.0},
          riskManagement: 'High risk tolerance',
          minimumCapital: 50000.0,
          followers: 5000,
          rating: 3.5,
          isActive: true,
        );

        expect(riskyStrategy.winRate, lessThan(50.0));
        expect(riskyStrategy.maxDrawdown, lessThan(-20.0));
        expect(riskyStrategy.sharpeRatio, lessThan(1.0));
      });

      test('should validate follower count consistency', () {
        final popularStrategy = TestHelper.createMockTraderStrategy();
        expect(popularStrategy.followers, greaterThan(0));
        expect(popularStrategy.rating, greaterThan(0.0));
      });
    });
  });
}