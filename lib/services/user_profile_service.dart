import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

class UserProfileService {
  late final SupabaseClient _supabase;
  
  UserProfileService() {
    if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
      throw Exception('Supabase configuration not found. Please check your environment variables.');
    }
    
    _supabase = SupabaseClient(EnvConfig.supabaseUrl, EnvConfig.supabaseAnonKey);
  }

  // 사용자 프로필 가져오기
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return UserProfile.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // 사용자 프로필 업데이트
  Future<bool> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      
      if (fullName != null) updates['full_name'] = fullName;
      if (phoneNumber != null) updates['phone_number'] = phoneNumber;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      
      if (updates.isNotEmpty) {
        await _supabase
            .from('user_profiles')
            .update(updates)
            .eq('id', userId);
      }
      
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // 사용자 통계 가져오기
  Future<UserStats> getUserStats(String userId) async {
    try {
      // 총 거래 수
      final tradesResponse = await _supabase
          .from('trade_history')
          .select('id')
          .eq('user_id', userId);
      final totalTrades = (tradesResponse as List).length;
      
      // 관심 종목 수
      final watchlistResponse = await _supabase
          .from('watchlist')
          .select('id')
          .eq('user_id', userId);
      final watchlistCount = (watchlistResponse as List).length;
      
      // 활성 포지션 수
      final positionsResponse = await _supabase
          .from('portfolio_positions')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'OPEN');
      final activePositions = (positionsResponse as List).length;
      
      // 가입일
      final profileResponse = await _supabase
          .from('user_profiles')
          .select('created_at')
          .eq('id', userId)
          .single();
      final memberSince = DateTime.parse(profileResponse['created_at']);
      
      return UserStats(
        totalTrades: totalTrades,
        watchlistCount: watchlistCount,
        activePositions: activePositions,
        memberSince: memberSince,
      );
    } catch (e) {
      print('Error fetching user stats: $e');
      return UserStats(
        totalTrades: 0,
        watchlistCount: 0,
        activePositions: 0,
        memberSince: DateTime.now(),
      );
    }
  }

  // 알림 설정 가져오기
  Future<NotificationSettings> getNotificationSettings(String userId) async {
    try {
      final response = await _supabase
          .from('notification_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (response != null) {
        return NotificationSettings.fromJson(response);
      }
      
      // 기본 설정 반환
      return NotificationSettings(
        userId: userId,
        pushEnabled: true,
        emailEnabled: true,
        tradeAlerts: true,
        priceAlerts: true,
        newsAlerts: false,
        marketOpenClose: true,
      );
    } catch (e) {
      print('Error fetching notification settings: $e');
      return NotificationSettings(
        userId: userId,
        pushEnabled: true,
        emailEnabled: true,
        tradeAlerts: true,
        priceAlerts: true,
        newsAlerts: false,
        marketOpenClose: true,
      );
    }
  }

  // 알림 설정 업데이트
  Future<bool> updateNotificationSettings(NotificationSettings settings) async {
    try {
      await _supabase
          .from('notification_settings')
          .upsert({
            'user_id': settings.userId,
            'push_enabled': settings.pushEnabled,
            'email_enabled': settings.emailEnabled,
            'trade_alerts': settings.tradeAlerts,
            'price_alerts': settings.priceAlerts,
            'news_alerts': settings.newsAlerts,
            'market_open_close': settings.marketOpenClose,
            'updated_at': DateTime.now().toIso8601String(),
          });
      
      return true;
    } catch (e) {
      print('Error updating notification settings: $e');
      return false;
    }
  }

  // 계정 삭제
  Future<bool> deleteAccount(String userId) async {
    try {
      // 사용자 관련 데이터 삭제 (CASCADE로 처리되지 않는 경우)
      await _supabase.from('watchlist').delete().eq('user_id', userId);
      await _supabase.from('portfolio_positions').delete().eq('user_id', userId);
      await _supabase.from('trade_history').delete().eq('user_id', userId);
      await _supabase.from('notification_settings').delete().eq('user_id', userId);
      
      // 사용자 프로필 삭제
      await _supabase.from('user_profiles').delete().eq('id', userId);
      
      // Auth 사용자 삭제는 서버 사이드에서 처리
      
      return true;
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }
}

// 데이터 모델들
class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String subscriptionTier;
  final DateTime? subscriptionEndDate;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    required this.subscriptionTier,
    this.subscriptionEndDate,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
      subscriptionTier: json['subscription_tier'] ?? 'free',
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.parse(json['subscription_end_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class UserStats {
  final int totalTrades;
  final int watchlistCount;
  final int activePositions;
  final DateTime memberSince;

  UserStats({
    required this.totalTrades,
    required this.watchlistCount,
    required this.activePositions,
    required this.memberSince,
  });
}

class NotificationSettings {
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool tradeAlerts;
  final bool priceAlerts;
  final bool newsAlerts;
  final bool marketOpenClose;

  NotificationSettings({
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.tradeAlerts,
    required this.priceAlerts,
    required this.newsAlerts,
    required this.marketOpenClose,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      userId: json['user_id'],
      pushEnabled: json['push_enabled'] ?? true,
      emailEnabled: json['email_enabled'] ?? true,
      tradeAlerts: json['trade_alerts'] ?? true,
      priceAlerts: json['price_alerts'] ?? true,
      newsAlerts: json['news_alerts'] ?? false,
      marketOpenClose: json['market_open_close'] ?? true,
    );
  }

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? tradeAlerts,
    bool? priceAlerts,
    bool? newsAlerts,
    bool? marketOpenClose,
  }) {
    return NotificationSettings(
      userId: userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      tradeAlerts: tradeAlerts ?? this.tradeAlerts,
      priceAlerts: priceAlerts ?? this.priceAlerts,
      newsAlerts: newsAlerts ?? this.newsAlerts,
      marketOpenClose: marketOpenClose ?? this.marketOpenClose,
    );
  }
}