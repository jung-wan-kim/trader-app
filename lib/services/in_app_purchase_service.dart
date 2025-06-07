import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_subscription.dart';

class InAppPurchaseService {
  static const String _basicMonthlyId = 'basic_monthly';
  static const String _basicYearlyId = 'basic_yearly';
  static const String _proMonthlyId = 'pro_monthly';
  static const String _proYearlyId = 'pro_yearly';
  static const String _premiumMonthlyId = 'premium_monthly';
  static const String _premiumYearlyId = 'premium_yearly';
  static const String _enterpriseMonthlyId = 'enterprise_monthly';
  static const String _enterpriseYearlyId = 'enterprise_yearly';

  static const Set<String> _productIds = {
    _basicMonthlyId,
    _basicYearlyId,
    _proMonthlyId,
    _proYearlyId,
    _premiumMonthlyId,
    _premiumYearlyId,
    _enterpriseMonthlyId,
    _enterpriseYearlyId,
  };

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;

  // Callbacks
  Function(SubscriptionPlan)? onPurchaseSuccess;
  Function(String)? onPurchaseError;
  Function()? onPurchaseCanceled;

  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;
  bool get purchasePending => _purchasePending;

  Future<void> initialize() async {
    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      
      if (_isAvailable) {
        await _loadProducts();
        _startListeningToPurchases();
      }
    } catch (e) {
      debugPrint('InAppPurchase initialization error: $e');
      _isAvailable = false;
    }
  }

  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails(_productIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }
      
      _products = response.productDetails;
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  void _startListeningToPurchases() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        debugPrint('Purchase stream error: $error');
        onPurchaseError?.call('Purchase stream error: $error');
      },
    );
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          _handlePurchaseSuccess(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          onPurchaseCanceled?.call();
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
        
        _purchasePending = false;
      }
    }
  }

  void _handlePurchaseSuccess(PurchaseDetails purchaseDetails) {
    // 구매 성공 시 서버에서 영수증 검증 후 구독 업데이트
    final plan = _createSubscriptionPlanFromProductId(purchaseDetails.productID);
    if (plan != null) {
      onPurchaseSuccess?.call(plan);
    }
  }

  void _handleError(IAPError error) {
    debugPrint('Purchase error: ${error.code} - ${error.message}');
    String message = 'Purchase failed';
    
    switch (error.code) {
      case 'user_cancelled':
        onPurchaseCanceled?.call();
        return;
      case 'payment_cancelled':
        onPurchaseCanceled?.call();
        return;
      case 'payment_invalid':
        message = 'Invalid payment method';
        break;
      case 'payment_not_allowed':
        message = 'Payment not allowed';
        break;
      case 'store_kit_cancelled':
        onPurchaseCanceled?.call();
        return;
      default:
        message = error.message ?? 'Unknown error occurred';
    }
    
    onPurchaseError?.call(message);
  }

  SubscriptionPlan? _createSubscriptionPlanFromProductId(String productId) {
    switch (productId) {
      case _basicMonthlyId:
        return SubscriptionPlan(
          id: 'basic_monthly',
          tier: SubscriptionTier.basic,
          name: 'Basic Monthly',
          price: 9.99,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: ['Basic recommendations', 'Up to 5 positions', 'Email support'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        );
      case _basicYearlyId:
        return SubscriptionPlan(
          id: 'basic_yearly',
          tier: SubscriptionTier.basic,
          name: 'Basic Yearly',
          price: 99.99,
          currency: 'USD',
          duration: SubscriptionDuration.yearly,
          features: ['Basic recommendations', 'Up to 5 positions', 'Email support', '2 months free'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 365)),
          isActive: true,
        );
      case _proMonthlyId:
        return SubscriptionPlan(
          id: 'pro_monthly',
          tier: SubscriptionTier.pro,
          name: 'Pro Monthly',
          price: 29.99,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: ['Real-time recommendations', 'Up to 25 positions', 'Priority support'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        );
      case _proYearlyId:
        return SubscriptionPlan(
          id: 'pro_yearly',
          tier: SubscriptionTier.pro,
          name: 'Pro Yearly',
          price: 299.99,
          currency: 'USD',
          duration: SubscriptionDuration.yearly,
          features: ['Real-time recommendations', 'Up to 25 positions', 'Priority support', '2 months free'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 365)),
          isActive: true,
        );
      case _premiumMonthlyId:
        return SubscriptionPlan(
          id: 'premium_monthly',
          tier: SubscriptionTier.premium,
          name: 'Premium Monthly',
          price: 99.99,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: ['All Pro features', 'Unlimited positions', 'Custom alerts'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        );
      case _premiumYearlyId:
        return SubscriptionPlan(
          id: 'premium_yearly',
          tier: SubscriptionTier.premium,
          name: 'Premium Yearly',
          price: 999.99,
          currency: 'USD',
          duration: SubscriptionDuration.yearly,
          features: ['All Pro features', 'Unlimited positions', 'Custom alerts', '2 months free'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 365)),
          isActive: true,
        );
      case _enterpriseMonthlyId:
        return SubscriptionPlan(
          id: 'enterprise_monthly',
          tier: SubscriptionTier.enterprise,
          name: 'Enterprise Monthly',
          price: 299.99,
          currency: 'USD',
          duration: SubscriptionDuration.monthly,
          features: ['All Premium features', 'API access', 'Dedicated manager'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        );
      case _enterpriseYearlyId:
        return SubscriptionPlan(
          id: 'enterprise_yearly',
          tier: SubscriptionTier.enterprise,
          name: 'Enterprise Yearly',
          price: 2999.99,
          currency: 'USD',
          duration: SubscriptionDuration.yearly,
          features: ['All Premium features', 'API access', 'Dedicated manager', '2 months free'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 365)),
          isActive: true,
        );
      default:
        return null;
    }
  }

  Future<void> buyProduct(ProductDetails product) async {
    if (!_isAvailable) {
      onPurchaseError?.call('Store not available');
      return;
    }

    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      
      // iOS에서는 구독 상품, Android에서는 일반 구매
      if (Platform.isIOS) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      debugPrint('Purchase initiation error: $e');
      onPurchaseError?.call('Failed to initiate purchase: $e');
    }
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      onPurchaseError?.call('Store not available');
      return;
    }

    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Restore purchases error: $e');
      onPurchaseError?.call('Failed to restore purchases: $e');
    }
  }

  ProductDetails? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  String getProductIdForPlan(SubscriptionTier tier, SubscriptionDuration duration) {
    switch (tier) {
      case SubscriptionTier.basic:
        return duration == SubscriptionDuration.monthly ? _basicMonthlyId : _basicYearlyId;
      case SubscriptionTier.pro:
        return duration == SubscriptionDuration.monthly ? _proMonthlyId : _proYearlyId;
      case SubscriptionTier.premium:
        return duration == SubscriptionDuration.monthly ? _premiumMonthlyId : _premiumYearlyId;
      case SubscriptionTier.enterprise:
        return duration == SubscriptionDuration.monthly ? _enterpriseMonthlyId : _enterpriseYearlyId;
      default:
        return _basicMonthlyId;
    }
  }

  void dispose() {
    _subscription.cancel();
  }
}

// Provider
final inAppPurchaseServiceProvider = Provider<InAppPurchaseService>((ref) {
  final service = InAppPurchaseService();
  ref.onDispose(() => service.dispose());
  return service;
});