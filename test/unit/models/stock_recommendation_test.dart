import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone_flutter/models/stock_recommendation.dart';

void main() {
  group('StockRecommendation Model Tests', () {
    late Map<String, dynamic> validJson;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime.now();
      validJson = {
        'id': 'rec_001',
        'stockCode': 'AAPL',
        'stockName': 'Apple Inc.',
        'traderName': 'Jane Smith',
        'traderId': 'trader_002',
        'action': 'BUY',
        'targetPrice': 180.0,
        'currentPrice': 170.0,
        'stopLoss': 165.0,
        'takeProfit': 185.0,
        'reasoning': 'Strong earnings report and technical breakout',
        'recommendedAt': testDate.toIso8601String(),
        'timeframe': 'MEDIUM',
        'confidence': 85.0,
        'riskLevel': 'MEDIUM',
        'technicalIndicators': {
          'rsi': 65.5,
          'macd': 'bullish',
          'volume': 'increasing',
        },
        'expectedReturn': 5.88,
        'likes': 125,
        'followers': 3500,
      };
    });

    test('should create StockRecommendation from valid JSON', () {
      final recommendation = StockRecommendation.fromJson(validJson);

      expect(recommendation.id, equals('rec_001'));
      expect(recommendation.stockCode, equals('AAPL'));
      expect(recommendation.stockName, equals('Apple Inc.'));
      expect(recommendation.action, equals('BUY'));
      expect(recommendation.targetPrice, equals(180.0));
      expect(recommendation.currentPrice, equals(170.0));
      expect(recommendation.confidence, equals(85.0));
      expect(recommendation.likes, equals(125));
    });

    test('should calculate potentialProfit correctly', () {
      final recommendation = StockRecommendation.fromJson(validJson);
      
      // ((180 - 170) / 170) * 100 = 5.88%
      expect(recommendation.potentialProfit, closeTo(5.88, 0.01));
    });

    test('should calculate riskRewardRatio correctly', () {
      final recommendation = StockRecommendation.fromJson(validJson);
      
      // (180 - 170) / (170 - 165) = 10 / 5 = 2.0
      expect(recommendation.riskRewardRatio, equals(2.0));
    });

    test('should identify bullish and bearish correctly', () {
      final buyRecommendation = StockRecommendation.fromJson(validJson);
      expect(buyRecommendation.isBullish, isTrue);
      expect(buyRecommendation.isBearish, isFalse);

      validJson['action'] = 'SELL';
      final sellRecommendation = StockRecommendation.fromJson(validJson);
      expect(sellRecommendation.isBullish, isFalse);
      expect(sellRecommendation.isBearish, isTrue);

      validJson['action'] = 'HOLD';
      final holdRecommendation = StockRecommendation.fromJson(validJson);
      expect(holdRecommendation.isBullish, isFalse);
      expect(holdRecommendation.isBearish, isFalse);
    });

    test('should convert to JSON correctly', () {
      final recommendation = StockRecommendation.fromJson(validJson);
      final json = recommendation.toJson();

      expect(json['id'], equals('rec_001'));
      expect(json['stockCode'], equals('AAPL'));
      expect(json['targetPrice'], equals(180.0));
      expect(json['technicalIndicators'], isA<Map>());
      expect(json['recommendedAt'], isA<String>());
    });

    test('should handle null optional fields', () {
      validJson['technicalIndicators'] = null;
      validJson['expectedReturn'] = null;
      
      final recommendation = StockRecommendation.fromJson(validJson);

      expect(recommendation.technicalIndicators, isNull);
      expect(recommendation.expectedReturn, isNull);
    });

    test('should handle default values for likes and followers', () {
      validJson.remove('likes');
      validJson.remove('followers');
      
      final recommendation = StockRecommendation.fromJson(validJson);

      expect(recommendation.likes, equals(0));
      expect(recommendation.followers, equals(0));
    });

    test('should validate action types', () {
      final actions = ['BUY', 'SELL', 'HOLD'];
      
      for (final action in actions) {
        validJson['action'] = action;
        final recommendation = StockRecommendation.fromJson(validJson);
        expect(recommendation.action, equals(action));
      }
    });

    test('should validate timeframe types', () {
      final timeframes = ['SHORT', 'MEDIUM', 'LONG'];
      
      for (final timeframe in timeframes) {
        validJson['timeframe'] = timeframe;
        final recommendation = StockRecommendation.fromJson(validJson);
        expect(recommendation.timeframe, equals(timeframe));
      }
    });

    test('should validate risk levels', () {
      final riskLevels = ['LOW', 'MEDIUM', 'HIGH'];
      
      for (final risk in riskLevels) {
        validJson['riskLevel'] = risk;
        final recommendation = StockRecommendation.fromJson(validJson);
        expect(recommendation.riskLevel, equals(risk));
      }
    });

    test('should handle edge case price scenarios', () {
      // Test when current price equals target price
      validJson['currentPrice'] = 180.0;
      validJson['targetPrice'] = 180.0;
      
      final recommendation1 = StockRecommendation.fromJson(validJson);
      expect(recommendation1.potentialProfit, equals(0.0));

      // Test negative potential profit (SELL recommendation)
      validJson['action'] = 'SELL';
      validJson['currentPrice'] = 180.0;
      validJson['targetPrice'] = 170.0;
      validJson['stopLoss'] = 185.0;
      validJson['takeProfit'] = 165.0;
      
      final recommendation2 = StockRecommendation.fromJson(validJson);
      expect(recommendation2.potentialProfit, lessThan(0));
    });

    test('should handle high confidence values', () {
      validJson['confidence'] = 100.0;
      final recommendation = StockRecommendation.fromJson(validJson);
      expect(recommendation.confidence, equals(100.0));
    });

    test('should handle zero confidence values', () {
      validJson['confidence'] = 0.0;
      final recommendation = StockRecommendation.fromJson(validJson);
      expect(recommendation.confidence, equals(0.0));
    });
  });
}