import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/user_profile_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          l10n?.notificationSettings ?? 'Notification Settings',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: settingsAsync.when(
        data: (settings) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 주요 설정
              _buildSectionTitle(l10n?.generalSettings ?? 'General Settings'),
              _buildSwitch(
                title: l10n?.pushNotifications ?? 'Push Notifications',
                subtitle: l10n?.pushNotificationsDesc ?? 'Receive notifications on your device',
                value: settings.pushEnabled,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).togglePushNotifications(value);
                },
              ),
              _buildSwitch(
                title: l10n?.emailNotifications ?? 'Email Notifications',
                subtitle: l10n?.emailNotificationsDesc ?? 'Receive notifications via email',
                value: settings.emailEnabled,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleEmailNotifications(value);
                },
              ),
              const Divider(color: Colors.grey),
              
              // 알림 유형
              _buildSectionTitle(l10n?.notificationTypes ?? 'Notification Types'),
              _buildSwitch(
                title: l10n?.tradeAlerts ?? 'Trade Alerts',
                subtitle: l10n?.tradeAlertsDesc ?? 'Get notified when trades are executed',
                value: settings.tradeAlerts,
                onChanged: settings.pushEnabled || settings.emailEnabled ? (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleTradeAlerts(value);
                } : null,
              ),
              _buildSwitch(
                title: l10n?.priceAlerts ?? 'Price Alerts',
                subtitle: l10n?.priceAlertsDesc ?? 'Get notified on significant price movements',
                value: settings.priceAlerts,
                onChanged: settings.pushEnabled || settings.emailEnabled ? (value) {
                  ref.read(notificationSettingsProvider.notifier).togglePriceAlerts(value);
                } : null,
              ),
              _buildSwitch(
                title: l10n?.newsAlerts ?? 'News Alerts',
                subtitle: l10n?.newsAlertsDesc ?? 'Get notified about important market news',
                value: settings.newsAlerts,
                onChanged: settings.pushEnabled || settings.emailEnabled ? (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleNewsAlerts(value);
                } : null,
              ),
              _buildSwitch(
                title: l10n?.marketOpenClose ?? 'Market Open/Close',
                subtitle: l10n?.marketOpenCloseDesc ?? 'Get notified when markets open or close',
                value: settings.marketOpenClose,
                onChanged: settings.pushEnabled || settings.emailEnabled ? (value) {
                  ref.read(notificationSettingsProvider.notifier).toggleMarketOpenClose(value);
                } : null,
              ),
              
              // 알림 시간 설정
              const SizedBox(height: 24),
              _buildSectionTitle(l10n?.quietHours ?? 'Quiet Hours'),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.quietHoursDesc ?? 'No notifications will be sent during these hours',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeSelector(
                            context,
                            label: l10n?.from ?? 'From',
                            time: '22:00',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimeSelector(
                            context,
                            label: l10n?.to ?? 'To',
                            time: '07:00',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 정보 메시지
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[400], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n?.notificationInfo ?? 'You can customize notification settings for individual stocks in your watchlist.',
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00D632),
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[600],
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.errorLoadingSettings ?? 'Error loading settings',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.invalidate(notificationSettingsProvider);
                },
                child: Text(
                  l10n?.retry ?? 'Retry',
                  style: const TextStyle(
                    color: Color(0xFF00D632),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool)? onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF00D632),
      inactiveThumbColor: Colors.grey[600],
      inactiveTrackColor: Colors.grey[800],
    );
  }

  Widget _buildTimeSelector(BuildContext context, {required String label, required String time}) {
    return InkWell(
      onTap: () async {
        // 시간 선택 다이얼로그 표시
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(time.split(':')[0]),
            minute: int.parse(time.split(':')[1]),
          ),
        );
        
        if (picked != null) {
          // 시간 업데이트 로직
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.access_time,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}