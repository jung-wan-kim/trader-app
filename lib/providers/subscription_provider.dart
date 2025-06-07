import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_subscription.dart';
import '../services/mock_data_service.dart';
import 'mock_data_provider.dart';

class SubscriptionPlanInfo {
  final String id;
  final String name;
  final SubscriptionTier tier;
  final double price;
  final String currency;
  final String billingPeriod; // MONTHLY, YEARLY
  final List<String> features;
  final Map<String, dynamic> limits;
  final double? discount; // Percentage discount for yearly plans
  final bool isPopular;

  SubscriptionPlanInfo({
    required this.id,
    required this.name,
    required this.tier,
    required this.price,
    required this.currency,
    required this.billingPeriod,
    required this.features,
    required this.limits,
    this.discount,
    this.isPopular = false,
  });

  double get finalPrice => price * (1 - (discount ?? 0) / 100);
  double get monthlyPrice => billingPeriod == 'YEARLY' ? finalPrice / 12 : finalPrice;
}

class SubscriptionNotifier extends StateNotifier<AsyncValue<UserSubscription?>> {
  final MockDataService _mockDataService;
  
  SubscriptionNotifier(this._mockDataService) : super(const AsyncValue.loading()) {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    try {
      state = const AsyncValue.loading();
      // Mock subscription data
      final subscription = _generateMockSubscription();
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

// Provider definitions
final subscriptionProvider = 
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<UserSubscription?>>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return SubscriptionNotifier(mockDataService);
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
  return [
    SubscriptionPlanInfo(
      id: 'free',
      name: 'Free Plan',
      tier: SubscriptionTier.free,
      price: 0,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        PlanFeatureKeys.basicRecommendations,
        PlanFeatureKeys.limitedPositions,
        PlanFeatureKeys.communitySupport,
      ],
      limits: {
        'maxPositions': 5,
        'maxRecommendations': 10,
        'maxAlerts': 0,
      },
    ),
    SubscriptionPlanInfo(
      id: 'basic_monthly',
      name: 'Basic Plan',
      tier: SubscriptionTier.basic,
      price: 9.99,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        PlanFeatureKeys.allFreeFeatures,
        PlanFeatureKeys.upToPositions,
        PlanFeatureKeys.emailSupport,
        PlanFeatureKeys.basicAnalytics,
      ],
      limits: {
        'maxPositions': 20,
        'maxRecommendations': 50,
        'maxAlerts': 5,
      },
    ),
    SubscriptionPlanInfo(
      id: 'pro_monthly',
      name: 'Pro Plan',
      tier: SubscriptionTier.pro,
      price: 29.99,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        PlanFeatureKeys.allBasicFeatures,
        PlanFeatureKeys.realtimeRecommendations,
        PlanFeatureKeys.advancedAnalytics,
        PlanFeatureKeys.prioritySupport,
        PlanFeatureKeys.upToPositions,
        PlanFeatureKeys.riskManagementTools,
        PlanFeatureKeys.customAlerts,
      ],
      limits: {
        'maxPositions': 50,
        'maxRecommendations': 100,
        'maxAlerts': 20,
      },
      isPopular: true,
    ),
    SubscriptionPlanInfo(
      id: 'pro_yearly',
      name: 'Pro Plan (Yearly)',
      tier: SubscriptionTier.pro,
      price: 299.99,
      currency: 'USD',
      billingPeriod: 'YEARLY',
      features: [
        PlanFeatureKeys.allProFeatures,
        PlanFeatureKeys.monthsFree,
        PlanFeatureKeys.annualReview,
      ],
      limits: {
        'maxPositions': 50,
        'maxRecommendations': 100,
        'maxAlerts': 20,
      },
      discount: 16.7, // 2 months free
    ),
    SubscriptionPlanInfo(
      id: 'premium_monthly',
      name: 'Premium Plan',
      tier: SubscriptionTier.premium,
      price: 99.99,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        PlanFeatureKeys.allProFeaturesUnlimited,
        PlanFeatureKeys.unlimitedPositions,
        PlanFeatureKeys.apiAccess,
        PlanFeatureKeys.dedicatedManager,
        PlanFeatureKeys.customStrategies,
        PlanFeatureKeys.whiteLabelOptions,
      ],
      limits: {
        'maxPositions': -1, // Unlimited
        'maxRecommendations': -1,
        'maxAlerts': -1,
      },
    ),
  ];
});

final currentPlanProvider = Provider<SubscriptionPlanInfo?>((ref) {
  final subscription = ref.watch(subscriptionProvider).valueOrNull;
  final plans = ref.watch(availablePlansProvider);
  
  if (subscription == null) return null;
  
  return plans.firstWhere(
    (plan) => plan.id == subscription.planId,
    orElse: () => plans.first,
  );
});