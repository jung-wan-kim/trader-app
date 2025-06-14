import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/supabase_auth_provider.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/models/user_subscription.dart';
import '../fixtures/test_data_factory.dart';

class MockProviders {
  static List<Override> getDefaultOverrides() {
    return [
      authStateProvider.overrideWith((ref) => _mockAuthState()),
      recommendationsProvider.overrideWith((ref) => _mockRecommendations()),
      // tradersProvider.overrideWith((ref) => _mockTraders()),
      // positionsProvider.overrideWith((ref) => _mockPositions()),
      subscriptionProvider.overrideWith((ref) => _mockSubscription()),
    ];
  }
  
  static List<Override> getEmptyDataOverrides() {
    return [
      authStateProvider.overrideWith((ref) => _mockAuthState()),
      recommendationsProvider.overrideWith((ref) async => []),
      // tradersProvider.overrideWith((ref) async => []),
      // positionsProvider.overrideWith((ref) async => []),
      subscriptionProvider.overrideWith((ref) => _mockSubscription()),
    ];
  }
  
  static List<Override> getErrorOverrides() {
    return [
      authStateProvider.overrideWith((ref) => _mockAuthState()),
      recommendationsProvider.overrideWith((ref) => throw Exception('Network error')),
      // tradersProvider.overrideWith((ref) => throw Exception('Network error')),
      // positionsProvider.overrideWith((ref) => throw Exception('Network error')),
      subscriptionProvider.overrideWith((ref) => _mockSubscription()),
    ];
  }
  
  static List<Override> getUnauthenticatedOverrides() {
    return [
      authStateProvider.overrideWith((ref) => null),
      recommendationsProvider.overrideWith((ref) async => []),
      // tradersProvider.overrideWith((ref) async => []),
      // positionsProvider.overrideWith((ref) async => []),
      subscriptionProvider.overrideWith((ref) => null),
    ];
  }
  
  static dynamic _mockAuthState() {
    // Supabase User 객체 mock
    return null; // 실제 테스트에서는 적절한 mock User 객체를 반환해야 함
  }
  
  static Future<List<StockRecommendation>> _mockRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return TestDataFactory.createRecommendationList(count: 10);
  }
  
  // TraderStrategy provider는 더 이상 사용하지 않음
  // static Future<List<TraderStrategy>> _mockTraders() async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   return TestDataFactory.createTraderList(count: 5);
  // }
  
  // Position provider는 더 이상 사용하지 않음
  // static Future<List<Position>> _mockPositions() async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   return TestDataFactory.createPositionList(count: 3);
  // }
  
  static UserSubscription? _mockSubscription() {
    return UserSubscription(
      id: 'test_sub_123',
      userId: 'test_user_123',
      planId: 'premium_plan',
      planName: 'Premium Plan',
      tier: SubscriptionTier.premium,
      price: 29.99,
      currency: 'USD',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      nextBillingDate: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
      autoRenew: true,
      features: ['AI Analysis', 'Real-time Data', 'Unlimited Trades'],
      limits: {'trades_per_month': -1, 'strategies': 10},
      paymentMethod: PaymentMethod(
        id: 'pm_123',
        type: 'CARD',
        last4: '4242',
        brand: 'Visa',
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      ),
      discountCode: null,
      discountAmount: null,
      history: [],
    );
  }
  
  // Custom override builders for specific test scenarios
  static Override recommendationsWithDelay(Duration delay) {
    return recommendationsProvider.overrideWith((ref) async {
      await Future.delayed(delay);
      return TestDataFactory.createRecommendationList(count: 10);
    });
  }
  
  // Position provider는 더 이상 사용하지 않음
  // static Override positionsWithSpecificCount(int count) {
  //   return positionsProvider.overrideWith((ref) async {
  //     return TestDataFactory.createPositionList(count: count);
  //   });
  // }
  
  static Override subscriptionWithTier(SubscriptionTier tier) {
    return subscriptionProvider.overrideWith((ref) {
      return UserSubscription(
        id: 'test_sub_123',
        userId: 'test_user_123',
        planId: '${tier.name}_plan',
        planName: '${tier.name[0].toUpperCase()}${tier.name.substring(1)} Plan',
        tier: tier,
        price: tier == SubscriptionTier.premium ? 29.99 : 9.99,
        currency: 'USD',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        nextBillingDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        autoRenew: true,
        features: tier == SubscriptionTier.premium 
            ? ['AI Analysis', 'Real-time Data', 'Unlimited Trades']
            : ['Basic Analysis', 'Limited Trades'],
        limits: {'trades_per_month': tier == SubscriptionTier.premium ? -1 : 10},
        paymentMethod: PaymentMethod(
          id: 'pm_123',
          type: 'CARD',
          last4: '4242',
          brand: 'Visa',
          expiryDate: DateTime.now().add(const Duration(days: 365)),
        ),
        discountCode: null,
        discountAmount: null,
        history: [],
      );
    });
  }
}