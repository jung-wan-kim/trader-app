import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_profile_service.dart';
import 'supabase_auth_provider.dart';

// User profile service provider
final userProfileServiceProvider = Provider((ref) => UserProfileService());

// User profile provider
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userProfileService = ref.watch(userProfileServiceProvider);
  final auth = ref.watch(supabaseAuthProvider);
  final user = auth.currentUser;
  
  if (user == null) {
    return null;
  }
  
  return await userProfileService.getUserProfile(user.id);
});

// User stats provider
final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final userProfileService = ref.watch(userProfileServiceProvider);
  final auth = ref.watch(supabaseAuthProvider);
  final user = auth.currentUser;
  
  if (user == null) {
    return UserStats(
      totalTrades: 0,
      watchlistCount: 0,
      activePositions: 0,
      memberSince: DateTime.now(),
    );
  }
  
  return await userProfileService.getUserStats(user.id);
});

// Notification settings provider
final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, AsyncValue<NotificationSettings>>((ref) {
  final userProfileService = ref.watch(userProfileServiceProvider);
  final auth = ref.watch(supabaseAuthProvider);
  return NotificationSettingsNotifier(userProfileService, auth);
});

class NotificationSettingsNotifier extends StateNotifier<AsyncValue<NotificationSettings>> {
  final UserProfileService _userProfileService;
  final SupabaseAuth _auth;
  
  NotificationSettingsNotifier(this._userProfileService, this._auth) : super(const AsyncValue.loading()) {
    loadSettings();
  }
  
  Future<void> loadSettings() async {
    try {
      state = const AsyncValue.loading();
      final user = _auth.currentUser;
      
      if (user == null) {
        state = AsyncValue.data(NotificationSettings(
          userId: '',
          pushEnabled: true,
          emailEnabled: true,
          tradeAlerts: true,
          priceAlerts: true,
          newsAlerts: false,
          marketOpenClose: true,
        ));
        return;
      }
      
      final settings = await _userProfileService.getNotificationSettings(user.id);
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateSettings(NotificationSettings settings) async {
    try {
      state = const AsyncValue.loading();
      final success = await _userProfileService.updateNotificationSettings(settings);
      
      if (success) {
        state = AsyncValue.data(settings);
      } else {
        throw Exception('Failed to update notification settings');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  void togglePushNotifications(bool enabled) {
    state.whenData((settings) {
      updateSettings(settings.copyWith(pushEnabled: enabled));
    });
  }
  
  void toggleEmailNotifications(bool enabled) {
    state.whenData((settings) {
      updateSettings(settings.copyWith(emailEnabled: enabled));
    });
  }
  
  void toggleTradeAlerts(bool enabled) {
    state.whenData((settings) {
      updateSettings(settings.copyWith(tradeAlerts: enabled));
    });
  }
  
  void togglePriceAlerts(bool enabled) {
    state.whenData((settings) {
      updateSettings(settings.copyWith(priceAlerts: enabled));
    });
  }
  
  void toggleNewsAlerts(bool enabled) {
    state.whenData((settings) {
      updateSettings(settings.copyWith(newsAlerts: enabled));
    });
  }
  
  void toggleMarketOpenClose(bool enabled) {
    state.whenData((settings) {
      updateSettings(settings.copyWith(marketOpenClose: enabled));
    });
  }
}