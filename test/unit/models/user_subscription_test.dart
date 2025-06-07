import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/models/user_subscription.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('UserSubscription Model Tests', () {
    late UserSubscription mockSubscription;
    late Map<String, dynamic> validJson;

    setUp(() {
      mockSubscription = TestHelper.createMockUserSubscription();
      validJson = TestHelper.mockUserSubscriptionJson;
    });

    group('Constructor', () {
      test('should create instance with all required fields', () {
        expect(mockSubscription.id, 'sub-1');
        expect(mockSubscription.userId, 'user-1');
        expect(mockSubscription.planId, 'plan-pro');
        expect(mockSubscription.planName, 'Pro Plan');
        expect(mockSubscription.tier, SubscriptionTier.pro);
        expect(mockSubscription.price, 29.99);
        expect(mockSubscription.currency, 'USD');
        expect(mockSubscription.isActive, isTrue);
        expect(mockSubscription.autoRenew, isTrue);
        expect(mockSubscription.features, isA<List<String>>());
        expect(mockSubscription.paymentMethod, isA<PaymentMethod>());
        expect(mockSubscription.history, isA<List<SubscriptionHistory>>());
      });

      test('should handle optional fields as null', () {
        final subscription = UserSubscription(
          id: 'test',
          userId: 'user-test',
          planId: 'plan-basic',
          planName: 'Basic Plan',
          tier: SubscriptionTier.basic,
          price: 9.99,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: false,
          features: ['basic_feature'],
          paymentMethod: PaymentMethod(
            id: 'pm-test',
            type: 'CARD',
            last4: '1234',
          ),
          history: [],
          // Optional fields are null
          endDate: null,
          nextBillingDate: null,
          limits: null,
          discountCode: null,
          discountAmount: null,
        );

        expect(subscription.endDate, isNull);
        expect(subscription.nextBillingDate, isNull);
        expect(subscription.limits, isNull);
        expect(subscription.discountCode, isNull);
        expect(subscription.discountAmount, isNull);
      });
    });

    group('Computed Properties', () {
      test('isExpired should return false for active subscription', () {
        expect(mockSubscription.isExpired, isFalse);
      });

      test('isExpired should return true for expired subscription', () {
        final expiredSubscription = TestHelper.createMockUserSubscription(
          endDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(expiredSubscription.isExpired, isTrue);
      });

      test('isExpired should return false when endDate is null', () {
        final lifetimeSubscription = TestHelper.createMockUserSubscription(
          endDate: null,
        );
        expect(lifetimeSubscription.isExpired, isFalse);
      });

      test('daysRemaining should calculate correctly', () {
        final futureDate = DateTime.now().add(const Duration(days: 30));
        final subscription = TestHelper.createMockUserSubscription(
          endDate: futureDate,
        );
        expect(subscription.daysRemaining, closeTo(30, 1));
      });

      test('daysRemaining should return negative for expired subscription', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 5));
        final subscription = TestHelper.createMockUserSubscription(
          endDate: pastDate,
        );
        expect(subscription.daysRemaining, lessThan(0));
      });

      test('daysRemaining should return -1 when endDate is null', () {
        final subscription = UserSubscription(
          id: 'test',
          userId: 'user-test',
          planId: 'plan-basic',
          planName: 'Basic Plan',
          tier: SubscriptionTier.basic,
          price: 9.99,
          currency: 'USD',
          startDate: DateTime.now(),
          endDate: null, // No end date
          isActive: true,
          autoRenew: false,
          features: ['basic_feature'],
          paymentMethod: PaymentMethod(
            id: 'pm-test',
            type: 'CARD',
            last4: '1234',
          ),
          history: [],
        );
        expect(subscription.daysRemaining, -1);
      });

      test('finalPrice should calculate correctly without discount', () {
        expect(mockSubscription.finalPrice, 29.99);
      });

      test('finalPrice should calculate correctly with discount', () {
        final discountedSubscription = UserSubscription(
          id: 'sub-discount',
          userId: 'user-1',
          planId: 'plan-pro',
          planName: 'Pro Plan',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: true,
          features: ['feature1'],
          paymentMethod: PaymentMethod(id: 'pm-1', type: 'CARD', last4: '1234'),
          history: [],
          discountAmount: 5.00,
        );

        expect(discountedSubscription.finalPrice, 24.99);
      });

      test('finalPrice should handle null discount amount', () {
        final subscription = UserSubscription(
          id: 'sub-no-discount',
          userId: 'user-1',
          planId: 'plan-pro',
          planName: 'Pro Plan',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: true,
          features: ['feature1'],
          paymentMethod: PaymentMethod(id: 'pm-1', type: 'CARD', last4: '1234'),
          history: [],
          discountAmount: null,
        );

        expect(subscription.finalPrice, 29.99);
      });
    });

    group('JSON Serialization', () {
      test('fromJson should create correct instance from valid JSON', () {
        final subscription = UserSubscription.fromJson(validJson);

        expect(subscription.id, validJson['id']);
        expect(subscription.userId, validJson['userId']);
        expect(subscription.planId, validJson['planId']);
        expect(subscription.planName, validJson['planName']);
        expect(subscription.tier, SubscriptionTier.pro);
        expect(subscription.price, validJson['price']);
        expect(subscription.currency, validJson['currency']);
        expect(subscription.isActive, validJson['isActive']);
        expect(subscription.autoRenew, validJson['autoRenew']);
        expect(subscription.features, validJson['features']);
      });

      test('fromJson should parse DateTime fields correctly', () {
        final subscription = UserSubscription.fromJson(validJson);
        expect(subscription.startDate, DateTime.parse(validJson['startDate']));
        expect(subscription.endDate, DateTime.parse(validJson['endDate']));
        expect(subscription.nextBillingDate, DateTime.parse(validJson['nextBillingDate']));
      });

      test('fromJson should handle null DateTime fields', () {
        final jsonWithNullDates = Map<String, dynamic>.from(validJson);
        jsonWithNullDates['endDate'] = null;
        jsonWithNullDates['nextBillingDate'] = null;

        final subscription = UserSubscription.fromJson(jsonWithNullDates);
        expect(subscription.endDate, isNull);
        expect(subscription.nextBillingDate, isNull);
      });

      test('fromJson should parse SubscriptionTier enum correctly', () {
        for (SubscriptionTier tier in SubscriptionTier.values) {
          final jsonWithTier = Map<String, dynamic>.from(validJson);
          jsonWithTier['tier'] = tier.name;

          final subscription = UserSubscription.fromJson(jsonWithTier);
          expect(subscription.tier, tier);
        }
      });

      test('fromJson should default to basic tier for invalid tier', () {
        final jsonWithInvalidTier = Map<String, dynamic>.from(validJson);
        jsonWithInvalidTier['tier'] = 'invalid_tier';

        final subscription = UserSubscription.fromJson(jsonWithInvalidTier);
        expect(subscription.tier, SubscriptionTier.basic);
      });

      test('fromJson should parse PaymentMethod correctly', () {
        final subscription = UserSubscription.fromJson(validJson);
        expect(subscription.paymentMethod, isA<PaymentMethod>());
        expect(subscription.paymentMethod.id, 'pm-1');
        expect(subscription.paymentMethod.type, 'CARD');
        expect(subscription.paymentMethod.last4, '1234');
      });

      test('fromJson should parse SubscriptionHistory list correctly', () {
        final subscription = UserSubscription.fromJson(validJson);
        expect(subscription.history, isA<List<SubscriptionHistory>>());
        expect(subscription.history, hasLength(1));
        expect(subscription.history.first.action, 'CREATED');
      });

      test('fromJson should handle null optional fields', () {
        final jsonWithNulls = Map<String, dynamic>.from(validJson);
        jsonWithNulls['limits'] = null;
        jsonWithNulls['discountCode'] = null;
        jsonWithNulls['discountAmount'] = null;

        final subscription = UserSubscription.fromJson(jsonWithNulls);
        expect(subscription.limits, isNull);
        expect(subscription.discountCode, isNull);
        expect(subscription.discountAmount, isNull);
      });

      test('fromJson should convert numeric fields to double', () {
        final jsonWithInts = Map<String, dynamic>.from(validJson);
        jsonWithInts['price'] = 30; // int instead of double
        jsonWithInts['discountAmount'] = 5; // int instead of double

        final subscription = UserSubscription.fromJson(jsonWithInts);
        expect(subscription.price, isA<double>());
        expect(subscription.discountAmount, isA<double>());
      });

      test('toJson should create correct JSON representation', () {
        final json = mockSubscription.toJson();

        expect(json['id'], mockSubscription.id);
        expect(json['userId'], mockSubscription.userId);
        expect(json['tier'], mockSubscription.tier.name);
        expect(json['price'], mockSubscription.price);
        expect(json['isActive'], mockSubscription.isActive);
        expect(json['startDate'], mockSubscription.startDate.toIso8601String());
        expect(json['paymentMethod'], mockSubscription.paymentMethod.toJson());
        expect(json['history'], mockSubscription.history.map((h) => h.toJson()).toList());
      });

      test('JSON round-trip should preserve data', () {
        final json = mockSubscription.toJson();
        final reconstructed = UserSubscription.fromJson(json);

        expect(reconstructed.id, mockSubscription.id);
        expect(reconstructed.userId, mockSubscription.userId);
        expect(reconstructed.tier, mockSubscription.tier);
        expect(reconstructed.price, mockSubscription.price);
        expect(reconstructed.isActive, mockSubscription.isActive);
        expect(reconstructed.startDate, mockSubscription.startDate);
        expect(reconstructed.features, mockSubscription.features);
      });
    });

    group('SubscriptionTier Enum', () {
      test('should have all expected tiers', () {
        expect(SubscriptionTier.values, contains(SubscriptionTier.free));
        expect(SubscriptionTier.values, contains(SubscriptionTier.basic));
        expect(SubscriptionTier.values, contains(SubscriptionTier.pro));
        expect(SubscriptionTier.values, contains(SubscriptionTier.premium));
        expect(SubscriptionTier.values, contains(SubscriptionTier.enterprise));
      });

      test('should have correct enum names', () {
        expect(SubscriptionTier.free.name, 'free');
        expect(SubscriptionTier.basic.name, 'basic');
        expect(SubscriptionTier.pro.name, 'pro');
        expect(SubscriptionTier.premium.name, 'premium');
        expect(SubscriptionTier.enterprise.name, 'enterprise');
      });
    });

    group('PaymentMethod Tests', () {
      late PaymentMethod mockPaymentMethod;

      setUp(() {
        mockPaymentMethod = PaymentMethod(
          id: 'pm-test',
          type: 'CARD',
          last4: '4242',
          brand: 'VISA',
          expiryDate: DateTime(2027, 12, 31),
        );
      });

      test('should create PaymentMethod with all fields', () {
        expect(mockPaymentMethod.id, 'pm-test');
        expect(mockPaymentMethod.type, 'CARD');
        expect(mockPaymentMethod.last4, '4242');
        expect(mockPaymentMethod.brand, 'VISA');
        expect(mockPaymentMethod.expiryDate, isA<DateTime>());
      });

      test('should handle optional fields as null', () {
        final paymentMethod = PaymentMethod(
          id: 'pm-minimal',
          type: 'BANK',
          last4: '5678',
          // brand and expiryDate are null
        );

        expect(paymentMethod.brand, isNull);
        expect(paymentMethod.expiryDate, isNull);
      });

      test('fromJson should create PaymentMethod correctly', () {
        final json = {
          'id': 'pm-test',
          'type': 'CARD',
          'last4': '4242',
          'brand': 'VISA',
          'expiryDate': '2027-12-31T23:59:59.000Z',
        };

        final paymentMethod = PaymentMethod.fromJson(json);
        expect(paymentMethod.id, 'pm-test');
        expect(paymentMethod.type, 'CARD');
        expect(paymentMethod.last4, '4242');
        expect(paymentMethod.brand, 'VISA');
        expect(paymentMethod.expiryDate, DateTime.parse(json['expiryDate'] as String));
      });

      test('fromJson should handle null optional fields', () {
        final json = {
          'id': 'pm-test',
          'type': 'BANK',
          'last4': '5678',
          'brand': null,
          'expiryDate': null,
        };

        final paymentMethod = PaymentMethod.fromJson(json);
        expect(paymentMethod.brand, isNull);
        expect(paymentMethod.expiryDate, isNull);
      });

      test('toJson should create correct representation', () {
        final json = mockPaymentMethod.toJson();
        expect(json['id'], 'pm-test');
        expect(json['type'], 'CARD');
        expect(json['last4'], '4242');
        expect(json['brand'], 'VISA');
        expect(json['expiryDate'], mockPaymentMethod.expiryDate!.toIso8601String());
      });
    });

    group('SubscriptionHistory Tests', () {
      late SubscriptionHistory mockHistory;

      setUp(() {
        mockHistory = SubscriptionHistory(
          id: 'hist-test',
          action: 'CREATED',
          timestamp: DateTime(2024, 1, 1),
          description: 'Subscription created',
          amount: 29.99,
        );
      });

      test('should create SubscriptionHistory with all fields', () {
        expect(mockHistory.id, 'hist-test');
        expect(mockHistory.action, 'CREATED');
        expect(mockHistory.timestamp, isA<DateTime>());
        expect(mockHistory.description, 'Subscription created');
        expect(mockHistory.amount, 29.99);
      });

      test('should handle optional fields as null', () {
        final history = SubscriptionHistory(
          id: 'hist-minimal',
          action: 'CANCELLED',
          timestamp: DateTime.now(),
          // description and amount are null
        );

        expect(history.description, isNull);
        expect(history.amount, isNull);
      });

      test('fromJson should create SubscriptionHistory correctly', () {
        final json = {
          'id': 'hist-test',
          'action': 'RENEWED',
          'timestamp': '2024-01-01T00:00:00.000Z',
          'description': 'Subscription renewed',
          'amount': 29.99,
        };

        final history = SubscriptionHistory.fromJson(json);
        expect(history.id, 'hist-test');
        expect(history.action, 'RENEWED');
        expect(history.timestamp, DateTime.parse(json['timestamp'] as String));
        expect(history.description, 'Subscription renewed');
        expect(history.amount, 29.99);
      });

      test('should handle all subscription actions', () {
        final actions = ['CREATED', 'RENEWED', 'CANCELLED', 'UPGRADED', 'DOWNGRADED'];

        for (String action in actions) {
          final history = SubscriptionHistory(
            id: 'hist-$action',
            action: action,
            timestamp: DateTime.now(),
          );
          expect(history.action, action);
        }
      });

      test('toJson should create correct representation', () {
        final json = mockHistory.toJson();
        expect(json['id'], 'hist-test');
        expect(json['action'], 'CREATED');
        expect(json['timestamp'], mockHistory.timestamp.toIso8601String());
        expect(json['description'], 'Subscription created');
        expect(json['amount'], 29.99);
      });
    });

    group('Edge Cases', () {
      test('should handle subscription with no features', () {
        final subscription = UserSubscription(
          id: 'sub-no-features',
          userId: 'user-1',
          planId: 'plan-free',
          planName: 'Free Plan',
          tier: SubscriptionTier.free,
          price: 0.0,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: false,
          features: [], // empty features
          paymentMethod: PaymentMethod(id: 'pm-free', type: 'NONE', last4: '0000'),
          history: [],
        );

        expect(subscription.features, isEmpty);
        expect(subscription.price, 0.0);
        expect(subscription.tier, SubscriptionTier.free);
      });

      test('should handle subscription with many features', () {
        final manyFeatures = List.generate(20, (index) => 'feature_$index');
        final subscription = UserSubscription(
          id: 'sub-many-features',
          userId: 'user-1',
          planId: 'plan-enterprise',
          planName: 'Enterprise Plan',
          tier: SubscriptionTier.enterprise,
          price: 199.99,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: true,
          features: manyFeatures,
          paymentMethod: PaymentMethod(id: 'pm-1', type: 'CARD', last4: '1234'),
          history: [],
        );

        expect(subscription.features, hasLength(20));
        expect(subscription.tier, SubscriptionTier.enterprise);
      });

      test('should handle zero price subscription', () {
        final freeSubscription = TestHelper.createMockUserSubscription(
          tier: SubscriptionTier.free,
        );
        final subscription = UserSubscription(
          id: freeSubscription.id,
          userId: freeSubscription.userId,
          planId: 'plan-free',
          planName: 'Free Plan',
          tier: SubscriptionTier.free,
          price: 0.0,
          currency: freeSubscription.currency,
          startDate: freeSubscription.startDate,
          isActive: freeSubscription.isActive,
          autoRenew: freeSubscription.autoRenew,
          features: ['basic_access'],
          paymentMethod: freeSubscription.paymentMethod,
          history: freeSubscription.history,
        );

        expect(subscription.price, 0.0);
        expect(subscription.finalPrice, 0.0);
      });

      test('should handle subscription with large discount', () {
        final subscription = UserSubscription(
          id: 'sub-large-discount',
          userId: 'user-1',
          planId: 'plan-pro',
          planName: 'Pro Plan',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: true,
          features: ['feature1'],
          paymentMethod: PaymentMethod(id: 'pm-1', type: 'CARD', last4: '1234'),
          history: [],
          discountAmount: 25.00, // Large discount
        );

        expect(subscription.finalPrice, closeTo(4.99, 0.01));
      });

      test('should handle discount larger than price', () {
        final subscription = UserSubscription(
          id: 'sub-over-discount',
          userId: 'user-1',
          planId: 'plan-basic',
          planName: 'Basic Plan',
          tier: SubscriptionTier.basic,
          price: 9.99,
          currency: 'USD',
          startDate: DateTime.now(),
          isActive: true,
          autoRenew: true,
          features: ['feature1'],
          paymentMethod: PaymentMethod(id: 'pm-1', type: 'CARD', last4: '1234'),
          history: [],
          discountAmount: 15.00, // Discount larger than price
        );

        expect(subscription.finalPrice, -5.01); // Negative final price
      });
    });

    group('Error Handling', () {
      test('fromJson should throw when required fields are missing', () {
        final incompleteJson = <String, dynamic>{
          'id': 'test',
          'userId': 'user-1',
          // missing other required fields
        };

        expect(() => UserSubscription.fromJson(incompleteJson), throwsA(isA<Error>()));
      });

      test('fromJson should throw on invalid DateTime format', () {
        final invalidJson = Map<String, dynamic>.from(validJson);
        invalidJson['startDate'] = 'invalid-date-format';

        expect(() => UserSubscription.fromJson(invalidJson), throwsA(isA<FormatException>()));
      });

      test('fromJson should throw on null required fields', () {
        final nullJson = Map<String, dynamic>.from(validJson);
        nullJson['id'] = null;

        expect(() => UserSubscription.fromJson(nullJson), throwsA(isA<TypeError>()));
      });

      test('fromJson should handle malformed paymentMethod', () {
        final malformedJson = Map<String, dynamic>.from(validJson);
        malformedJson['paymentMethod'] = 'not-an-object';

        expect(() => UserSubscription.fromJson(malformedJson), throwsA(isA<TypeError>()));
      });

      test('fromJson should handle malformed history', () {
        final malformedJson = Map<String, dynamic>.from(validJson);
        malformedJson['history'] = 'not-a-list';

        expect(() => UserSubscription.fromJson(malformedJson), throwsA(isA<TypeError>()));
      });
    });

    group('Business Logic Validation', () {
      test('should identify active subscriptions correctly', () {
        final activeSubscription = TestHelper.createMockUserSubscription(isActive: true);
        expect(activeSubscription.isActive, isTrue);
        expect(activeSubscription.isExpired, isFalse);
      });

      test('should identify inactive subscriptions correctly', () {
        final inactiveSubscription = TestHelper.createMockUserSubscription(isActive: false);
        expect(inactiveSubscription.isActive, isFalse);
      });

      test('should validate subscription tier hierarchy', () {
        final tiers = [
          SubscriptionTier.free,
          SubscriptionTier.basic,
          SubscriptionTier.pro,
          SubscriptionTier.premium,
          SubscriptionTier.enterprise,
        ];

        for (SubscriptionTier tier in tiers) {
          final subscription = TestHelper.createMockUserSubscription(tier: tier);
          expect(subscription.tier, tier);
        }
      });

      test('should handle subscription renewal logic', () {
        final renewableSubscription = TestHelper.createMockUserSubscription();
        expect(renewableSubscription.autoRenew, isTrue);
        expect(renewableSubscription.nextBillingDate, isNotNull);
      });

      test('should handle one-time subscription', () {
        final oneTimeSubscription = UserSubscription(
          id: 'sub-onetime',
          userId: 'user-1',
          planId: 'plan-lifetime',
          planName: 'Lifetime Plan',
          tier: SubscriptionTier.premium,
          price: 299.99,
          currency: 'USD',
          startDate: DateTime.now(),
          endDate: null, // No end date for lifetime
          nextBillingDate: null, // No next billing
          isActive: true,
          autoRenew: false,
          features: ['lifetime_access'],
          paymentMethod: PaymentMethod(id: 'pm-1', type: 'CARD', last4: '1234'),
          history: [],
        );

        expect(oneTimeSubscription.autoRenew, isFalse);
        expect(oneTimeSubscription.endDate, isNull);
        expect(oneTimeSubscription.nextBillingDate, isNull);
        expect(oneTimeSubscription.daysRemaining, -1);
      });
    });
  });
}