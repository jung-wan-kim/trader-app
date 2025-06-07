import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/providers/mock_data_provider.dart';
import 'package:trader_app/models/user_subscription.dart';

void main() {
  group('SubscriptionProvider Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('SubscriptionPlan Model', () {
      test('should create subscription plan with all fields', () {
        final plan = SubscriptionPlan(
          id: 'test-plan',
          name: 'Test Plan',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: ['feature1', 'feature2'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        );

        expect(plan.id, 'test-plan');
        expect(plan.name, 'Test Plan');
        expect(plan.tier, SubscriptionTier.pro);
        expect(plan.price, 29.99);
        expect(plan.currency, 'USD');
        expect(plan.duration, SubscriptionDuration.monthly);
        expect(plan.features, ['feature1', 'feature2']);
        expect(plan.isActive, isTrue);
      });
    });

    group('UserSubscription Model', () {
      test('should calculate days remaining correctly', () {
        final subscription = UserSubscription(
          id: '1',
          userId: 'user123',
          planId: 'pro-monthly',
          planName: 'Pro Monthly',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          startDate: DateTime.now().subtract(const Duration(days: 15)),
          endDate: DateTime.now().add(const Duration(days: 15)),
          isActive: true,
          autoRenew: true,
          features: ['feature1', 'feature2'],
          paymentMethod: PaymentMethod(
            id: '1',
            type: 'CARD',
            last4: '4242',
            brand: 'Visa',
            expiryDate: DateTime(2025, 12),
          ),
          history: [],
        );

        expect(subscription.daysRemaining, 14);
        expect(subscription.isExpired, isFalse);
      });

      test('should detect expired subscription', () {
        final subscription = UserSubscription(
          id: '1',
          userId: 'user123',
          planId: 'pro-monthly',
          planName: 'Pro Monthly',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          startDate: DateTime.now().subtract(const Duration(days: 45)),
          endDate: DateTime.now().subtract(const Duration(days: 15)),
          isActive: false,
          autoRenew: false,
          features: ['feature1', 'feature2'],
          paymentMethod: PaymentMethod(
            id: '1',
            type: 'CARD',
            last4: '4242',
            brand: 'Visa',
            expiryDate: DateTime(2025, 12),
          ),
          history: [],
        );

        expect(subscription.isExpired, isTrue);
        expect(subscription.daysRemaining, lessThan(0));
      });
    });

    group('SubscriptionNotifier', () {
      test('should load initial subscription', () async {
        // StateNotifierProvider에서 값을 가져오는 방법
        final subscriptionState = container.read(subscriptionProvider);
        
        // AsyncValue.when을 사용하여 데이터 확인
        subscriptionState.when(
          data: (subscription) {
            expect(subscription, isNotNull);
            expect(subscription!.tier, SubscriptionTier.pro);
            expect(subscription.isActive, isTrue);
          },
          loading: () => fail('Should not be loading'),
          error: (_, __) => fail('Should not have error'),
        );
      });

      test('should upgrade subscription plan', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        
        final newPlan = SubscriptionPlan(
          id: 'premium-yearly',
          name: 'Premium Yearly',
          tier: SubscriptionTier.premium,
          price: 299.99,
          currency: 'USD',
          duration: SubscriptionDuration.yearly,
          features: ['All features'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 365)),
          isActive: true,
        );

        await notifier.upgradePlan(newPlan);
        
        // 업그레이드 후 상태 확인
        final subscriptionState = container.read(subscriptionProvider);
        subscriptionState.when(
          data: (subscription) {
            expect(subscription!.tier, SubscriptionTier.premium);
            expect(subscription.planName, 'Premium Yearly');
          },
          loading: () => fail('Should not be loading'),
          error: (_, __) => fail('Should not have error'),
        );
      });

      test('should cancel subscription', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        
        await notifier.cancelSubscription();
        
        // 취소 후 상태 확인
        final subscriptionState = container.read(subscriptionProvider);
        subscriptionState.when(
          data: (subscription) {
            expect(subscription!.autoRenew, isFalse);
          },
          loading: () => fail('Should not be loading'),
          error: (_, __) => fail('Should not have error'),
        );
      });
    });

    group('Available Plans', () {
      test('should get available subscription plans', () {
        final plans = container.read(availablePlansProvider);
        
        expect(plans, hasLength(greaterThan(0)));
        expect(plans.any((p) => p.tier == SubscriptionTier.free), isTrue);
        expect(plans.any((p) => p.tier == SubscriptionTier.basic), isTrue);
        expect(plans.any((p) => p.tier == SubscriptionTier.pro), isTrue);
        expect(plans.any((p) => p.tier == SubscriptionTier.premium), isTrue);
      });

      test('should have correct pricing for plans', () {
        final plans = container.read(availablePlansProvider);
        
        final freePlan = plans.firstWhere((p) => p.tier == SubscriptionTier.free);
        expect(freePlan.price, 0.0);
        
        final proPlan = plans.firstWhere((p) => 
          p.tier == SubscriptionTier.pro && 
          p.billingPeriod == 'MONTHLY'
        );
        expect(proPlan.price, 29.99);
      });
    });
  });
}