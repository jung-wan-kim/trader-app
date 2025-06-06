import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_provider.dart';
import '../models/user_subscription.dart';
import '../generated/l10n/app_localizations.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(subscriptionProvider);
    final availablePlans = ref.watch(availablePlansProvider);
    final currentPlan = ref.watch(currentPlanProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.subscription,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: subscriptionAsync.when(
        data: (subscription) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subscription != null) _buildCurrentPlan(subscription, currentPlan, context),
              _buildPlansSection(availablePlans, currentPlan, ref, context),
              if (subscription != null) _buildBillingHistory(subscription, context),
              const SizedBox(height: 100),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00D632),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            AppLocalizations.of(context)!.errorLoadingSubscription,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlan(UserSubscription subscription, SubscriptionPlan? currentPlan, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00D632).withOpacity(0.2),
            const Color(0xFF00D632).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00D632).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentPlan,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subscription.planName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: subscription.isActive 
                      ? const Color(0xFF00D632).withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subscription.isActive ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.inactive,
                  style: TextStyle(
                    color: subscription.isActive 
                        ? const Color(0xFF00D632)
                        : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildPlanInfo(
                context: context,
                icon: Icons.calendar_today_outlined,
                label: AppLocalizations.of(context)!.nextBilling,
                value: subscription.nextBillingDate != null
                    ? _formatDate(subscription.nextBillingDate!)
                    : AppLocalizations.of(context)!.notScheduled,
              ),
              const SizedBox(width: 20),
              _buildPlanInfo(
                context: context,
                icon: Icons.payment_outlined,
                label: AppLocalizations.of(context)!.amount,
                value: '\$${subscription.finalPrice.toStringAsFixed(2)}/${_getBillingPeriod(currentPlan)}',
              ),
            ],
          ),
          if (!subscription.autoRenew) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.orange[400],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.autoRenewalOff(_formatDate(subscription.endDate!)),
                      style: TextStyle(
                        color: Colors.orange[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanInfo({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 16,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlansSection(
    List<SubscriptionPlan> plans, 
    SubscriptionPlan? currentPlan,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.availablePlans,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...plans.map((plan) => _buildPlanCard(
            plan, 
            isCurrentPlan: currentPlan?.id == plan.id,
            ref: ref,
            context: context,
          )).toList(),
          const SizedBox(height: 16),
          const _SubscriptionTermsSection(),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    SubscriptionPlan plan, {
    required bool isCurrentPlan,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentPlan 
            ? const Color(0xFF00D632).withOpacity(0.1)
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlan 
              ? const Color(0xFF00D632)
              : plan.isPopular 
                  ? Colors.blue
                  : Colors.grey[800]!,
          width: isCurrentPlan || plan.isPopular ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (plan.isPopular)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.popular,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTierDescription(plan.tier, context),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              plan.finalPrice.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '/${plan.billingPeriod.toLowerCase()}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        if (plan.discount != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D632).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.savePercent(plan.discount!.toInt()),
                              style: const TextStyle(
                                color: Color(0xFF00D632),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                ...plan.features.map((featureKey) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF00D632),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getFeatureText(featureKey, plan, context),
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isCurrentPlan 
                        ? null 
                        : () => _showUpgradeDialog(context, ref, plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentPlan 
                          ? Colors.grey[800]
                          : plan.isPopular 
                              ? const Color(0xFF00D632)
                              : Colors.grey[800],
                      foregroundColor: isCurrentPlan 
                          ? Colors.grey[600]
                          : plan.isPopular 
                              ? Colors.black
                              : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isCurrentPlan ? AppLocalizations.of(context)!.currentPlan : AppLocalizations.of(context)!.upgrade,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistory(UserSubscription subscription, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.billingHistory,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...subscription.history.map((history) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.action,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(history.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (history.amount != null)
                  Text(
                    '\$${history.amount!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, WidgetRef ref, SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          AppLocalizations.of(context)!.upgradePlan,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.upgradePlanConfirm(plan.name),
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.price,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    '\$${plan.finalPrice.toStringAsFixed(2)}/${plan.billingPeriod.toLowerCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(subscriptionProvider.notifier).upgradePlan(plan);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.upgradeSuccessful(plan.name)),
                  backgroundColor: const Color(0xFF00D632),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D632),
            ),
            child: Text(AppLocalizations.of(context)!.upgrade),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getBillingPeriod(SubscriptionPlan? plan) {
    if (plan == null) return 'month';
    return plan.billingPeriod == 'YEARLY' ? 'year' : 'month';
  }

  String _getTierDescription(SubscriptionTier tier, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (tier) {
      case SubscriptionTier.free:
        return l10n.tierDescFree;
      case SubscriptionTier.basic:
        return l10n.tierDescBasic;
      case SubscriptionTier.pro:
        return l10n.tierDescPro;
      case SubscriptionTier.premium:
        return l10n.tierDescPremium;
      case SubscriptionTier.enterprise:
        return l10n.tierDescEnterprise;
    }
  }
  
  String _getFeatureText(String featureKey, SubscriptionPlan plan, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (featureKey) {
      case PlanFeatureKeys.basicRecommendations:
        return l10n.planFeatureBasicRecommendations;
      case PlanFeatureKeys.limitedPositions:
        return l10n.planFeatureLimitedPositions(5);
      case PlanFeatureKeys.communitySupport:
        return l10n.planFeatureCommunitySupport;
      case PlanFeatureKeys.allFreeFeatures:
        return l10n.planFeatureAllFreeFeatures;
      case PlanFeatureKeys.upToPositions:
        final maxPositions = plan.limits['maxPositions'] as int;
        return l10n.planFeatureUpToPositions(maxPositions);
      case PlanFeatureKeys.emailSupport:
        return l10n.planFeatureEmailSupport;
      case PlanFeatureKeys.basicAnalytics:
        return l10n.planFeatureBasicAnalytics;
      case PlanFeatureKeys.allBasicFeatures:
        return l10n.planFeatureAllBasicFeatures;
      case PlanFeatureKeys.realtimeRecommendations:
        return l10n.planFeatureRealtimeRecommendations;
      case PlanFeatureKeys.advancedAnalytics:
        return l10n.planFeatureAdvancedAnalytics;
      case PlanFeatureKeys.prioritySupport:
        return l10n.planFeaturePrioritySupport;
      case PlanFeatureKeys.riskManagementTools:
        return l10n.planFeatureRiskManagementTools;
      case PlanFeatureKeys.customAlerts:
        return l10n.planFeatureCustomAlerts;
      case PlanFeatureKeys.allProFeatures:
        return l10n.planFeatureAllProFeatures;
      case PlanFeatureKeys.monthsFree:
        return l10n.planFeatureMonthsFree(2);
      case PlanFeatureKeys.annualReview:
        return l10n.planFeatureAnnualReview;
      case PlanFeatureKeys.allProFeaturesUnlimited:
        return l10n.planFeatureAllProFeaturesUnlimited;
      case PlanFeatureKeys.unlimitedPositions:
        return l10n.planFeatureUnlimitedPositions;
      case PlanFeatureKeys.apiAccess:
        return l10n.planFeatureApiAccess;
      case PlanFeatureKeys.dedicatedManager:
        return l10n.planFeatureDedicatedManager;
      case PlanFeatureKeys.customStrategies:
        return l10n.planFeatureCustomStrategies;
      case PlanFeatureKeys.whiteLabelOptions:
        return l10n.planFeatureWhiteLabelOptions;
      default:
        return featureKey; // Fallback to key if not found
    }
  }
}

class _SubscriptionTermsSection extends StatelessWidget {
  const _SubscriptionTermsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.subscriptionTerms,
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.subscriptionTermsText,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}