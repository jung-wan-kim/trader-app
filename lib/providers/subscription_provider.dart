import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_subscription.dart';
import '../services/mock_data_service.dart';

class SubscriptionPlan {
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

  SubscriptionPlan({
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
            Duration(days: newPlan.billingPeriod == 'YEARLY' ? 365 : 30),
          ),
          nextBillingDate: DateTime.now().add(
            Duration(days: newPlan.billingPeriod == 'YEARLY' ? 365 : 30),
          ),
          isActive: true,
          autoRenew: subscription.autoRenew,
          features: newPlan.features,
          limits: newPlan.limits,
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

final availablePlansProvider = Provider<List<SubscriptionPlan>>((ref) {
  return [
    SubscriptionPlan(
      id: 'free',
      name: 'Free Plan',
      tier: SubscriptionTier.free,
      price: 0,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        'Basic recommendations',
        'Limited to 5 positions',
        'Community support',
      ],
      limits: {
        'maxPositions': 5,
        'maxRecommendations': 10,
        'maxAlerts': 0,
      },
    ),
    SubscriptionPlan(
      id: 'basic_monthly',
      name: 'Basic Plan',
      tier: SubscriptionTier.basic,
      price: 9.99,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        'All Free features',
        'Up to 20 positions',
        'Email support',
        'Basic analytics',
      ],
      limits: {
        'maxPositions': 20,
        'maxRecommendations': 50,
        'maxAlerts': 5,
      },
    ),
    SubscriptionPlan(
      id: 'pro_monthly',
      name: 'Pro Plan',
      tier: SubscriptionTier.pro,
      price: 29.99,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        'All Basic features',
        'Real-time recommendations',
        'Advanced analytics',
        'Priority support',
        'Up to 50 positions',
        'Risk management tools',
        'Custom alerts',
      ],
      limits: {
        'maxPositions': 50,
        'maxRecommendations': 100,
        'maxAlerts': 20,
      },
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'pro_yearly',
      name: 'Pro Plan (Yearly)',
      tier: SubscriptionTier.pro,
      price: 299.99,
      currency: 'USD',
      billingPeriod: 'YEARLY',
      features: [
        'All Pro Monthly features',
        '2 months free',
        'Annual performance review',
      ],
      limits: {
        'maxPositions': 50,
        'maxRecommendations': 100,
        'maxAlerts': 20,
      },
      discount: 16.7, // 2 months free
    ),
    SubscriptionPlan(
      id: 'premium_monthly',
      name: 'Premium Plan',
      tier: SubscriptionTier.premium,
      price: 99.99,
      currency: 'USD',
      billingPeriod: 'MONTHLY',
      features: [
        'All Pro features',
        'Unlimited positions',
        'API access',
        'Dedicated account manager',
        'Custom strategies',
        'White-label options',
      ],
      limits: {
        'maxPositions': -1, // Unlimited
        'maxRecommendations': -1,
        'maxAlerts': -1,
      },
    ),
  ];
});

final currentPlanProvider = Provider<SubscriptionPlan?>((ref) {
  final subscription = ref.watch(subscriptionProvider).valueOrNull;
  final plans = ref.watch(availablePlansProvider);
  
  if (subscription == null) return null;
  
  return plans.firstWhere(
    (plan) => plan.id == subscription.planId,
    orElse: () => plans.first,
  );
});