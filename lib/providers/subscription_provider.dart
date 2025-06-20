import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../models/user_subscription.dart';
import '../services/subscription_service.dart';
import '../services/mock_data_service.dart';
import 'mock_data_provider.dart';
import 'supabase_auth_provider.dart';

class SubscriptionPlanInfo {
  final SubscriptionTier tier;
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isMostPopular;
  final Map<String, dynamic>? limits;

  SubscriptionPlanInfo({
    required this.tier,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    required this.isMostPopular,
    this.limits,
  });
  
  // 편의 메서드들
  String get id => '${tier.toString().split('.').last}_monthly';
  
  double get finalPrice => monthlyPrice;
  
  String get billingPeriod => 'MONTHLY';
  
  double? get discount => null;
  
  bool get isPopular => isMostPopular;
}

class SubscriptionNotifier extends StateNotifier<AsyncValue<UserSubscription?>> {
  final SubscriptionService _subscriptionService;
  final Ref _ref;
  
  SubscriptionNotifier(this._subscriptionService, this._ref) : super(const AsyncValue.loading()) {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    try {
      state = const AsyncValue.loading();
      
      final auth = _ref.read(supabaseAuthProvider);
      final user = auth.currentUser;
      
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }
      
      final subscription = await _subscriptionService.getCurrentSubscription(user.id);
      state = AsyncValue.data(subscription);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  UserSubscription? _generateMockSubscription() {
    return UserSubscription(
      id: '1',
      userId: 'user123',
      planId: 'pro_monthly',
      planName: 'Pro Plan',
      tier: SubscriptionTier.pro,
      price: 29.99,
      currency: 'USD',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      nextBillingDate: DateTime.now().add(const Duration(days: 15)),
      isActive: true,
      autoRenew: true,
      features: [
        'Real-time recommendations',
        'Advanced analytics',
        'Priority support',
        'Up to 50 active positions',
        'Risk management tools',
        'Custom alerts',
      ],
      limits: {
        'maxPositions': 50,
        'maxRecommendations': 100,
        'maxAlerts': 20,
      },
      paymentMethod: PaymentMethod(
        id: '1',
        type: 'CARD',
        last4: '4242',
        brand: 'Visa',
        expiryDate: DateTime(2025, 12),
      ),
      history: [
        SubscriptionHistory(
          id: '1',
          action: 'CREATED',
          timestamp: DateTime.now().subtract(const Duration(days: 15)),
          description: 'Subscribed to Pro Plan',
          amount: 29.99,
        ),
      ],
    );
  }

  Future<void> upgradePlan(SubscriptionPlan newPlan) async {
    state.whenData((subscription) {
      if (subscription != null) {
        final upgraded = UserSubscription(
          id: subscription.id,
          userId: subscription.userId,
          planId: newPlan.id,
          planName: newPlan.name,
          tier: newPlan.tier,
          price: newPlan.price,
          currency: newPlan.currency,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(
            Duration(days: newPlan.duration == SubscriptionDuration.yearly ? 365 : 30),
          ),
          nextBillingDate: DateTime.now().add(
            Duration(days: newPlan.duration == SubscriptionDuration.yearly ? 365 : 30),
          ),
          isActive: true,
          autoRenew: subscription.autoRenew,
          features: newPlan.features,
          limits: null, // SubscriptionPlan doesn't have limits
          paymentMethod: subscription.paymentMethod,
          history: [
            ...subscription.history,
            SubscriptionHistory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              action: 'UPGRADED',
              timestamp: DateTime.now(),
              description: 'Upgraded to ${newPlan.name}',
              amount: newPlan.price,
            ),
          ],
        );
        state = AsyncValue.data(upgraded);
      }
    });
  }

