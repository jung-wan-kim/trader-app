import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trader_app/providers/supabase_auth_provider.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/models/user_subscription.dart';
import 'package:trader_app/services/mock_data_service.dart';
import '../fixtures/test_data_factory.dart';

class MockProviders {
  static List<Override> getDefaultOverrides() {
    return [
      authStateProvider.overrideWith((ref) => Stream.value(_mockAuthState())),
      recommendationsProvider.overrideWith((ref) => _mockRecommendationsNotifier()),
      subscriptionProvider.overrideWith((ref) => _mockSubscriptionNotifier()),
    ];
  }
  
  static List<Override> getEmptyDataOverrides() {
    return [
      authStateProvider.overrideWith((ref) => Stream.value(_mockAuthState())),
      recommendationsProvider.overrideWith((ref) => _mockEmptyRecommendationsNotifier()),
      subscriptionProvider.overrideWith((ref) => _mockSubscriptionNotifier()),
    ];
  }
  
  static List<Override> getErrorOverrides() {
    return [
      authStateProvider.overrideWith((ref) => Stream.value(_mockAuthState())),
      recommendationsProvider.overrideWith((ref) => _mockErrorRecommendationsNotifier()),
      subscriptionProvider.overrideWith((ref) => _mockSubscriptionNotifier()),
    ];
  }
  
  static List<Override> getUnauthenticatedOverrides() {
    return [
      authStateProvider.overrideWith((ref) => Stream.value(const AuthState(AuthChangeEvent.signedOut, null))),
      recommendationsProvider.overrideWith((ref) => _mockEmptyRecommendationsNotifier()),
      subscriptionProvider.overrideWith((ref) => _mockEmptySubscriptionNotifier()),
    ];
  }
  
  static AuthState _mockAuthState() {
    // Mock session for authenticated state
    final mockSession = Session(
      accessToken: 'mock_access_token',
      tokenType: 'bearer',
      user: User(
        id: 'test_user_123',
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    return AuthState(AuthChangeEvent.signedIn, mockSession);
  }
  
  static RecommendationsNotifier _mockRecommendationsNotifier() {
    return MockRecommendationsNotifier(TestDataFactory.createRecommendationList(count: 10));
  }
  
  static RecommendationsNotifier _mockEmptyRecommendationsNotifier() {
    return MockRecommendationsNotifier([]);
  }
  
  static RecommendationsNotifier _mockErrorRecommendationsNotifier() {
    return MockRecommendationsNotifier([], shouldError: true);
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
  
  static SubscriptionNotifier _mockSubscriptionNotifier() {
    return MockSubscriptionNotifier(_mockSubscription());
  }
  
  static SubscriptionNotifier _mockEmptySubscriptionNotifier() {
    return MockSubscriptionNotifier(null);
  }
  
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
    return recommendationsProvider.overrideWith((ref) {
      return MockRecommendationsNotifier(
        TestDataFactory.createRecommendationList(count: 10),
        delay: delay,
      );
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
      final subscription = UserSubscription(
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
      return MockSubscriptionNotifier(subscription);
    });
  }
}

// Mock Subscription Notifier
class MockSubscriptionNotifier extends SubscriptionNotifier {
  final UserSubscription? _mockData;
  
  MockSubscriptionNotifier(this._mockData) : super(MockDataService());
  
  @override
  Future<void> loadSubscription() async {
    await Future.delayed(const Duration(milliseconds: 100));
    state = AsyncValue.data(_mockData);
  }
}

// Mock Notifier class for recommendations
class MockRecommendationsNotifier extends RecommendationsNotifier {
  final List<StockRecommendation> _mockData;
  final bool shouldError;
  final Duration? delay;
  
  MockRecommendationsNotifier(
    this._mockData, {
    this.shouldError = false,
    this.delay,
  }) : super(MockDataService());
  
  @override
  Future<void> loadRecommendations() async {
    if (delay != null) {
      await Future.delayed(delay!);
    }
    
    if (shouldError) {
      state = AsyncValue.error(Exception('Network error'), StackTrace.current);
    } else {
      state = AsyncValue.data(_mockData);
    }
  }
}