import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('StockRecommendation Model Tests', () {
    late StockRecommendation mockRecommendation;
    late Map<String, dynamic> validJson;

    setUp(() {
      mockRecommendation = TestHelper.createMockStockRecommendation();
      validJson = TestHelper.mockStockRecommendationJson;
    });

    group('Constructor', () {
      test('should create instance with all required fields', () {
        expect(mockRecommendation.id, 'test-id-1');
        expect(mockRecommendation.stockCode, 'AAPL');
        expect(mockRecommendation.stockName, 'Apple Inc.');
        expect(mockRecommendation.traderName, 'Jesse Livermore');
        expect(mockRecommendation.action, 'BUY');
        expect(mockRecommendation.targetPrice, 200.0);
        expect(mockRecommendation.currentPrice, 150.0);
        expect(mockRecommendation.stopLoss, 140.0);
        expect(mockRecommendation.likes, 100);
        expect(mockRecommendation.followers, 5000);
      });

      test('should set default values for optional fields', () {
        final recommendation = StockRecommendation(
          id: 'test',
          stockCode: 'TEST',
          stockName: 'Test Stock',
          traderName: 'Test Trader',
          traderId: 'trader-test',
          action: 'BUY',
          targetPrice: 100.0,
          currentPrice: 90.0,
          stopLoss: 85.0,
          takeProfit: 95.0,
          reasoning: 'Test reason',
          recommendedAt: DateTime.now(),
          timeframe: 'SHORT',
          confidence: 70.0,
          riskLevel: 'LOW',
        );

        expect(recommendation.likes, 0);
        expect(recommendation.followers, 0);
        expect(recommendation.technicalIndicators, isNull);
        expect(recommendation.expectedReturn, isNull);
      });
    });

    group('Computed Properties', () {
      test('potentialProfit should calculate correct percentage', () {
        // Target: 200, Current: 150 => (200-150)/150 * 100 = 33.33%
        expect(mockRecommendation.potentialProfit, closeTo(33.33, 0.01));
      });

      test('potentialProfit should handle zero current price', () {
        final recommendation = TestHelper.createMockStockRecommendation(
          currentPrice: 0.0,
          targetPrice: 100.0,
        );
        expect(recommendation.potentialProfit.isInfinite, isTrue);
      });

      test('riskRewardRatio should calculate correctly', () {
        // (Target-Current)/(Current-StopLoss) = (200-150)/(150-140) = 50/10 = 5.0
        expect(mockRecommendation.riskRewardRatio, 5.0);
      });

      test('riskRewardRatio should handle division by zero', () {
        final recommendation = TestHelper.createMockStockRecommendation(
          currentPrice: 150.0,
          stopLoss: 150.0,
          targetPrice: 200.0,
        );
        expect(recommendation.riskRewardRatio.isInfinite, isTrue);
      });

      test('isBullish should return true for BUY action', () {
        expect(mockRecommendation.isBullish, isTrue);
        expect(mockRecommendation.isBearish, isFalse);
      });

      test('isBearish should return true for SELL action', () {
        final sellRecommendation = TestHelper.createMockStockRecommendation(
          action: 'SELL',
        );
        expect(sellRecommendation.isBearish, isTrue);
        expect(sellRecommendation.isBullish, isFalse);
      });

      test('should handle HOLD action', () {
        final holdRecommendation = TestHelper.createMockStockRecommendation(
          action: 'HOLD',
        );
        expect(holdRecommendation.isBullish, isFalse);
        expect(holdRecommendation.isBearish, isFalse);
      });
    });

    group('JSON Serialization', () {
      test('fromJson should create correct instance from valid JSON', () {
        final recommendation = StockRecommendation.fromJson(validJson);

        expect(recommendation.id, validJson['id']);
        expect(recommendation.stockCode, validJson['stockCode']);
        expect(recommendation.stockName, validJson['stockName']);
        expect(recommendation.traderName, validJson['traderName']);
        expect(recommendation.action, validJson['action']);
        expect(recommendation.targetPrice, validJson['targetPrice']);
        expect(recommendation.currentPrice, validJson['currentPrice']);
        expect(recommendation.stopLoss, validJson['stopLoss']);
        expect(recommendation.confidence, validJson['confidence']);
        expect(recommendation.likes, validJson['likes']);
        expect(recommendation.followers, validJson['followers']);
      });

      test('fromJson should parse DateTime correctly', () {
        final recommendation = StockRecommendation.fromJson(validJson);
        expect(recommendation.recommendedAt, DateTime.parse(validJson['recommendedAt']));
      });

      test('fromJson should handle null optional fields', () {
        final jsonWithNulls = Map<String, dynamic>.from(validJson);
        jsonWithNulls['technicalIndicators'] = null;
        jsonWithNulls['expectedReturn'] = null;
        jsonWithNulls['likes'] = null;
        jsonWithNulls['followers'] = null;

        final recommendation = StockRecommendation.fromJson(jsonWithNulls);
        expect(recommendation.technicalIndicators, isNull);
        expect(recommendation.expectedReturn, isNull);
        expect(recommendation.likes, 0);
        expect(recommendation.followers, 0);
      });

      test('fromJson should convert numeric fields to double', () {
        final jsonWithInts = Map<String, dynamic>.from(validJson);
        jsonWithInts['targetPrice'] = 200; // int instead of double
        jsonWithInts['currentPrice'] = 150;
        jsonWithInts['confidence'] = 85;

        final recommendation = StockRecommendation.fromJson(jsonWithInts);
        expect(recommendation.targetPrice, isA<double>());
        expect(recommendation.currentPrice, isA<double>());
        expect(recommendation.confidence, isA<double>());
      });

      test('toJson should create correct JSON representation', () {
        final json = mockRecommendation.toJson();

        expect(json['id'], mockRecommendation.id);
        expect(json['stockCode'], mockRecommendation.stockCode);
        expect(json['action'], mockRecommendation.action);
        expect(json['targetPrice'], mockRecommendation.targetPrice);
        expect(json['currentPrice'], mockRecommendation.currentPrice);
        expect(json['recommendedAt'], mockRecommendation.recommendedAt.toIso8601String());
        expect(json['confidence'], mockRecommendation.confidence);
        expect(json['likes'], mockRecommendation.likes);
      });

      test('toJson should include null values', () {
        final recommendation = StockRecommendation(
          id: 'test',
          stockCode: 'TEST',
          stockName: 'Test',
          traderName: 'Trader',
          traderId: 'trader-id',
          action: 'BUY',
          targetPrice: 100.0,
          currentPrice: 90.0,
          stopLoss: 85.0,
          takeProfit: 95.0,
          reasoning: 'Test',
          recommendedAt: DateTime.now(),
          timeframe: 'SHORT',
          confidence: 70.0,
          riskLevel: 'LOW',
          technicalIndicators: null,
          expectedReturn: null,
        );

        final json = recommendation.toJson();
        expect(json['technicalIndicators'], isNull);
        expect(json['expectedReturn'], isNull);
      });

      test('JSON round-trip should preserve data', () {
        final json = mockRecommendation.toJson();
        final reconstructed = StockRecommendation.fromJson(json);

        expect(reconstructed.id, mockRecommendation.id);
        expect(reconstructed.stockCode, mockRecommendation.stockCode);
        expect(reconstructed.action, mockRecommendation.action);
        expect(reconstructed.targetPrice, mockRecommendation.targetPrice);
        expect(reconstructed.currentPrice, mockRecommendation.currentPrice);
        expect(reconstructed.confidence, mockRecommendation.confidence);
        expect(reconstructed.recommendedAt, mockRecommendation.recommendedAt);
      });
    });

    group('Edge Cases', () {
      test('should handle negative prices', () {
        final recommendation = TestHelper.createMockStockRecommendation(
          currentPrice: -10.0,
          targetPrice: -5.0,
          stopLoss: -15.0,
        );

        expect(recommendation.currentPrice, -10.0);
        expect(recommendation.targetPrice, -5.0);
        expect(recommendation.stopLoss, -15.0);
        expect(recommendation.potentialProfit, closeTo(-50.0, 0.01)); // (-5-(-10))/(-10) * 100 = 5/(-10) * 100 = -50
      });

      test('should handle zero confidence', () {
        final recommendation = TestHelper.createMockStockRecommendation();
        final json = recommendation.toJson();
        json['confidence'] = 0.0;

        final parsed = StockRecommendation.fromJson(json);
        expect(parsed.confidence, 0.0);
      });

      test('should handle large numbers', () {
        final recommendation = TestHelper.createMockStockRecommendation(
          currentPrice: 1000000.0,
          targetPrice: 2000000.0,
        );

        expect(recommendation.potentialProfit, 100.0);
      });

      test('should handle special double values', () {
        expect(() => TestHelper.createMockStockRecommendation(
          currentPrice: double.infinity,
        ), returnsNormally);

        expect(() => TestHelper.createMockStockRecommendation(
          currentPrice: double.nan,
        ), returnsNormally);
      });
    });

    group('Error Handling', () {
      test('fromJson should throw when required fields are missing', () {
        final incompleteJson = <String, dynamic>{
          'id': 'test',
          // missing required fields
        };

        expect(() => StockRecommendation.fromJson(incompleteJson), throwsA(isA<Error>()));
      });

      test('fromJson should throw on invalid DateTime format', () {
        final invalidJson = Map<String, dynamic>.from(validJson);
        invalidJson['recommendedAt'] = 'invalid-date';

        expect(() => StockRecommendation.fromJson(invalidJson), throwsA(isA<FormatException>()));
      });

      test('fromJson should throw on null required fields', () {
        final nullJson = Map<String, dynamic>.from(validJson);
        nullJson['id'] = null;

        expect(() => StockRecommendation.fromJson(nullJson), throwsA(isA<TypeError>()));
      });
    });

    group('Business Logic Validation', () {
      test('should identify profitable recommendations', () {
        final profitable = TestHelper.createMockStockRecommendation(
          currentPrice: 100.0,
          targetPrice: 120.0,
        );
        expect(profitable.potentialProfit, greaterThan(0));
      });

      test('should identify loss recommendations', () {
        final loss = TestHelper.createMockStockRecommendation(
          currentPrice: 100.0,
          targetPrice: 80.0,
        );
        expect(loss.potentialProfit, lessThan(0));
      });

      test('should validate risk-reward ratio logic', () {
        final goodRatio = TestHelper.createMockStockRecommendation(
          currentPrice: 100.0,
          targetPrice: 120.0,
          stopLoss: 95.0,
        );
        // (120-100)/(100-95) = 20/5 = 4.0
        expect(goodRatio.riskRewardRatio, 4.0);
        expect(goodRatio.riskRewardRatio, greaterThan(2.0)); // Good risk-reward
      });

      test('should handle poor risk-reward scenarios', () {
        final poorRatio = TestHelper.createMockStockRecommendation(
          currentPrice: 100.0,
          targetPrice: 105.0,
          stopLoss: 80.0,
        );
        // (105-100)/(100-80) = 5/20 = 0.25
        expect(poorRatio.riskRewardRatio, 0.25);
        expect(poorRatio.riskRewardRatio, lessThan(1.0)); // Poor risk-reward
      });
    });
  });
}