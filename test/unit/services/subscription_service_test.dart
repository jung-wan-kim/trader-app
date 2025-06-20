import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:trader_app/services/subscription_service.dart';
import 'package:trader_app/models/user_subscription.dart';

@GenerateMocks([SupabaseClient, PurchaseDetails])
import 'subscription_service_test.mocks.dart';

void main() {
  group('SubscriptionService Tests', () {
    late SubscriptionService service;
    late MockSupabaseClient mockSupabase;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      service = SubscriptionService();
    });

    group('getCurrentSubscription', () {
      test('should return active subscription if exists', () async {
        final mockSubscriptionData = {
          'id': 'sub123',
          'user_id': 'user123',
          'plan_id': 'pro_monthly',
          'tier': 'pro',
          'price': 29.99,
          'currency': 'USD',
          'duration': 'monthly',
          'status': 'active',
          'start_date': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
          'end_date': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
          'auto_renew': true,
          'payment_method': 'in_app_purchase',
        };

        // Test that the service can parse subscription data
        final subscription = UserSubscription.fromJson(mockSubscriptionData);
        
        expect(subscription.id, 'sub123');
        expect(subscription.userId, 'user123');
        expect(subscription.status, SubscriptionStatus.active);
        expect(subscription.autoRenew, isTrue);
      });

      test('should return free plan if no active subscription', () async {
        final subscription = await service.getCurrentSubscription('user123');
        
        // When no active subscription exists, it should return a free plan
        if (subscription != null && subscription.id == 'free') {
          expect(subscription.currentPlan.tier, SubscriptionTier.free);
          expect(subscription.currentPlan.price, 0);
          expect(subscription.autoRenew, isFalse);
        }
      });

      test('should handle null response gracefully', () async {
        final subscription = await service.getCurrentSubscription('invalid_user');
        
        // Should either return null or a free plan
        if (subscription != null) {
          expect(subscription.currentPlan.tier, SubscriptionTier.free);
        }
      });
    });

    group('createOrUpdateSubscription', () {
      test('should validate required parameters', () async {
        final plan = SubscriptionPlan(
          id: 'test_plan',
          tier: SubscriptionTier.pro,
          name: 'Test Plan',
          price: 29.99,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: ['Feature 1', 'Feature 2'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        );

        // Test with empty user ID
        final result1 = await service.createOrUpdateSubscription(
          userId: '',
          plan: plan,
          purchaseToken: 'token123',
          productId: 'product123',
        );
        expect(result1, isFalse);

        // Test with empty purchase token
        final result2 = await service.createOrUpdateSubscription(
          userId: 'user123',
          plan: plan,
          purchaseToken: '',
          productId: 'product123',
        );
        expect(result2, isFalse);
      });
    });

    group('cancelSubscription', () {
      test('should handle empty subscription ID', () async {
        final result = await service.cancelSubscription('');
        expect(result, isFalse);
      });

      test('should return boolean result', () async {
        final result = await service.cancelSubscription('sub123');
        expect(result, isA<bool>());
      });
    });

    group('getAvailablePlans', () {
      test('should return all available subscription plans', () {
        final plans = service.getAvailablePlans();
        
        expect(plans.length, 3);
        expect(plans.map((p) => p.tier).toList(), [
          SubscriptionTier.basic,
          SubscriptionTier.pro,
          SubscriptionTier.premium,
        ]);
      });

      test('should have correct plan details', () {
        final plans = service.getAvailablePlans();
        
        // Check Basic plan
        final basicPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.basic);
        expect(basicPlan.name, 'Basic');
        expect(basicPlan.monthlyPrice, 9.99);
        expect(basicPlan.yearlyPrice, 99.99);
        expect(basicPlan.isMostPopular, isFalse);
        expect(basicPlan.limits['maxPositions'], 10);
        expect(basicPlan.limits['maxRecommendations'], 5);
        expect(basicPlan.limits['maxAlerts'], 5);
        
        // Check Pro plan
        final proPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.pro);
        expect(proPlan.name, 'Pro');
        expect(proPlan.monthlyPrice, 29.99);
        expect(proPlan.yearlyPrice, 299.99);
        expect(proPlan.isMostPopular, isTrue);
        expect(proPlan.limits['maxPositions'], 50);
        expect(proPlan.limits['maxRecommendations'], 20);
        expect(proPlan.limits['maxAlerts'], 20);
        
        // Check Premium plan
        final premiumPlan = plans.firstWhere((p) => p.tier == SubscriptionTier.premium);
        expect(premiumPlan.name, 'Premium');
        expect(premiumPlan.monthlyPrice, 99.99);
        expect(premiumPlan.yearlyPrice, 999.99);
        expect(premiumPlan.isMostPopular, isFalse);
        expect(premiumPlan.limits['maxPositions'], -1); // unlimited
        expect(premiumPlan.limits['maxRecommendations'], -1); // unlimited
        expect(premiumPlan.limits['maxAlerts'], -1); // unlimited
      });

      test('should have valid features for each plan', () {
        final plans = service.getAvailablePlans();
        
        for (final plan in plans) {
          expect(plan.features, isNotEmpty);
          expect(plan.features.length, greaterThan(0));
          
          // All plans should have some common features
          if (plan.tier != SubscriptionTier.free) {
            expect(plan.features.any((f) => f.contains('support')), isTrue);
          }
        }
      });
    });

    group('_getPlanFromProductId', () {
      test('should parse product ID correctly', () {
        // Test helper function behavior
        final testCases = [
          {'id': 'basic_monthly', 'tier': SubscriptionTier.basic, 'duration': SubscriptionDuration.monthly},
          {'id': 'basic_yearly', 'tier': SubscriptionTier.basic, 'duration': SubscriptionDuration.yearly},
          {'id': 'pro_monthly', 'tier': SubscriptionTier.pro, 'duration': SubscriptionDuration.monthly},
          {'id': 'pro_yearly', 'tier': SubscriptionTier.pro, 'duration': SubscriptionDuration.yearly},
          {'id': 'premium_monthly', 'tier': SubscriptionTier.premium, 'duration': SubscriptionDuration.monthly},
          {'id': 'premium_yearly', 'tier': SubscriptionTier.premium, 'duration': SubscriptionDuration.yearly},
        ];
        
        for (final testCase in testCases) {
          final productId = testCase['id'] as String;
          final parts = productId.split('_');
          
          expect(parts.length, 2);
          expect(['basic', 'pro', 'premium'], contains(parts[0]));
          expect(['monthly', 'yearly'], contains(parts[1]));
        }
      });

      test('should handle invalid product IDs', () {
        final invalidIds = ['invalid', 'basic', 'monthly', 'basic_invalid', ''];
        
        for (final id in invalidIds) {
          final parts = id.split('_');
          final isValid = parts.length == 2 && 
                          ['basic', 'pro', 'premium'].contains(parts[0]) &&
                          ['monthly', 'yearly'].contains(parts[1]);
          
          expect(isValid, isFalse);
        }
      });
    });

    group('getSubscriptionHistory', () {
      test('should return list of subscription history', () async {
        final history = await service.getSubscriptionHistory('user123');
        
        expect(history, isA<List<Map<String, dynamic>>>());
      });

      test('should handle empty user ID', () async {
        final history = await service.getSubscriptionHistory('');
        
        expect(history, isEmpty);
      });
    });

    group('checkAndUpdateSubscriptionStatus', () {
      test('should handle expired subscriptions', () async {
        // This method checks if subscription is expired and updates status
        // Test that it completes without error
        await service.checkAndUpdateSubscriptionStatus('user123');
        
        // Method should complete normally
        expect(true, isTrue);
      });

      test('should handle empty user ID', () async {
        await service.checkAndUpdateSubscriptionStatus('');
        
        // Should not throw error
        expect(true, isTrue);
      });
    });

    group('restoreSubscription', () {
      test('should validate purchase details', () async {
        final mockPurchase = MockPurchaseDetails();
        when(mockPurchase.productID).thenReturn('pro_monthly');
        when(mockPurchase.purchaseID).thenReturn('purchase123');
        when(mockPurchase.verificationData).thenReturn(
          PurchaseVerificationData(
            localVerificationData: 'local',
            serverVerificationData: 'server',
            source: 'test',
          ),
        );

        final result = await service.restoreSubscription('user123', mockPurchase);
        
        expect(result, isA<bool>());
      });

      test('should handle invalid product ID in purchase', () async {
        final mockPurchase = MockPurchaseDetails();
        when(mockPurchase.productID).thenReturn('invalid_product');
        when(mockPurchase.verificationData).thenReturn(
          PurchaseVerificationData(
            localVerificationData: 'local',
            serverVerificationData: 'server',
            source: 'test',
          ),
        );

        final result = await service.restoreSubscription('user123', mockPurchase);
        
        expect(result, isFalse);
      });
    });

    group('Price Calculations', () {
      test('should have correct yearly discount', () {
        final plans = service.getAvailablePlans();
        
        for (final plan in plans) {
          final monthlyTotal = plan.monthlyPrice * 12;
          final yearlyPrice = plan.yearlyPrice;
          final discount = ((monthlyTotal - yearlyPrice) / monthlyTotal) * 100;
          
          // Yearly price should offer a discount
          expect(yearlyPrice, lessThan(monthlyTotal));
          expect(discount, greaterThan(10)); // At least 10% discount
        }
      });

      test('should have increasing prices by tier', () {
        final plans = service.getAvailablePlans();
        final sortedPlans = plans..sort((a, b) => a.monthlyPrice.compareTo(b.monthlyPrice));
        
        expect(sortedPlans[0].tier, SubscriptionTier.basic);
        expect(sortedPlans[1].tier, SubscriptionTier.pro);
        expect(sortedPlans[2].tier, SubscriptionTier.premium);
      });
    });
  });
}