import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/models/user_subscription.dart';
import '../../helpers/test_helper.dart';

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
          billingPeriod: 'MONTHLY',
          features: ['feature1', 'feature2'],
          limits: {'maxPositions': 50},
          discount: 10.0,
          isPopular: true,
        );

        expect(plan.id, 'test-plan');
        expect(plan.name, 'Test Plan');
        expect(plan.tier, SubscriptionTier.pro);
        expect(plan.price, 29.99);
        expect(plan.currency, 'USD');
        expect(plan.billingPeriod, 'MONTHLY');
        expect(plan.features, ['feature1', 'feature2']);
        expect(plan.limits, {'maxPositions': 50});
        expect(plan.discount, 10.0);
        expect(plan.isPopular, isTrue);
      });

      test('should calculate final price with discount', () {
        final plan = SubscriptionPlan(
          id: 'discount-plan',
          name: 'Discount Plan',
          tier: SubscriptionTier.basic,
          price: 100.0,
          currency: 'USD',
          billingPeriod: 'YEARLY',
          features: [],
          limits: {},
          discount: 20.0, // 20% discount
        );

        expect(plan.finalPrice, 80.0); // 100 - (100 * 0.20)
      });

      test('should calculate final price without discount', () {
        final plan = SubscriptionPlan(
          id: 'no-discount-plan',
          name: 'No Discount Plan',
          tier: SubscriptionTier.basic,
          price: 50.0,
          currency: 'USD',
          billingPeriod: 'MONTHLY',
          features: [],
          limits: {},
          // No discount specified (null)
        );

        expect(plan.finalPrice, 50.0);
      });

      test('should calculate monthly price for monthly billing', () {
        final monthlyPlan = SubscriptionPlan(
          id: 'monthly',
          name: 'Monthly Plan',
          tier: SubscriptionTier.pro,
          price: 29.99,
          currency: 'USD',
          billingPeriod: 'MONTHLY',
          features: [],
          limits: {},
        );

        expect(monthlyPlan.monthlyPrice, 29.99);
      });

      test('should calculate monthly price for yearly billing', () {
        final yearlyPlan = SubscriptionPlan(
          id: 'yearly',
          name: 'Yearly Plan',
          tier: SubscriptionTier.pro,
          price: 299.99,
          currency: 'USD',
          billingPeriod: 'YEARLY',
          features: [],
          limits: {},
        );

        expect(yearlyPlan.monthlyPrice, closeTo(24.999, 0.001)); // 299.99 / 12
      });

      test('should calculate monthly price for yearly billing with discount', () {
        final discountedYearlyPlan = SubscriptionPlan(
          id: 'discounted-yearly',
          name: 'Discounted Yearly Plan',
          tier: SubscriptionTier.pro,
          price: 360.0,
          currency: 'USD',
          billingPeriod: 'YEARLY',
          features: [],
          limits: {},
          discount: 16.67, // ~2 months free
        );

        // finalPrice = 360 * (1 - 0.1667) = 300
        // monthlyPrice = 300 / 12 = 25
        expect(discountedYearlyPlan.monthlyPrice, closeTo(25.0, 0.1));
      });
    });

    group('SubscriptionNotifier', () {
      test('should initialize with loading state', () {
        final state = container.read(subscriptionProvider);
        expect(state, isA<AsyncLoading>());
      });

      test('should load mock subscription successfully', () async {
        final subscription = await container.read(subscriptionProvider.future);
        
        expect(subscription, isA<UserSubscription>());
        expect(subscription!.id, isNotEmpty);
        expect(subscription.userId, isNotEmpty);
        expect(subscription.planName, isNotEmpty);
        expect(subscription.tier, SubscriptionTier.pro);
        expect(subscription.isActive, isTrue);
        expect(subscription.features, isNotEmpty);
        expect(subscription.paymentMethod, isA<PaymentMethod>());
        expect(subscription.history, isNotEmpty);
      });

      test('should upgrade subscription plan', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        await container.read(subscriptionProvider.future); // Load initial subscription
        
        final newPlan = SubscriptionPlan(
          id: 'premium_monthly',
          name: 'Premium Plan',
          tier: SubscriptionTier.premium,
          price: 99.99,
          currency: 'USD',
          billingPeriod: 'MONTHLY',
          features: ['premium_feature1', 'premium_feature2'],
          limits: {'maxPositions': -1}, // Unlimited
        );

        await notifier.upgradePlan(newPlan);
        final upgradedSubscription = await container.read(subscriptionProvider.future);

        expect(upgradedSubscription, isNotNull);
        expect(upgradedSubscription!.planId, newPlan.id);
        expect(upgradedSubscription.planName, newPlan.name);
        expect(upgradedSubscription.tier, SubscriptionTier.premium);
        expect(upgradedSubscription.price, 99.99);
        expect(upgradedSubscription.features, newPlan.features);
        expect(upgradedSubscription.limits, newPlan.limits);
        
        // Check that upgrade history was added
        final upgradeHistory = upgradedSubscription.history.where(
          (h) => h.action == 'UPGRADED'
        );
        expect(upgradeHistory, hasLength(1));
        expect(upgradeHistory.first.description, contains('Premium Plan'));
      });

      test('should upgrade to yearly plan with correct dates', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        await container.read(subscriptionProvider.future);
        
        final yearlyPlan = SubscriptionPlan(
          id: 'pro_yearly',
          name: 'Pro Yearly',
          tier: SubscriptionTier.pro,
          price: 299.99,
          currency: 'USD',
          billingPeriod: 'YEARLY',
          features: ['yearly_feature'],
          limits: {'maxPositions': 50},
        );

        final beforeUpgrade = DateTime.now();
        await notifier.upgradePlan(yearlyPlan);
        final afterUpgrade = DateTime.now();
        
        final subscription = await container.read(subscriptionProvider.future);
        
        expect(subscription!.endDate, isNotNull);
        expect(subscription.nextBillingDate, isNotNull);
        
        // Should be about 1 year from now
        final expectedEndDate = beforeUpgrade.add(const Duration(days: 365));
        expect(subscription.endDate!.difference(expectedEndDate).abs().inHours, lessThan(1));
        
        final expectedBillingDate = beforeUpgrade.add(const Duration(days: 365));
        expect(subscription.nextBillingDate!.difference(expectedBillingDate).abs().inHours, lessThan(1));
      });

      test('should cancel subscription', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        await container.read(subscriptionProvider.future);
        
        await notifier.cancelSubscription();
        final cancelledSubscription = await container.read(subscriptionProvider.future);

        expect(cancelledSubscription, isNotNull);
        expect(cancelledSubscription!.autoRenew, isFalse);
        expect(cancelledSubscription.nextBillingDate, isNull);
        expect(cancelledSubscription.isActive, isTrue); // Still active until end date
        
        // Check that cancellation history was added
        final cancelHistory = cancelledSubscription.history.where(
          (h) => h.action == 'CANCELLED'
        );
        expect(cancelHistory, hasLength(1));
        expect(cancelHistory.first.description, contains('cancelled'));
      });

      test('should update payment method', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        await container.read(subscriptionProvider.future);
        
        final newPaymentMethod = PaymentMethod(
          id: 'new-payment-method',
          type: 'CARD',
          last4: '9999',
          brand: 'MasterCard',
          expiryDate: DateTime(2028, 6),
        );

        await notifier.updatePaymentMethod(newPaymentMethod);
        final subscription = await container.read(subscriptionProvider.future);

        expect(subscription!.paymentMethod.id, 'new-payment-method');
        expect(subscription.paymentMethod.last4, '9999');
        expect(subscription.paymentMethod.brand, 'MasterCard');
        expect(subscription.paymentMethod.type, 'CARD');
      });

      test('should handle operations on null subscription', () async {
        // Create a container with no subscription
        final newContainer = ProviderContainer(
          overrides: [
            subscriptionProvider.overrideWith((ref) => 
              SubscriptionNotifier(ref.read(mockDataServiceProvider))
                ..state = const AsyncValue.data(null)
            ),
          ],
        );

        final notifier = newContainer.read(subscriptionProvider.notifier);
        
        final newPlan = SubscriptionPlan(
          id: 'test',
          name: 'Test',
          tier: SubscriptionTier.basic,
          price: 10.0,
          currency: 'USD',
          billingPeriod: 'MONTHLY',
          features: [],
          limits: {},
        );

        // These operations should not throw but also not change anything
        await notifier.upgradePlan(newPlan);
        await notifier.cancelSubscription();
        
        final newPaymentMethod = PaymentMethod(
          id: 'test',
          type: 'CARD',
          last4: '1234',
        );
        await notifier.updatePaymentMethod(newPaymentMethod);
        
        final subscription = await newContainer.read(subscriptionProvider.future);
        expect(subscription, isNull);
        
        newContainer.dispose();
      });
    });

    group('Available Plans Provider', () {
      test('should provide all subscription plans', () {
        final plans = container.read(availablePlansProvider);
        
        expect(plans, isNotEmpty);
        expect(plans.length, 5); // free, basic_monthly, pro_monthly, pro_yearly, premium_monthly
        
        // Check that all tiers are represented
        final tiers = plans.map((p) => p.tier).toSet();
        expect(tiers, contains(SubscriptionTier.free));
        expect(tiers, contains(SubscriptionTier.basic));
        expect(tiers, contains(SubscriptionTier.pro));
        expect(tiers, contains(SubscriptionTier.premium));
      });

      test('should have free plan with correct properties', () {
        final plans = container.read(availablePlansProvider);
        final freePlan = plans.firstWhere((p) => p.tier == SubscriptionTier.free);
        
        expect(freePlan.id, 'free');
        expect(freePlan.name, 'Free Plan');
        expect(freePlan.price, 0);
        expect(freePlan.currency, 'USD');
        expect(freePlan.billingPeriod, 'MONTHLY');
        expect(freePlan.features, isNotEmpty);
        expect(freePlan.limits, containsPair('maxPositions', 5));
        expect(freePlan.isPopular, isFalse);
      });

      test('should have popular plan marked correctly', () {
        final plans = container.read(availablePlansProvider);
        final popularPlans = plans.where((p) => p.isPopular).toList();
        
        expect(popularPlans, hasLength(1));
        expect(popularPlans.first.id, 'pro_monthly');
        expect(popularPlans.first.tier, SubscriptionTier.pro);
      });

      test('should have yearly plan with discount', () {
        final plans = container.read(availablePlansProvider);
        final yearlyPlan = plans.firstWhere((p) => p.id == 'pro_yearly');
        
        expect(yearlyPlan.billingPeriod, 'YEARLY');
        expect(yearlyPlan.discount, 16.7);
        expect(yearlyPlan.finalPrice, lessThan(yearlyPlan.price));
        expect(yearlyPlan.features, contains('2 months free'));
      });

      test('should have premium plan with unlimited limits', () {
        final plans = container.read(availablePlansProvider);
        final premiumPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.premium);
        
        expect(premiumPlan.limits['maxPositions'], -1); // Unlimited
        expect(premiumPlan.limits['maxRecommendations'], -1);
        expect(premiumPlan.limits['maxAlerts'], -1);
        expect(premiumPlan.features, contains('Unlimited positions'));
      });

      test('should have consistent pricing across similar tiers', () {
        final plans = container.read(availablePlansProvider);
        final proMonthly = plans.firstWhere((p) => p.id == 'pro_monthly');
        final proYearly = plans.firstWhere((p) => p.id == 'pro_yearly');
        
        // Yearly plan should be cheaper per month
        expect(proYearly.monthlyPrice, lessThan(proMonthly.monthlyPrice));
      });
    });

    group('Current Plan Provider', () {
      test('should return current plan when subscription exists', () async {
        await container.read(subscriptionProvider.future);
        final currentPlan = container.read(currentPlanProvider);
        
        expect(currentPlan, isNotNull);
        expect(currentPlan!.id, 'pro_monthly');
        expect(currentPlan.tier, SubscriptionTier.pro);
      });

      test('should return null when no subscription exists', () {
        final newContainer = ProviderContainer(
          overrides: [
            subscriptionProvider.overrideWith((ref) => 
              SubscriptionNotifier(ref.read(mockDataServiceProvider))
                ..state = const AsyncValue.data(null)
            ),
          ],
        );

        final currentPlan = newContainer.read(currentPlanProvider);
        expect(currentPlan, isNull);
        
        newContainer.dispose();
      });

      test('should return fallback plan for unknown plan ID', () async {
        // Create subscription with unknown plan ID
        final testSubscription = TestHelper.createMockUserSubscription();
        final unknownSubscription = UserSubscription(
          id: testSubscription.id,
          userId: testSubscription.userId,
          planId: 'unknown_plan_id',
          planName: testSubscription.planName,
          tier: testSubscription.tier,
          price: testSubscription.price,
          currency: testSubscription.currency,
          startDate: testSubscription.startDate,
          endDate: testSubscription.endDate,
          nextBillingDate: testSubscription.nextBillingDate,
          isActive: testSubscription.isActive,
          autoRenew: testSubscription.autoRenew,
          features: testSubscription.features,
          limits: testSubscription.limits,
          paymentMethod: testSubscription.paymentMethod,
          history: testSubscription.history,
        );

        final newContainer = ProviderContainer(
          overrides: [
            subscriptionProvider.overrideWith((ref) => 
              SubscriptionNotifier(ref.read(mockDataServiceProvider))
                ..state = AsyncValue.data(unknownSubscription)
            ),
          ],
        );

        final currentPlan = newContainer.read(currentPlanProvider);
        expect(currentPlan, isNotNull);
        expect(currentPlan!.tier, SubscriptionTier.free); // Should fallback to first plan (free)
        
        newContainer.dispose();
      });

      test('should update when subscription changes', () async {
        await container.read(subscriptionProvider.future);
        final initialPlan = container.read(currentPlanProvider);
        
        // Upgrade subscription
        final notifier = container.read(subscriptionProvider.notifier);
        final premiumPlan = container.read(availablePlansProvider)
            .firstWhere((p) => p.tier == SubscriptionTier.premium);
        
        await notifier.upgradePlan(premiumPlan);
        final updatedPlan = container.read(currentPlanProvider);
        
        expect(initialPlan!.tier, SubscriptionTier.pro);
        expect(updatedPlan!.tier, SubscriptionTier.premium);
        expect(updatedPlan.id, premiumPlan.id);
      });
    });

    group('Integration Tests', () {
      test('should support complete upgrade workflow', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        final plans = container.read(availablePlansProvider);
        
        // 1. Start with current subscription
        final initialSubscription = await container.read(subscriptionProvider.future);
        final initialPlan = container.read(currentPlanProvider);
        
        expect(initialSubscription!.tier, SubscriptionTier.pro);
        expect(initialPlan!.tier, SubscriptionTier.pro);
        
        // 2. Upgrade to premium
        final premiumPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.premium);
        await notifier.upgradePlan(premiumPlan);
        
        final premiumSubscription = await container.read(subscriptionProvider.future);
        final premiumCurrentPlan = container.read(currentPlanProvider);
        
        expect(premiumSubscription!.tier, SubscriptionTier.premium);
        expect(premiumCurrentPlan!.tier, SubscriptionTier.premium);
        expect(premiumSubscription.price, premiumPlan.price);
        
        // 3. Verify history tracking
        final upgradeHistory = premiumSubscription.history.where(
          (h) => h.action == 'UPGRADED'
        );
        expect(upgradeHistory, hasLength(1));
      });

      test('should support payment method update workflow', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        
        // 1. Get initial payment method
        final initialSubscription = await container.read(subscriptionProvider.future);
        final initialPayment = initialSubscription!.paymentMethod;
        
        expect(initialPayment.last4, '4242');
        expect(initialPayment.brand, 'Visa');
        
        // 2. Update payment method
        final newPayment = PaymentMethod(
          id: 'new-pm',
          type: 'CARD',
          last4: '5555',
          brand: 'MasterCard',
          expiryDate: DateTime(2029, 12),
        );
        
        await notifier.updatePaymentMethod(newPayment);
        
        // 3. Verify update
        final updatedSubscription = await container.read(subscriptionProvider.future);
        final updatedPayment = updatedSubscription!.paymentMethod;
        
        expect(updatedPayment.id, 'new-pm');
        expect(updatedPayment.last4, '5555');
        expect(updatedPayment.brand, 'MasterCard');
        expect(updatedPayment.expiryDate!.year, 2029);
        
        // Other subscription details should remain unchanged
        expect(updatedSubscription.id, initialSubscription.id);
        expect(updatedSubscription.tier, initialSubscription.tier);
        expect(updatedSubscription.price, initialSubscription.price);
      });

      test('should support cancellation workflow', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        
        // 1. Verify active subscription
        final activeSubscription = await container.read(subscriptionProvider.future);
        expect(activeSubscription!.isActive, isTrue);
        expect(activeSubscription.autoRenew, isTrue);
        expect(activeSubscription.nextBillingDate, isNotNull);
        
        // 2. Cancel subscription
        await notifier.cancelSubscription();
        
        // 3. Verify cancellation
        final cancelledSubscription = await container.read(subscriptionProvider.future);
        expect(cancelledSubscription!.isActive, isTrue); // Still active until end date
        expect(cancelledSubscription.autoRenew, isFalse);
        expect(cancelledSubscription.nextBillingDate, isNull);
        
        // 4. Verify cancellation history
        final cancelHistory = cancelledSubscription.history.where(
          (h) => h.action == 'CANCELLED'
        );
        expect(cancelHistory, hasLength(1));
        expect(cancelHistory.first.description, 'Subscription cancelled');
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle upgrade with same plan', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        await container.read(subscriptionProvider.future);
        
        final currentPlan = container.read(currentPlanProvider);
        
        // Try to "upgrade" to the same plan
        await notifier.upgradePlan(currentPlan!);
        
        final subscription = await container.read(subscriptionProvider.future);
        expect(subscription, isNotNull);
        
        // Should still work, might be treated as a renewal
        final upgradeHistory = subscription!.history.where(
          (h) => h.action == 'UPGRADED'
        );
        expect(upgradeHistory, hasLength(1));
      });

      test('should handle downgrade scenario', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        final plans = container.read(availablePlansProvider);
        await container.read(subscriptionProvider.future);
        
        // "Downgrade" to basic plan
        final basicPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.basic);
        await notifier.upgradePlan(basicPlan);
        
        final subscription = await container.read(subscriptionProvider.future);
        expect(subscription!.tier, SubscriptionTier.basic);
        expect(subscription.price, basicPlan.price);
        
        // History should still show as "UPGRADED" (business logic might differ)
        final upgradeHistory = subscription.history.where(
          (h) => h.action == 'UPGRADED'
        );
        expect(upgradeHistory, hasLength(1));
      });

      test('should handle plans with zero price', () {
        final plans = container.read(availablePlansProvider);
        final freePlan = plans.firstWhere((p) => p.price == 0);
        
        expect(freePlan.finalPrice, 0.0);
        expect(freePlan.monthlyPrice, 0.0);
        expect(freePlan.tier, SubscriptionTier.free);
      });

      test('should handle plans with extreme discount', () {
        final extremePlan = SubscriptionPlan(
          id: 'extreme',
          name: 'Extreme Discount',
          tier: SubscriptionTier.basic,
          price: 100.0,
          currency: 'USD',
          billingPeriod: 'YEARLY',
          features: [],
          limits: {},
          discount: 99.9, // 99.9% discount
        );

        expect(extremePlan.finalPrice, closeTo(0.1, 0.01));
        expect(extremePlan.monthlyPrice, closeTo(0.0083, 0.001));
      });

      test('should handle update payment method with minimal data', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        await container.read(subscriptionProvider.future);
        
        final minimalPayment = PaymentMethod(
          id: 'minimal',
          type: 'BANK',
          last4: '6789',
          // brand and expiryDate are null
        );
        
        await notifier.updatePaymentMethod(minimalPayment);
        
        final subscription = await container.read(subscriptionProvider.future);
        final payment = subscription!.paymentMethod;
        
        expect(payment.id, 'minimal');
        expect(payment.type, 'BANK');
        expect(payment.last4, '6789');
        expect(payment.brand, isNull);
        expect(payment.expiryDate, isNull);
      });
    });

    group('Business Logic Validation', () {
      test('should maintain proper tier hierarchy in plans', () {
        final plans = container.read(availablePlansProvider);
        
        final freePlan = plans.firstWhere((p) => p.tier == SubscriptionTier.free);
        final basicPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.basic);
        final proPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.pro);
        final premiumPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.premium);
        
        // Price should generally increase with tier
        expect(freePlan.price, lessThanOrEqualTo(basicPlan.price));
        expect(basicPlan.price, lessThan(proPlan.price));
        expect(proPlan.price, lessThan(premiumPlan.price));
        
        // Limits should generally increase with tier
        expect(freePlan.limits['maxPositions'], lessThan(basicPlan.limits['maxPositions']));
        expect(basicPlan.limits['maxPositions'], lessThan(proPlan.limits['maxPositions']));
        // Premium has unlimited (-1)
        expect(premiumPlan.limits['maxPositions'], -1);
      });

      test('should validate feature progression across tiers', () {
        final plans = container.read(availablePlansProvider);
        
        final freePlan = plans.firstWhere((p) => p.tier == SubscriptionTier.free);
        final basicPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.basic);
        final proPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.pro);
        final premiumPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.premium);
        
        // Feature count should generally increase
        expect(freePlan.features.length, lessThanOrEqualTo(basicPlan.features.length));
        expect(basicPlan.features.length, lessThanOrEqualTo(proPlan.features.length));
        expect(proPlan.features.length, lessThanOrEqualTo(premiumPlan.features.length));
        
        // Higher tiers should include lower tier features (conceptually)
        expect(basicPlan.features, contains('All Free features'));
        expect(proPlan.features, contains('All Basic features'));
        expect(premiumPlan.features, contains('All Pro features'));
      });

      test('should validate yearly vs monthly pricing', () {
        final plans = container.read(availablePlansProvider);
        
        final proMonthly = plans.firstWhere((p) => p.id == 'pro_monthly');
        final proYearly = plans.firstWhere((p) => p.id == 'pro_yearly');
        
        // Yearly should offer savings
        expect(proYearly.monthlyPrice, lessThan(proMonthly.monthlyPrice));
        
        // Discount should be reasonable (not more than 50%)
        expect(proYearly.discount!, lessThan(50.0));
        expect(proYearly.discount!, greaterThan(0.0));
      });

      test('should validate subscription state transitions', () async {
        final notifier = container.read(subscriptionProvider.notifier);
        
        // Start with active subscription
        final initial = await container.read(subscriptionProvider.future);
        expect(initial!.isActive, isTrue);
        expect(initial.autoRenew, isTrue);
        
        // Cancel subscription
        await notifier.cancelSubscription();
        final cancelled = await container.read(subscriptionProvider.future);
        expect(cancelled!.isActive, isTrue); // Still active until end date
        expect(cancelled.autoRenew, isFalse); // But won't renew
        expect(cancelled.nextBillingDate, isNull); // No next billing
        
        // Upgrade should re-enable auto-renew
        final plans = container.read(availablePlansProvider);
        final premiumPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.premium);
        await notifier.upgradePlan(premiumPlan);
        
        final upgraded = await container.read(subscriptionProvider.future);
        expect(upgraded!.isActive, isTrue);
        expect(upgraded.autoRenew, isFalse); // Preserved from cancellation
        expect(upgraded.nextBillingDate, isNotNull); // New billing date set
      });
    });

    group('Provider Memory Management', () {
      test('should dispose cleanly', () {
        final testContainer = ProviderContainer();
        
        // Initialize providers
        testContainer.read(subscriptionProvider);
        testContainer.read(availablePlansProvider);
        testContainer.read(currentPlanProvider);
        
        // Should dispose without throwing
        expect(() => testContainer.dispose(), returnsNormally);
      });

      test('should handle multiple containers', () {
        final container1 = ProviderContainer();
        final container2 = ProviderContainer();
        
        final plans1 = container1.read(availablePlansProvider);
        final plans2 = container2.read(availablePlansProvider);
        
        // Should have same content but different instances
        expect(plans1.length, plans2.length);
        expect(plans1.first.id, plans2.first.id);
        
        container1.dispose();
        container2.dispose();
      });
    });
  });
}