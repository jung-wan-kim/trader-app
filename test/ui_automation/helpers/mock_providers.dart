import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/auth_provider.dart';
import 'package:trader_app/providers/recommendation_provider.dart';
import 'package:trader_app/providers/trader_provider.dart';
import 'package:trader_app/providers/position_provider.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/models/position.dart';
import '../fixtures/test_data_factory.dart';

class MockProviders {
  static List<Override> getDefaultOverrides() {
    return [
      authStateProvider.overrideWith((ref) => _mockAuthState()),
      recommendationsProvider.overrideWith((ref) => _mockRecommendations()),
      tradersProvider.overrideWith((ref) => _mockTraders()),
      positionsProvider.overrideWith((ref) => _mockPositions()),
      subscriptionProvider.overrideWith((ref) => _mockSubscription()),
    ];
  }
  
  static List<Override> getEmptyDataOverrides() {
    return [
      authStateProvider.overrideWith((ref) => _mockAuthState()),
      recommendationsProvider.overrideWith((ref) async => []),
      tradersProvider.overrideWith((ref) async => []),
      positionsProvider.overrideWith((ref) async => []),
      subscriptionProvider.overrideWith((ref) => _mockSubscription()),
    ];
  }
  
  static List<Override> getErrorOverrides() {
    return [
      authStateProvider.overrideWith((ref) => _mockAuthState()),
      recommendationsProvider.overrideWith((ref) => throw Exception('Network error')),
      tradersProvider.overrideWith((ref) => throw Exception('Network error')),
      positionsProvider.overrideWith((ref) => throw Exception('Network error')),
      subscriptionProvider.overrideWith((ref) => _mockSubscription()),
    ];
  }
  
  static List<Override> getUnauthenticatedOverrides() {
    return [
      authStateProvider.overrideWith((ref) => null),
      recommendationsProvider.overrideWith((ref) async => []),
      tradersProvider.overrideWith((ref) async => []),
      positionsProvider.overrideWith((ref) async => []),
      subscriptionProvider.overrideWith((ref) => null),
    ];
  }
  
  static AuthState? _mockAuthState() {
    return AuthState(
      userId: 'test_user_123',
      email: 'test@example.com',
      token: 'test_token',
      isEmailVerified: true,
    );
  }
  
  static Future<List<StockRecommendation>> _mockRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return TestDataFactory.createRecommendationList(count: 10);
  }
  
  static Future<List<TraderStrategy>> _mockTraders() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return TestDataFactory.createTraderList(count: 5);
  }
  
  static Future<List<Position>> _mockPositions() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return TestDataFactory.createPositionList(count: 3);
  }
  
  static SubscriptionState _mockSubscription() {
    return SubscriptionState(
      tier: SubscriptionTier.premium,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
      tradersLimit: 10,
    );
  }
  
  // Custom override builders for specific test scenarios
  static Override recommendationsWithDelay(Duration delay) {
    return recommendationsProvider.overrideWith((ref) async {
      await Future.delayed(delay);
      return TestDataFactory.createRecommendationList(count: 10);
    });
  }
  
  static Override positionsWithSpecificCount(int count) {
    return positionsProvider.overrideWith((ref) async {
      return TestDataFactory.createPositionList(count: count);
    });
  }
  
  static Override subscriptionWithTier(SubscriptionTier tier) {
    return subscriptionProvider.overrideWith((ref) {
      return SubscriptionState(
        tier: tier,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        tradersLimit: tier == SubscriptionTier.premium ? 10 : 3,
      );
    });
  }
}