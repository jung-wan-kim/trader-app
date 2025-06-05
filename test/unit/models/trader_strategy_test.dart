import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone_flutter/models/trader_strategy.dart';

void main() {
  group('TraderStrategy Model Tests', () {
    late Map<String, dynamic> validJson;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime.now();
      validJson = {
        'id': 'strategy_001',
        'traderId': 'trader_001',
        'traderName': 'John Doe',
        'strategyName': 'Momentum Trading',
        'description': 'High frequency momentum trading strategy',
        'tradingStyle': 'DAY_TRADING',
        'winRate': 65.5,
        'averageReturn': 2.3,
        'maxDrawdown': 15.2,
        'sharpeRatio': 1.8,
        'totalTrades': 100,
        'winningTrades': 65,
        'losingTrades': 35,
        'createdAt': testDate.toIso8601String(),
        'lastUpdated': testDate.toIso8601String(),
        'preferredAssets': ['AAPL', 'GOOGL', 'MSFT'],
        'performanceMetrics': {
          'monthlyReturn': 5.2,
          'yearlyReturn': 48.5,
          'volatility': 12.3,
        },
        'riskManagement': 'Stop loss at 2%, Take profit at 5%',
        'minimumCapital': 10000.0,
        'followers': 1250,
        'rating': 4.5,
        'isActive': true,
        'profileImageUrl': 'https://example.com/profile.jpg',
      };
    });

    test('should create TraderStrategy from valid JSON', () {
      final strategy = TraderStrategy.fromJson(validJson);

      expect(strategy.id, equals('strategy_001'));
      expect(strategy.traderId, equals('trader_001'));
      expect(strategy.traderName, equals('John Doe'));
      expect(strategy.strategyName, equals('Momentum Trading'));
      expect(strategy.winRate, equals(65.5));
      expect(strategy.totalTrades, equals(100));
      expect(strategy.preferredAssets.length, equals(3));
      expect(strategy.isActive, isTrue);
    });

    test('should calculate lossRate correctly', () {
      final strategy = TraderStrategy.fromJson(validJson);
      
      expect(strategy.lossRate, equals(34.5));
    });

    test('should calculate profitFactor correctly', () {
      final strategy = TraderStrategy.fromJson(validJson);
      
      // (65 * 2.3) / (35 * 2.3) = 149.5 / 80.5 = 1.857...
      expect(strategy.profitFactor, closeTo(1.857, 0.001));
    });

    test('should handle profitFactor with zero trades', () {
      validJson['winningTrades'] = 0;
      validJson['losingTrades'] = 0;
      final strategy = TraderStrategy.fromJson(validJson);
      
      expect(strategy.profitFactor, equals(0));
    });

    test('should convert to JSON correctly', () {
      final strategy = TraderStrategy.fromJson(validJson);
      final json = strategy.toJson();

      expect(json['id'], equals('strategy_001'));
      expect(json['winRate'], equals(65.5));
      expect(json['preferredAssets'], isA<List>());
      expect(json['performanceMetrics'], isA<Map>());
      expect(json['createdAt'], isA<String>());
    });

    test('should handle null profileImageUrl', () {
      validJson['profileImageUrl'] = null;
      final strategy = TraderStrategy.fromJson(validJson);

      expect(strategy.profileImageUrl, isNull);
    });

    test('should validate trading styles', () {
      final tradingStyles = ['SCALPING', 'DAY_TRADING', 'SWING_TRADING', 'POSITION_TRADING'];
      
      for (final style in tradingStyles) {
        validJson['tradingStyle'] = style;
        final strategy = TraderStrategy.fromJson(validJson);
        expect(strategy.tradingStyle, equals(style));
      }
    });

    test('should handle edge case values', () {
      validJson['winRate'] = 100.0;
      validJson['maxDrawdown'] = 0.0;
      validJson['rating'] = 5.0;
      validJson['followers'] = 0;
      
      final strategy = TraderStrategy.fromJson(validJson);
      
      expect(strategy.winRate, equals(100.0));
      expect(strategy.lossRate, equals(0.0));
      expect(strategy.maxDrawdown, equals(0.0));
      expect(strategy.rating, equals(5.0));
      expect(strategy.followers, equals(0));
    });

    test('should handle negative returns correctly', () {
      validJson['averageReturn'] = -1.5;
      validJson['winningTrades'] = 40;
      validJson['losingTrades'] = 60;
      
      final strategy = TraderStrategy.fromJson(validJson);
      
      expect(strategy.averageReturn, equals(-1.5));
      expect(strategy.profitFactor, greaterThan(0));
    });
  });
}