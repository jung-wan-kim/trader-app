import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone_flutter/models/user_subscription.dart';

void main() {
  group('UserSubscription Model Tests', () {
    late Map<String, dynamic> validJson;
    late DateTime testDate;
    late DateTime futureDate;
    late DateTime pastDate;

    setUp(() {
      testDate = DateTime.now();
      futureDate = testDate.add(const Duration(days: 30));
      pastDate = testDate.subtract(const Duration(days: 30));

      validJson = {
        'id': 'sub_001',
        'userId': 'user_001',
        'planId': 'plan_pro',
        'planName': 'Pro Trader',
        'tier': 'pro',
        'price': 49.99,
        'currency': 'USD',
        'startDate': testDate.toIso8601String(),
        'endDate': futureDate.toIso8601String(),
        'nextBillingDate': futureDate.toIso8601String(),
        'isActive': true,
        'autoRenew': true,
        'features': ['실시간 데이터', '무제한 거래', 'AI 분석'],
        'limits': {
          'maxTrades': 1000,
          'maxStrategies': 10,
          'dataDelay': 0,
        },
        'paymentMethod': {
          'id': 'pm_001',
          'type': 'CARD',
          'last4': '4242',
          'brand': 'Visa',
          'expiryDate': futureDate.toIso8601String(),
        },
        'discountCode': 'TRADER20',
        'discountAmount': 10.0,
        'history': [
          {
            'id': 'hist_001',
            'action': 'CREATED',
            'timestamp': testDate.toIso8601String(),
            'description': 'Subscription created',
            'amount': 49.99,
          },
        ],
      };
    });

    test('should create UserSubscription from valid JSON', () {
      final subscription = UserSubscription.fromJson(validJson);

      expect(subscription.id, equals('sub_001'));
      expect(subscription.userId, equals('user_001'));
      expect(subscription.planName, equals('Pro Trader'));
      expect(subscription.tier, equals(SubscriptionTier.pro));
      expect(subscription.price, equals(49.99));
      expect(subscription.isActive, isTrue);
      expect(subscription.features.length, equals(3));
      expect(subscription.history.length, equals(1));
    });

    test('should calculate finalPrice correctly with discount', () {
      final subscription = UserSubscription.fromJson(validJson);
      
      expect(subscription.finalPrice, equals(39.99));
    });

    test('should calculate finalPrice correctly without discount', () {
      validJson['discountAmount'] = null;
      final subscription = UserSubscription.fromJson(validJson);
      
      expect(subscription.finalPrice, equals(49.99));
    });

    test('should determine isExpired correctly', () {
      // Test active subscription
      final activeSubscription = UserSubscription.fromJson(validJson);
      expect(activeSubscription.isExpired, isFalse);

      // Test expired subscription
      validJson['endDate'] = pastDate.toIso8601String();
      final expiredSubscription = UserSubscription.fromJson(validJson);
      expect(expiredSubscription.isExpired, isTrue);

      // Test subscription without end date
      validJson['endDate'] = null;
      final noEndDateSubscription = UserSubscription.fromJson(validJson);
      expect(noEndDateSubscription.isExpired, isFalse);
    });

    test('should calculate daysRemaining correctly', () {
      final subscription = UserSubscription.fromJson(validJson);
      
      expect(subscription.daysRemaining, closeTo(30, 1));

      // Test without end date
      validJson['endDate'] = null;
      final noEndDateSubscription = UserSubscription.fromJson(validJson);
      expect(noEndDateSubscription.daysRemaining, equals(-1));
    });

    test('should handle all subscription tiers', () {
      final tiers = ['free', 'basic', 'pro', 'premium', 'enterprise'];
      
      for (final tier in tiers) {
        validJson['tier'] = tier;
        final subscription = UserSubscription.fromJson(validJson);
        expect(subscription.tier.name, equals(tier));
      }
    });

    test('should handle invalid tier gracefully', () {
      validJson['tier'] = 'invalid_tier';
      final subscription = UserSubscription.fromJson(validJson);
      
      expect(subscription.tier, equals(SubscriptionTier.basic));
    });

    test('should convert to JSON correctly', () {
      final subscription = UserSubscription.fromJson(validJson);
      final json = subscription.toJson();

      expect(json['id'], equals('sub_001'));
      expect(json['tier'], equals('pro'));
      expect(json['features'], isA<List>());
      expect(json['paymentMethod'], isA<Map>());
      expect(json['history'], isA<List>());
    });

    test('should handle null optional fields', () {
      validJson['endDate'] = null;
      validJson['nextBillingDate'] = null;
      validJson['limits'] = null;
      validJson['discountCode'] = null;
      validJson['discountAmount'] = null;
      
      final subscription = UserSubscription.fromJson(validJson);

      expect(subscription.endDate, isNull);
      expect(subscription.nextBillingDate, isNull);
      expect(subscription.limits, isNull);
      expect(subscription.discountCode, isNull);
      expect(subscription.discountAmount, isNull);
    });
  });

  group('PaymentMethod Model Tests', () {
    test('should create PaymentMethod from JSON', () {
      final json = {
        'id': 'pm_001',
        'type': 'CARD',
        'last4': '4242',
        'brand': 'Visa',
        'expiryDate': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
      };

      final paymentMethod = PaymentMethod.fromJson(json);

      expect(paymentMethod.id, equals('pm_001'));
      expect(paymentMethod.type, equals('CARD'));
      expect(paymentMethod.last4, equals('4242'));
      expect(paymentMethod.brand, equals('Visa'));
      expect(paymentMethod.expiryDate, isNotNull);
    });

    test('should handle null optional fields in PaymentMethod', () {
      final json = {
        'id': 'pm_002',
        'type': 'BANK',
        'last4': '1234',
        'brand': null,
        'expiryDate': null,
      };

      final paymentMethod = PaymentMethod.fromJson(json);

      expect(paymentMethod.brand, isNull);
      expect(paymentMethod.expiryDate, isNull);
    });

    test('should convert PaymentMethod to JSON', () {
      final paymentMethod = PaymentMethod(
        id: 'pm_001',
        type: 'CARD',
        last4: '4242',
        brand: 'Visa',
        expiryDate: DateTime.now(),
      );

      final json = paymentMethod.toJson();

      expect(json['id'], equals('pm_001'));
      expect(json['type'], equals('CARD'));
      expect(json['expiryDate'], isA<String>());
    });
  });

  group('SubscriptionHistory Model Tests', () {
    test('should create SubscriptionHistory from JSON', () {
      final json = {
        'id': 'hist_001',
        'action': 'CREATED',
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'Subscription created',
        'amount': 49.99,
      };

      final history = SubscriptionHistory.fromJson(json);

      expect(history.id, equals('hist_001'));
      expect(history.action, equals('CREATED'));
      expect(history.description, equals('Subscription created'));
      expect(history.amount, equals(49.99));
    });

    test('should handle null optional fields in SubscriptionHistory', () {
      final json = {
        'id': 'hist_002',
        'action': 'CANCELLED',
        'timestamp': DateTime.now().toIso8601String(),
        'description': null,
        'amount': null,
      };

      final history = SubscriptionHistory.fromJson(json);

      expect(history.description, isNull);
      expect(history.amount, isNull);
    });

    test('should validate action types', () {
      final actions = ['CREATED', 'RENEWED', 'CANCELLED', 'UPGRADED', 'DOWNGRADED'];
      
      for (final action in actions) {
        final json = {
          'id': 'hist_test',
          'action': action,
          'timestamp': DateTime.now().toIso8601String(),
        };
        
        final history = SubscriptionHistory.fromJson(json);
        expect(history.action, equals(action));
      }
    });
  });
}