  Future<void> cancelSubscription() async {
    state.whenData((subscription) {
      if (subscription != null) {
        final cancelled = UserSubscription(
          id: subscription.id,
          userId: subscription.userId,
          planId: subscription.planId,
          planName: subscription.planName,
          tier: subscription.tier,
          price: subscription.price,
          currency: subscription.currency,
          startDate: subscription.startDate,
          endDate: subscription.endDate,
          nextBillingDate: null,
          isActive: true, // Active until end date
          autoRenew: false,
          features: subscription.features,
          limits: subscription.limits,
          paymentMethod: subscription.paymentMethod,
          history: [
            ...subscription.history,
            SubscriptionHistory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              action: 'CANCELLED',
              timestamp: DateTime.now(),
              description: 'Subscription cancelled',
            ),
          ],
        );
        state = AsyncValue.data(cancelled);
      }
    });
  }

  Future<void> updateSubscription(dynamic purchasedPlan) async {
    // purchasedPlan could be from in-app purchase service
    final newSubscription = UserSubscription(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user123',
      planId: purchasedPlan.id ?? 'pro_monthly',
      planName: purchasedPlan.name ?? 'Pro Plan',
      tier: purchasedPlan.tier ?? SubscriptionTier.pro,
      price: purchasedPlan.price ?? 29.99,
      currency: purchasedPlan.currency ?? 'USD',
      startDate: purchasedPlan.startDate ?? DateTime.now(),
      endDate: purchasedPlan.endDate ?? DateTime.now().add(const Duration(days: 30)),
      nextBillingDate: purchasedPlan.endDate ?? DateTime.now().add(const Duration(days: 30)),
      isActive: true,
      autoRenew: true,
      features: purchasedPlan.features ?? [
        'Real-time recommendations',
        'Advanced analytics',
        'Priority support',
      ],
      limits: {
        'maxPositions': 50,
        'maxRecommendations': 100,
        'maxAlerts': 20,
      },
      paymentMethod: PaymentMethod(
        id: '1',
        type: 'APPLE_PAY',
        last4: '****',
        brand: 'Apple',
        expiryDate: DateTime(2025, 12),
      ),
      history: [
        SubscriptionHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          action: 'PURCHASED',
          timestamp: DateTime.now(),
          description: 'Purchased ${purchasedPlan.name ?? "subscription"}',
          amount: purchasedPlan.price ?? 29.99,
        ),
      ],
    );
    
    state = AsyncValue.data(newSubscription);
  }

  Future<void> updatePaymentMethod(PaymentMethod newPaymentMethod) async {
    state.whenData((subscription) {
      if (subscription != null) {
        final updated = UserSubscription(
          id: subscription.id,
          userId: subscription.userId,
          planId: subscription.planId,
          planName: subscription.planName,
          tier: subscription.tier,
          price: subscription.price,
          currency: subscription.currency,
          startDate: subscription.startDate,
          endDate: subscription.endDate,
          nextBillingDate: subscription.nextBillingDate,
          isActive: subscription.isActive,
          autoRenew: subscription.autoRenew,
          features: subscription.features,
          limits: subscription.limits,
          paymentMethod: newPaymentMethod,
          history: subscription.history,
        );
        state = AsyncValue.data(updated);
      }
    });
  }
}

// Service provider
final subscriptionServiceProvider = Provider((ref) => SubscriptionService());

// Provider definitions
final subscriptionProvider = 
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<UserSubscription?>>((ref) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return SubscriptionNotifier(subscriptionService, ref);
});

// Plan feature keys for localization
class PlanFeatureKeys {
  static const basicRecommendations = 'planFeatureBasicRecommendations';
  static const limitedPositions = 'planFeatureLimitedPositions';
  static const communitySupport = 'planFeatureCommunitySupport';
  static const allFreeFeatures = 'planFeatureAllFreeFeatures';
  static const upToPositions = 'planFeatureUpToPositions';
  static const emailSupport = 'planFeatureEmailSupport';
  static const basicAnalytics = 'planFeatureBasicAnalytics';
  static const allBasicFeatures = 'planFeatureAllBasicFeatures';
  static const realtimeRecommendations = 'planFeatureRealtimeRecommendations';
  static const advancedAnalytics = 'planFeatureAdvancedAnalytics';
  static const prioritySupport = 'planFeaturePrioritySupport';
  static const riskManagementTools = 'planFeatureRiskManagementTools';
  static const customAlerts = 'planFeatureCustomAlerts';
  static const allProFeatures = 'planFeatureAllProFeatures';
  static const monthsFree = 'planFeatureMonthsFree';
  static const annualReview = 'planFeatureAnnualReview';
  static const allProFeaturesUnlimited = 'planFeatureAllProFeaturesUnlimited';
  static const unlimitedPositions = 'planFeatureUnlimitedPositions';
  static const apiAccess = 'planFeatureApiAccess';
  static const dedicatedManager = 'planFeatureDedicatedManager';
  static const customStrategies = 'planFeatureCustomStrategies';
  static const whiteLabelOptions = 'planFeatureWhiteLabelOptions';
}

final availablePlansProvider = Provider<List<SubscriptionPlanInfo>>((ref) {
  final subscriptionService = ref.watch(subscriptionServiceProvider);
  return subscriptionService.getAvailablePlans();
});

final currentPlanProvider = Provider<SubscriptionPlanInfo?>((ref) {
  final subscription = ref.watch(subscriptionProvider).valueOrNull;
  final plans = ref.watch(availablePlansProvider);
  
  if (subscription == null) return null;
  
  // UserSubscription의 tier를 기반으로 현재 플랜 찾기
  return plans.firstWhereOrNull(
    (plan) => plan.tier == subscription.tier,
  );
});