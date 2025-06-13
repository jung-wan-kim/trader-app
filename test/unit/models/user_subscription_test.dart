import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/models/user_subscription.dart';

void main() {
  group('UserSubscription Model Tests', () {
    late DateTime now;
    late UserSubscription testSubscription;

    setUp(() {
      now = DateTime.now();
      testSubscription = UserSubscription(
        id: 'sub_001',
        userId: 'user_001',
        planId: 'plan_pro',
        planName: 'Pro Trader',
        tier: SubscriptionTier.pro,
        price: 49.99,
        currency: 'USD',
        startDate: now.subtract(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 15)),
        isActive: true,
        autoRenew: true,
        features: [
          'Real-time data',
          'Advanced analytics',
          'Priority support',
          'API access',
        ],
        paymentMethod: PaymentMethod(
          id: 'pm_001',
          type: 'CARD',
          last4: '4242',
          brand: 'Visa',
          expiryDate: DateTime(2025, 12, 31),
        ),
        history: [
          SubscriptionHistory(
            id: 'pay_001',
            action: 'CREATED',
            timestamp: now.subtract(const Duration(days: 15)),
            description: 'Monthly subscription',
            amount: 49.99,
          ),
        ],
      );
    });

    group('Constructor and Properties', () {
      test('should create subscription with all properties', () {
        expect(testSubscription.id, equals('sub_001'));
        expect(testSubscription.userId, equals('user_001'));
        expect(testSubscription.planId, equals('plan_pro'));
        expect(testSubscription.planName, equals('Pro Trader'));
        expect(testSubscription.tier, equals(SubscriptionTier.pro));
        expect(testSubscription.price, equals(49.99));
        expect(testSubscription.currency, equals('USD'));
        expect(testSubscription.isActive, isTrue);
        expect(testSubscription.autoRenew, isTrue);
        expect(testSubscription.features.length, equals(4));
        expect(testSubscription.paymentMethod, isNotNull);
        expect(testSubscription.history.length, equals(1));
      });

      test('should handle null payment method', () {
        final subscription = UserSubscription(
          id: 'sub_002',
          userId: 'user_002',
          planId: 'plan_free',
          planName: 'Free',
          tier: SubscriptionTier.free,
          price: 0,
          currency: 'USD',
          startDate: now,
          isActive: true,
          autoRenew: false,
          features: ['Basic features'],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(subscription.paymentMethod, isNull);
        expect(subscription.tier, equals(SubscriptionTier.free));
        expect(subscription.price, equals(0));
      });

      test('should handle null end date for lifetime subscriptions', () {
        final lifetimeSubscription = UserSubscription(
          id: 'sub_lifetime',
          userId: 'user_lifetime',
          planId: 'plan_lifetime',
          planName: 'Lifetime Access',
          tier: SubscriptionTier.premium,
          price: 999.99,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 365)),
          endDate: null,
          isActive: true,
          autoRenew: false,
          features: ['All features', 'Lifetime updates'],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(lifetimeSubscription.endDate, isNull);
        expect(lifetimeSubscription.isExpired, isFalse);
      });
    });

    group('Calculated Properties', () {
      test('should calculate days remaining correctly', () {
        final daysRemaining = testSubscription.daysRemaining;
        expect(daysRemaining, anyOf(14, 15)); // Allow for date calculation differences
      });

      test('should return -1 days remaining when no end date', () {
        final subscription = UserSubscription(
          id: 'sub_003',
          userId: 'user_003',
          planId: 'plan_lifetime',
          planName: 'Lifetime',
          tier: SubscriptionTier.premium,
          price: 999.99,
          currency: 'USD',
          startDate: now,
          endDate: null,
          isActive: true,
          autoRenew: false,
          features: [],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(subscription.daysRemaining, equals(-1));
      });

      test('should identify expired subscriptions', () {
        final expiredSubscription = UserSubscription(
          id: 'sub_expired',
          userId: 'user_expired',
          planId: 'plan_basic',
          planName: 'Basic',
          tier: SubscriptionTier.basic,
          price: 19.99,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 60)),
          endDate: now.subtract(const Duration(days: 30)),
          isActive: false,
          autoRenew: false,
          features: [],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(expiredSubscription.isExpired, isTrue);
        expect(testSubscription.isExpired, isFalse);
      });

      test('should handle subscription about to expire', () {
        final expiringSubscription = UserSubscription(
          id: 'sub_expiring',
          userId: 'user_expiring',
          planId: 'plan_pro',
          planName: 'Pro',
          tier: SubscriptionTier.pro,
          price: 49.99,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 29)),
          endDate: now.add(const Duration(days: 1)),
          isActive: true,
          autoRenew: false,
          features: [],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(expiringSubscription.daysRemaining, equals(1));
        expect(expiringSubscription.isExpired, isFalse);
      });
    });

    group('SubscriptionTier Enum', () {
      test('should have correct tier values', () {
        expect(SubscriptionTier.values.length, equals(4));
        expect(SubscriptionTier.values, contains(SubscriptionTier.free));
        expect(SubscriptionTier.values, contains(SubscriptionTier.basic));
        expect(SubscriptionTier.values, contains(SubscriptionTier.pro));
        expect(SubscriptionTier.values, contains(SubscriptionTier.premium));
      });

      test('should maintain tier hierarchy', () {
        expect(SubscriptionTier.free.index, lessThan(SubscriptionTier.basic.index));
        expect(SubscriptionTier.basic.index, lessThan(SubscriptionTier.pro.index));
        expect(SubscriptionTier.pro.index, lessThan(SubscriptionTier.premium.index));
      });
    });

    group('PaymentMethod Model', () {
      test('should create payment method with all properties', () {
        final paymentMethod = testSubscription.paymentMethod;
        expect(paymentMethod.id, equals('pm_001'));
        expect(paymentMethod.type, equals('CARD'));
        expect(paymentMethod.last4, equals('4242'));
        expect(paymentMethod.brand, equals('Visa'));
        expect(paymentMethod.expiryDate, equals(DateTime(2025, 12, 31)));
      });

      test('should handle different payment types', () {
        final bankPayment = PaymentMethod(
          id: 'pm_bank',
          type: 'BANK',
          last4: '6789',
          brand: 'Chase',
        );

        expect(bankPayment.type, equals('BANK'));
        expect(bankPayment.expiryDate, isNull);
      });

      test('should serialize payment method to JSON', () {
        final paymentMethod = PaymentMethod(
          id: 'pm_test',
          type: 'CARD',
          last4: '1234',
          brand: 'Mastercard',
          expiryDate: DateTime(2024, 6, 30),
        );

        final json = paymentMethod.toJson();
        expect(json['id'], equals('pm_test'));
        expect(json['type'], equals('CARD'));
        expect(json['last4'], equals('1234'));
        expect(json['brand'], equals('Mastercard'));
        expect(json['expiryDate'], equals(DateTime(2024, 6, 30).toIso8601String()));
      });

      test('should deserialize payment method from JSON', () {
        final json = {
          'id': 'pm_json',
          'type': 'CARD',
          'last4': '5678',
          'brand': 'Amex',
          'expiryDate': DateTime(2026, 3, 31).toIso8601String(),
        };

        final paymentMethod = PaymentMethod.fromJson(json);
        expect(paymentMethod.id, equals('pm_json'));
        expect(paymentMethod.type, equals('CARD'));
        expect(paymentMethod.last4, equals('5678'));
        expect(paymentMethod.brand, equals('Amex'));
        expect(paymentMethod.expiryDate, equals(DateTime(2026, 3, 31)));
      });
    });

    group('SubscriptionHistory Model', () {
      test('should create subscription history with all properties', () {
        final payment = testSubscription.history.first;
        expect(payment.id, equals('pay_001'));
        expect(payment.amount, equals(49.99));
        expect(payment.action, equals('CREATED'));
        expect(payment.description, equals('Monthly subscription'));
      });

      test('should handle different history actions', () {
        final cancelledHistory = SubscriptionHistory(
          id: 'hist_cancelled',
          action: 'CANCELLED',
          timestamp: now,
          description: 'Subscription cancelled',
          amount: 49.99,
        );

        expect(cancelledHistory.action, equals('CANCELLED'));
        expect(cancelledHistory.description, equals('Subscription cancelled'));
      });

      test('should serialize subscription history to JSON', () {
        final history = SubscriptionHistory(
          id: 'hist_test',
          action: 'RENEWED',
          timestamp: now,
          description: 'Annual subscription renewed',
          amount: 99.99,
        );

        final json = history.toJson();
        expect(json['id'], equals('hist_test'));
        expect(json['amount'], equals(99.99));
        expect(json['action'], equals('RENEWED'));
        expect(json['description'], equals('Annual subscription renewed'));
      });
    });

    group('JSON Serialization', () {
      test('should serialize subscription to JSON', () {
        final json = testSubscription.toJson();

        expect(json['id'], equals('sub_001'));
        expect(json['userId'], equals('user_001'));
        expect(json['planId'], equals('plan_pro'));
        expect(json['planName'], equals('Pro Trader'));
        expect(json['tier'], equals('pro'));
        expect(json['price'], equals(49.99));
        expect(json['currency'], equals('USD'));
        expect(json['isActive'], isTrue);
        expect(json['autoRenew'], isTrue);
        expect(json['features'], isA<List>());
        expect(json['features'].length, equals(4));
        expect(json['paymentMethod'], isNotNull);
        expect(json['history'], isA<List>());
        expect(json['history'].length, equals(1));
      });

      test('should deserialize subscription from JSON', () {
        final json = {
          'id': 'sub_json',
          'userId': 'user_json',
          'planId': 'plan_basic',
          'planName': 'Basic Plan',
          'tier': 'basic',
          'price': 19.99,
          'currency': 'GBP',
          'startDate': now.toIso8601String(),
          'endDate': now.add(const Duration(days: 30)).toIso8601String(),
          'isActive': true,
          'autoRenew': true,
          'features': ['Feature 1', 'Feature 2'],
          'paymentMethod': {
            'id': 'pm_json',
            'type': 'CARD',
            'last4': '9999',
            'brand': 'Visa',
          },
          'history': [],
        };

        final subscription = UserSubscription.fromJson(json);
        expect(subscription.id, equals('sub_json'));
        expect(subscription.userId, equals('user_json'));
        expect(subscription.tier, equals(SubscriptionTier.basic));
        expect(subscription.price, equals(19.99));
        expect(subscription.currency, equals('GBP'));
        expect(subscription.features.length, equals(2));
        expect(subscription.paymentMethod, isNotNull);
        expect(subscription.history, isEmpty);
      });
    });

    group('Business Logic', () {
      test('should identify trial subscriptions', () {
        final trialSubscription = UserSubscription(
          id: 'sub_trial',
          userId: 'user_trial',
          planId: 'plan_trial',
          planName: 'Pro Trial',
          tier: SubscriptionTier.pro,
          price: 0,
          currency: 'USD',
          startDate: now,
          endDate: now.add(const Duration(days: 7)),
          isActive: true,
          autoRenew: false,
          features: ['All Pro features'],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(trialSubscription.price, equals(0));
        expect(trialSubscription.daysRemaining, greaterThanOrEqualTo(6));
      });

      test('should handle subscription upgrades', () {
        // Simulate upgrade from basic to pro
        final basicSubscription = UserSubscription(
          id: 'sub_basic',
          userId: 'user_upgrade',
          planId: 'plan_basic',
          planName: 'Basic',
          tier: SubscriptionTier.basic,
          price: 19.99,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 15)),
          endDate: now.add(const Duration(days: 15)),
          isActive: false, // Cancelled for upgrade
          autoRenew: false,
          features: ['Basic features'],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        final proSubscription = UserSubscription(
          id: 'sub_pro_upgraded',
          userId: 'user_upgrade',
          planId: 'plan_pro',
          planName: 'Pro',
          tier: SubscriptionTier.pro,
          price: 49.99,
          currency: 'USD',
          startDate: now,
          endDate: now.add(const Duration(days: 30)),
          isActive: true,
          autoRenew: true,
          features: ['All Pro features'],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [
            SubscriptionHistory(
              id: 'hist_upgrade',
              action: 'UPGRADED',
              timestamp: now,
              description: 'Upgrade from Basic to Pro',
              amount: 49.99,
            ),
          ],
        );

        expect(basicSubscription.isActive, isFalse);
        expect(proSubscription.isActive, isTrue);
        expect(proSubscription.tier.index, greaterThan(basicSubscription.tier.index));
      });

      test('should calculate prorated amounts', () {
        // If subscription has 15 days remaining out of 30
        final remainingDays = testSubscription.daysRemaining ?? 0;
        final totalDays = 30;
        final proratedAmount = (testSubscription.price * remainingDays / totalDays);
        
        expect(proratedAmount, closeTo(24.995, 0.01)); // About half of 49.99
      });
    });

    group('Edge Cases', () {
      test('should handle zero price subscriptions', () {
        final freeSubscription = UserSubscription(
          id: 'sub_free',
          userId: 'user_free',
          planId: 'plan_free',
          planName: 'Free Forever',
          tier: SubscriptionTier.free,
          price: 0,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 365)),
          endDate: null,
          isActive: true,
          autoRenew: false,
          features: ['Limited features'],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(freeSubscription.price, equals(0));
        expect(freeSubscription.endDate, isNull);
        expect(freeSubscription.isExpired, isFalse);
      });

      test('should handle very long subscription periods', () {
        final longSubscription = UserSubscription(
          id: 'sub_long',
          userId: 'user_long',
          planId: 'plan_annual',
          planName: 'Annual Pro',
          tier: SubscriptionTier.pro,
          price: 499.99,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 180)),
          endDate: now.add(const Duration(days: 185)),
          isActive: true,
          autoRenew: true,
          features: [],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: [],
        );

        expect(longSubscription.daysRemaining, equals(185));
      });

      test('should handle subscriptions with many payment history entries', () {
        final history = List.generate(100, (i) => SubscriptionHistory(
          id: 'hist_$i',
          action: i % 10 == 0 ? 'CANCELLED' : 'RENEWED',
          timestamp: now.subtract(Duration(days: i * 30)),
          description: 'Monthly payment #$i',
          amount: 49.99,
        ));

        final subscription = UserSubscription(
          id: 'sub_history',
          userId: 'user_history',
          planId: 'plan_pro',
          planName: 'Pro',
          tier: SubscriptionTier.pro,
          price: 49.99,
          currency: 'USD',
          startDate: now.subtract(const Duration(days: 3000)),
          endDate: now.add(const Duration(days: 30)),
          isActive: true,
          autoRenew: true,
          features: [],
          paymentMethod: PaymentMethod(
            id: 'pm_free',
            type: 'NONE',
            last4: '0000',
          ),
          history: history,
        );

        expect(subscription.history.length, equals(100));
        expect(subscription.history.where((p) => p.action == 'CANCELLED').length, equals(10));
      });
    });
  });
}