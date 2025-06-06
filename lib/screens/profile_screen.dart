import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/subscription_provider.dart';
import '../providers/language_provider.dart';
import 'subscription_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'language_settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subscriptionAsync = ref.watch(subscriptionProvider);
    final subscription = subscriptionAsync.when(
      data: (sub) => sub,
      loading: () => null,
      error: (_, __) => null,
    );
    final languageNotifier = ref.read(languageProvider.notifier);
    final currentLocale = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.profile ?? 'Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 화면으로 이동
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n?.trader ?? 'Trader',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'trader@example.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 구독 상태
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: subscription?.isActive == true
                          ? Colors.amber.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      subscription?.isActive == true
                          ? l10n?.subscribedPlan(subscription?.planName ?? 'Premium') ?? '${subscription?.planName ?? 'Premium'} Active'
                          : l10n?.freePlan ?? 'Free Plan',
                      style: TextStyle(
                        color: subscription?.isActive == true
                            ? Colors.amber[700]
                            : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // 메뉴 리스트
            _buildMenuItem(
              context,
              icon: Icons.card_membership,
              title: l10n?.subscriptionManagement ?? 'Subscription Management',
              subtitle: subscription?.isActive == true && subscription?.endDate != null
                  ? l10n?.daysRemaining(subscription?.endDate?.difference(DateTime.now()).inDays ?? 0) ?? '${subscription?.endDate?.difference(DateTime.now()).inDays ?? 0} days remaining'
                  : l10n?.upgradeToPremiun ?? 'Upgrade to Premium',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.analytics,
              title: l10n?.investmentPerformance ?? 'Investment Performance',
              subtitle: l10n?.performanceDescription ?? 'Check returns and trading history',
              onTap: () {
                // 투자 성과 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.bookmark,
              title: l10n?.watchlist ?? 'Watchlist',
              subtitle: l10n?.watchlistDescription ?? 'Manage saved stocks',
              onTap: () {
                // 관심 종목 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.notifications,
              title: l10n?.notificationSettings ?? 'Notification Settings',
              subtitle: l10n?.notificationDescription ?? 'Manage recommendation and market alerts',
              onTap: () {
                // 알림 설정 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.language,
              title: 'Language / 언어',
              subtitle: '${languageNotifier.getLanguageFlag(currentLocale.languageCode)} ${languageNotifier.getLanguageName(currentLocale.languageCode)}',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            // 법적 정보 섹션
            _buildSectionTitle(l10n?.legalInformation ?? 'Legal Information'),
            _buildMenuItem(
              context,
              icon: Icons.privacy_tip,
              title: l10n?.privacyPolicy ?? 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.description,
              title: l10n?.termsOfService ?? 'Terms of Service',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.help,
              title: l10n?.customerSupport ?? 'Customer Support',
              subtitle: 'support@traderapp.com',
              onTap: () {
                // 고객 지원 화면으로 이동
              },
            ),
            const Divider(),
            // 앱 정보
            _buildSectionTitle(l10n?.appInfo ?? 'App Info'),
            _buildMenuItem(
              context,
              icon: Icons.info,
              title: l10n?.versionInfo ?? 'Version Info',
              subtitle: 'v1.0.0',
              onTap: null,
            ),
            const SizedBox(height: 20),
            // 로그아웃 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // 로그아웃 처리
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  l10n?.logout ?? 'Logout',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // 투자 경고 문구
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Text(
                        l10n?.investmentWarningTitle ?? 'Investment Risk Warning',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.investmentWarningText ?? 'All information provided in this app is for reference only and does not constitute investment advice. All investment decisions must be made at your own judgment and responsibility.',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}