import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class SubscriptionPage extends BasePage {
  SubscriptionPage(WidgetTester tester) : super(tester);
  
  // Locators
  final basicPlanCard = find.byKey(const Key('basic_plan'));
  final premiumPlanCard = find.byKey(const Key('premium_plan'));
  final proPlanCard = find.byKey(const Key('pro_plan'));
  final subscribeButton = find.byKey(const Key('subscribe_button'));
  final currentPlanBadge = find.byKey(const Key('current_plan_badge'));
  final billingCycleToggle = find.byKey(const Key('billing_cycle_toggle'));
  
  // Payment method locators
  final creditCardOption = find.byKey(const Key('credit_card_option'));
  final paypalOption = find.byKey(const Key('paypal_option'));
  final googlePayOption = find.byKey(const Key('google_pay_option'));
  final applePayOption = find.byKey(const Key('apple_pay_option'));
  
  // Renewal/cancellation locators
  final renewButton = find.byKey(const Key('renew_button'));
  final cancelButton = find.byKey(const Key('cancel_subscription'));
  final upgradeButton = find.byKey(const Key('upgrade_button'));
  final downgradeButton = find.byKey(const Key('downgrade_button'));
  
  // Actions
  Future<void> selectPlan(String planName) async {
    switch (planName.toLowerCase()) {
      case 'basic':
        await tap(basicPlanCard);
        break;
      case 'premium':
        await tap(premiumPlanCard);
        break;
      case 'pro':
        await tap(proPlanCard);
        break;
      default:
        throw Exception('Unknown plan: $planName');
    }
  }
  
  Future<void> toggleBillingCycle() async {
    await tap(billingCycleToggle);
  }
  
  Future<void> selectPaymentMethod(String method) async {
    switch (method.toLowerCase()) {
      case 'credit card':
        await tap(creditCardOption);
        break;
      case 'paypal':
        await tap(paypalOption);
        break;
      case 'google pay':
        await tap(googlePayOption);
        break;
      case 'apple pay':
        await tap(applePayOption);
        break;
    }
  }
  
  Future<void> enterPaymentDetails({
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
  }) async {
    if (cardNumber != null) {
      await enterText(find.byKey(const Key('card_number')), cardNumber);
    }
    if (expiryDate != null) {
      await enterText(find.byKey(const Key('expiry_date')), expiryDate);
    }
    if (cvv != null) {
      await enterText(find.byKey(const Key('cvv')), cvv);
    }
    if (cardholderName != null) {
      await enterText(find.byKey(const Key('cardholder_name')), cardholderName);
    }
  }
  
  Future<void> subscribe() async {
    await tap(subscribeButton);
  }
  
  Future<void> renewSubscription() async {
    await tap(renewButton);
  }
  
  Future<void> cancelSubscription() async {
    await tap(cancelButton);
    // Handle confirmation dialog
    await tap(find.text('확인'));
  }
  
  Future<void> upgradePlan() async {
    await tap(upgradeButton);
  }
  
  Future<void> downgradePlan() async {
    await tap(downgradeButton);
  }
  
  Future<void> applyPromoCode(String code) async {
    await tap(find.text('프로모 코드'));
    await enterText(find.byKey(const Key('promo_code_input')), code);
    await tap(find.text('적용'));
  }
  
  // Assertions
  void verifyCurrentPlan(String planName) {
    expect(
      find.descendant(
        of: currentPlanBadge,
        matching: find.text(planName),
      ),
      findsOneWidget,
    );
  }
  
  void verifyPlanSelected(String planName) {
    final card = planName.toLowerCase() == 'basic' ? basicPlanCard :
                 planName.toLowerCase() == 'premium' ? premiumPlanCard : proPlanCard;
    
    // Check if card has selected styling
    final Container container = tester.widget(find.descendant(
      of: card,
      matching: find.byType(Container).first,
    ));
    expect(container.decoration, isNotNull);
  }
  
  void verifyPrice(String planName, String price) {
    final card = planName.toLowerCase() == 'basic' ? basicPlanCard :
                 planName.toLowerCase() == 'premium' ? premiumPlanCard : proPlanCard;
    
    expect(
      find.descendant(
        of: card,
        matching: find.text(price),
      ),
      findsOneWidget,
    );
  }
  
  void verifyBillingCycle(String cycle) {
    expect(find.text(cycle), findsOneWidget);
  }
  
  void verifySubscribeButtonEnabled() {
    final button = tester.widget<ElevatedButton>(subscribeButton);
    expect(button.enabled, true);
  }
  
  void verifySubscribeButtonDisabled() {
    final button = tester.widget<ElevatedButton>(subscribeButton);
    expect(button.enabled, false);
  }
  
  void verifyPaymentMethodSelected(String method) {
    expect(find.text('✓ $method'), findsOneWidget);
  }
  
  void verifyPromoCodeApplied(String discount) {
    expect(find.text(discount), findsOneWidget);
  }
  
  void verifyExpirationDate(String date) {
    expect(find.text('만료일: $date'), findsOneWidget);
  }
  
  void verifyFeatureIncluded(String feature) {
    expect(find.text('✓ $feature'), findsAtLeastNWidgets(1));
  }
  
  void verifyFeatureNotIncluded(String feature) {
    expect(find.text('✗ $feature'), findsAtLeastNWidgets(1));
  }
}