import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_subscription.dart';
import '../config/env_config.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  late final SupabaseClient _supabase;
  
  SubscriptionService() {
    if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
      throw Exception('Supabase configuration not found. Please check your environment variables.');
    }
    
    _supabase = SupabaseClient(EnvConfig.supabaseUrl, EnvConfig.supabaseAnonKey);
  }

  // 사용자의 현재 구독 정보 가져오기
  Future<UserSubscription?> getCurrentSubscription(String userId) async {
    try {
      final response = await _supabase
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        return UserSubscription.fromJson(response);
      }
      
      // 활성 구독이 없으면 무료 플랜 반환
      return UserSubscription(
        id: 'free',
        userId: userId,
        currentPlan: SubscriptionPlan(
          id: 'free',
          tier: SubscriptionTier.free,
          name: 'Free Plan',
          price: 0,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: [
            'Limited recommendations',
            'Basic features only',
            'Community support'
          ],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        ),
        status: SubscriptionStatus.active,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        autoRenew: false,
        paymentMethod: PaymentMethod.none,
      );
    } catch (e) {
      print('Error fetching subscription: $e');
      return null;
    }
  }

  // 구독 생성 또는 업데이트
  Future<bool> createOrUpdateSubscription({
    required String userId,
    required SubscriptionPlan plan,
    required String purchaseToken,
    required String productId,
    String? orderId,
  }) async {
    try {
      // 기존 활성 구독 취소
      await _supabase
          .from('subscriptions')
          .update({'status': 'cancelled', 'cancelled_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('status', 'active');

      // 새 구독 생성
      await _supabase.from('subscriptions').insert({
        'user_id': userId,
        'plan_id': plan.id,
        'tier': plan.tier.toString().split('.').last,
        'price': plan.price,
        'currency': plan.currency,
        'duration': plan.duration.toString().split('.').last,
        'status': 'active',
        'start_date': plan.startDate.toIso8601String(),
        'end_date': plan.endDate.toIso8601String(),
        'auto_renew': true,
        'payment_method': 'in_app_purchase',
        'purchase_token': purchaseToken,
        'product_id': productId,
        'order_id': orderId,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 사용자 프로필 업데이트
      await _supabase
          .from('user_profiles')
          .update({
            'subscription_tier': plan.tier.toString().split('.').last,
            'subscription_end_date': plan.endDate.toIso8601String(),
          })
          .eq('id', userId);

      return true;
    } catch (e) {
      print('Error creating subscription: $e');
      return false;
    }
  }

  // 구독 취소
  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      await _supabase
          .from('subscriptions')
          .update({
            'auto_renew': false,
            'cancelled_at': DateTime.now().toIso8601String(),
          })
          .eq('id', subscriptionId);

      return true;
    } catch (e) {
      print('Error cancelling subscription: $e');
      return false;
    }
  }

  // 구독 복원
  Future<bool> restoreSubscription(String userId, PurchaseDetails purchase) async {
    try {
      // 구매 정보로 구독 복원
      final productId = purchase.productID;
      final plan = _getPlanFromProductId(productId);
      
      if (plan != null) {
        return await createOrUpdateSubscription(
          userId: userId,
          plan: plan,
          purchaseToken: purchase.verificationData.serverVerificationData,
          productId: productId,
          orderId: purchase.purchaseID,
        );
      }
      
      return false;
    } catch (e) {
      print('Error restoring subscription: $e');
      return false;
    }
  }

  // 구독 히스토리 가져오기
  Future<List<Map<String, dynamic>>> getSubscriptionHistory(String userId) async {
    try {
      final response = await _supabase
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching subscription history: $e');
      return [];
    }
  }

  // 이용 가능한 구독 플랜 목록
  List<SubscriptionPlanInfo> getAvailablePlans() {
    return [
      SubscriptionPlanInfo(
        tier: SubscriptionTier.basic,
        name: 'Basic',
        monthlyPrice: 9.99,
        yearlyPrice: 99.99,
        features: [
          '5 AI recommendations per day',
          'Basic trading strategies',
          'Portfolio tracking',
          'Email support',
        ],
        isMostPopular: false,
        limits: {
          'maxPositions': 10,
          'maxRecommendations': 5,
          'maxAlerts': 5,
        },
      ),
      SubscriptionPlanInfo(
        tier: SubscriptionTier.pro,
        name: 'Pro',
        monthlyPrice: 29.99,
        yearlyPrice: 299.99,
        features: [
          '20 AI recommendations per day',
          'Advanced trading strategies',
          'Real-time alerts',
          'Priority support',
          'Custom watchlists',
        ],
        isMostPopular: true,
        limits: {
          'maxPositions': 50,
          'maxRecommendations': 20,
          'maxAlerts': 20,
        },
      ),
      SubscriptionPlanInfo(
        tier: SubscriptionTier.premium,
        name: 'Premium',
        monthlyPrice: 99.99,
        yearlyPrice: 999.99,
        features: [
          'Unlimited AI recommendations',
          'All trading strategies',
          'Advanced analytics',
          'API access',
          '24/7 phone support',
          'Personal account manager',
        ],
        isMostPopular: false,
        limits: {
          'maxPositions': -1, // unlimited
          'maxRecommendations': -1, // unlimited
          'maxAlerts': -1, // unlimited
        },
      ),
    ];
  }

  // Product ID로 플랜 정보 가져오기
  SubscriptionPlan? _getPlanFromProductId(String productId) {
    final parts = productId.split('_');
    if (parts.length != 2) return null;
    
    final tierStr = parts[0];
    final durationStr = parts[1];
    
    SubscriptionTier tier;
    switch (tierStr) {
      case 'basic':
        tier = SubscriptionTier.basic;
        break;
      case 'pro':
        tier = SubscriptionTier.pro;
        break;
      case 'premium':
        tier = SubscriptionTier.premium;
        break;
      default:
        return null;
    }
    
    final duration = durationStr == 'monthly' 
        ? SubscriptionDuration.monthly 
        : SubscriptionDuration.yearly;
    
    final plans = getAvailablePlans();
    final planInfo = plans.firstWhere((p) => p.tier == tier);
    
    final price = duration == SubscriptionDuration.monthly 
        ? planInfo.monthlyPrice 
        : planInfo.yearlyPrice;
    
    return SubscriptionPlan(
      id: productId,
      tier: tier,
      name: '${planInfo.name} ${durationStr == 'monthly' ? 'Monthly' : 'Yearly'}',
      price: price,
      currency: 'USD',
      duration: duration,
      features: planInfo.features,
      startDate: DateTime.now(),
      endDate: duration == SubscriptionDuration.monthly
          ? DateTime.now().add(const Duration(days: 30))
          : DateTime.now().add(const Duration(days: 365)),
      isActive: true,
    );
  }

  // 구독 상태 확인 (만료 여부 등)
  Future<void> checkAndUpdateSubscriptionStatus(String userId) async {
    try {
      final subscription = await getCurrentSubscription(userId);
      
      if (subscription != null && 
          subscription.endDate.isBefore(DateTime.now()) &&
          subscription.status == SubscriptionStatus.active) {
        // 구독 만료 처리
        await _supabase
            .from('subscriptions')
            .update({'status': 'expired'})
            .eq('id', subscription.id);
            
        // 사용자 프로필을 Free로 변경
        await _supabase
            .from('user_profiles')
            .update({
              'subscription_tier': 'free',
              'subscription_end_date': null,
            })
            .eq('id', userId);
      }
    } catch (e) {
      print('Error checking subscription status: $e');
    }
  }
}