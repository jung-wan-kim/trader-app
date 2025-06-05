class UserSubscription {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final SubscriptionTier tier;
  final double price;
  final String currency;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final bool isActive;
  final bool autoRenew;
  final List<String> features;
  final Map<String, dynamic>? limits;
  final PaymentMethod paymentMethod;
  final String? discountCode;
  final double? discountAmount;
  final List<SubscriptionHistory> history;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.tier,
    required this.price,
    required this.currency,
    required this.startDate,
    this.endDate,
    this.nextBillingDate,
    required this.isActive,
    required this.autoRenew,
    required this.features,
    this.limits,
    required this.paymentMethod,
    this.discountCode,
    this.discountAmount,
    required this.history,
  });

  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());
  int get daysRemaining => endDate != null 
      ? endDate!.difference(DateTime.now()).inDays 
      : -1;
  double get finalPrice => price - (discountAmount ?? 0);

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'],
      userId: json['userId'],
      planId: json['planId'],
      planName: json['planName'],
      tier: SubscriptionTier.values.firstWhere(
        (t) => t.name == json['tier'],
        orElse: () => SubscriptionTier.basic,
      ),
      price: json['price'].toDouble(),
      currency: json['currency'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      nextBillingDate: json['nextBillingDate'] != null 
          ? DateTime.parse(json['nextBillingDate']) : null,
      isActive: json['isActive'],
      autoRenew: json['autoRenew'],
      features: List<String>.from(json['features']),
      limits: json['limits'],
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      discountCode: json['discountCode'],
      discountAmount: json['discountAmount']?.toDouble(),
      history: (json['history'] as List)
          .map((h) => SubscriptionHistory.fromJson(h))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'planName': planName,
      'tier': tier.name,
      'price': price,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'isActive': isActive,
      'autoRenew': autoRenew,
      'features': features,
      'limits': limits,
      'paymentMethod': paymentMethod.toJson(),
      'discountCode': discountCode,
      'discountAmount': discountAmount,
      'history': history.map((h) => h.toJson()).toList(),
    };
  }
}

enum SubscriptionTier {
  free,
  basic,
  pro,
  premium,
  enterprise,
}

class PaymentMethod {
  final String id;
  final String type; // CARD, BANK, PAYPAL, etc.
  final String last4;
  final String? brand;
  final DateTime? expiryDate;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    this.brand,
    this.expiryDate,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      last4: json['last4'],
      brand: json['brand'],
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
      'brand': brand,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}

class SubscriptionHistory {
  final String id;
  final String action; // CREATED, RENEWED, CANCELLED, UPGRADED, DOWNGRADED
  final DateTime timestamp;
  final String? description;
  final double? amount;

  SubscriptionHistory({
    required this.id,
    required this.action,
    required this.timestamp,
    this.description,
    this.amount,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistory(
      id: json['id'],
      action: json['action'],
      timestamp: DateTime.parse(json['timestamp']),
      description: json['description'],
      amount: json['amount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'amount': amount,
    };
  }
}