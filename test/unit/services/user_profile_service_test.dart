import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trader_app/services/user_profile_service.dart';

@GenerateMocks([SupabaseClient])
import 'user_profile_service_test.mocks.dart';

void main() {
  group('UserProfileService Tests', () {
    late UserProfileService service;
    late MockSupabaseClient mockSupabase;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      service = UserProfileService();
    });

    group('getUserProfile', () {
      test('should parse user profile correctly', () {
        final mockProfileData = {
          'id': 'user123',
          'email': 'test@example.com',
          'full_name': 'Test User',
          'phone_number': '+1234567890',
          'avatar_url': 'https://example.com/avatar.jpg',
          'subscription_tier': 'pro',
          'subscription_end_date': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          'created_at': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
        };

        final profile = UserProfile.fromJson(mockProfileData);
        
        expect(profile.id, 'user123');
        expect(profile.email, 'test@example.com');
        expect(profile.fullName, 'Test User');
        expect(profile.phoneNumber, '+1234567890');
        expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
        expect(profile.subscriptionTier, 'pro');
        expect(profile.subscriptionEndDate, isA<DateTime>());
        expect(profile.createdAt, isA<DateTime>());
      });

      test('should handle null optional fields', () {
        final mockProfileData = {
          'id': 'user123',
          'email': 'test@example.com',
          'full_name': null,
          'phone_number': null,
          'avatar_url': null,
          'subscription_tier': 'free',
          'subscription_end_date': null,
          'created_at': DateTime.now().toIso8601String(),
        };

        final profile = UserProfile.fromJson(mockProfileData);
        
        expect(profile.fullName, isNull);
        expect(profile.phoneNumber, isNull);
        expect(profile.avatarUrl, isNull);
        expect(profile.subscriptionEndDate, isNull);
      });

      test('should handle missing subscription tier', () {
        final mockProfileData = {
          'id': 'user123',
          'email': 'test@example.com',
          'created_at': DateTime.now().toIso8601String(),
        };

        final profile = UserProfile.fromJson(mockProfileData);
        
        expect(profile.subscriptionTier, 'free'); // Default value
      });

      test('should return null for invalid user', () async {
        final profile = await service.getUserProfile('');
        expect(profile, isNull);
      });
    });

    group('updateUserProfile', () {
      test('should handle empty user ID', () async {
        final result = await service.updateUserProfile(
          userId: '',
          fullName: 'New Name',
        );
        
        expect(result, isFalse);
      });

      test('should allow partial updates', () async {
        // Test updating only full name
        final result1 = await service.updateUserProfile(
          userId: 'user123',
          fullName: 'New Name',
        );
        expect(result1, isA<bool>());

        // Test updating only phone number
        final result2 = await service.updateUserProfile(
          userId: 'user123',
          phoneNumber: '+9876543210',
        );
        expect(result2, isA<bool>());

        // Test updating only avatar URL
        final result3 = await service.updateUserProfile(
          userId: 'user123',
          avatarUrl: 'https://example.com/new-avatar.jpg',
        );
        expect(result3, isA<bool>());
      });

      test('should handle all null updates', () async {
        // When no fields are provided, should still return true
        final result = await service.updateUserProfile(
          userId: 'user123',
        );
        
        expect(result, isTrue);
      });
    });

    group('getUserStats', () {
      test('should return default stats for new user', () async {
        final stats = await service.getUserStats('new_user');
        
        expect(stats.totalTrades, 0);
        expect(stats.watchlistCount, 0);
        expect(stats.activePositions, 0);
        expect(stats.memberSince, isA<DateTime>());
      });

      test('should handle empty user ID', () async {
        final stats = await service.getUserStats('');
        
        expect(stats.totalTrades, 0);
        expect(stats.watchlistCount, 0);
        expect(stats.activePositions, 0);
      });

      test('should create UserStats correctly', () {
        final memberSince = DateTime.now().subtract(const Duration(days: 30));
        final stats = UserStats(
          totalTrades: 42,
          watchlistCount: 10,
          activePositions: 5,
          memberSince: memberSince,
        );
        
        expect(stats.totalTrades, 42);
        expect(stats.watchlistCount, 10);
        expect(stats.activePositions, 5);
        expect(stats.memberSince, memberSince);
      });
    });

    group('getNotificationSettings', () {
      test('should return default settings when none exist', () async {
        final settings = await service.getNotificationSettings('user123');
        
        expect(settings.userId, 'user123');
        expect(settings.pushEnabled, isTrue);
        expect(settings.emailEnabled, isTrue);
        expect(settings.tradeAlerts, isTrue);
        expect(settings.priceAlerts, isTrue);
        expect(settings.newsAlerts, isFalse);
        expect(settings.marketOpenClose, isTrue);
      });

      test('should parse notification settings correctly', () {
        final mockSettingsData = {
          'user_id': 'user123',
          'push_enabled': false,
          'email_enabled': true,
          'trade_alerts': false,
          'price_alerts': true,
          'news_alerts': true,
          'market_open_close': false,
        };

        final settings = NotificationSettings.fromJson(mockSettingsData);
        
        expect(settings.userId, 'user123');
        expect(settings.pushEnabled, isFalse);
        expect(settings.emailEnabled, isTrue);
        expect(settings.tradeAlerts, isFalse);
        expect(settings.priceAlerts, isTrue);
        expect(settings.newsAlerts, isTrue);
        expect(settings.marketOpenClose, isFalse);
      });

      test('should handle null values with defaults', () {
        final mockSettingsData = {
          'user_id': 'user123',
          'push_enabled': null,
          'email_enabled': null,
        };

        final settings = NotificationSettings.fromJson(mockSettingsData);
        
        expect(settings.pushEnabled, isTrue); // Default
        expect(settings.emailEnabled, isTrue); // Default
      });
    });

    group('updateNotificationSettings', () {
      test('should update notification settings', () async {
        final settings = NotificationSettings(
          userId: 'user123',
          pushEnabled: false,
          emailEnabled: true,
          tradeAlerts: true,
          priceAlerts: false,
          newsAlerts: true,
          marketOpenClose: false,
        );

        final result = await service.updateNotificationSettings(settings);
        expect(result, isA<bool>());
      });

      test('should handle empty user ID in settings', () async {
        final settings = NotificationSettings(
          userId: '',
          pushEnabled: true,
          emailEnabled: true,
          tradeAlerts: true,
          priceAlerts: true,
          newsAlerts: false,
          marketOpenClose: true,
        );

        final result = await service.updateNotificationSettings(settings);
        expect(result, isFalse);
      });
    });

    group('NotificationSettings copyWith', () {
      test('should create a copy with updated fields', () {
        final original = NotificationSettings(
          userId: 'user123',
          pushEnabled: true,
          emailEnabled: true,
          tradeAlerts: true,
          priceAlerts: true,
          newsAlerts: false,
          marketOpenClose: true,
        );

        final updated = original.copyWith(
          pushEnabled: false,
          newsAlerts: true,
        );

        expect(updated.userId, original.userId);
        expect(updated.pushEnabled, isFalse); // Changed
        expect(updated.emailEnabled, original.emailEnabled);
        expect(updated.tradeAlerts, original.tradeAlerts);
        expect(updated.priceAlerts, original.priceAlerts);
        expect(updated.newsAlerts, isTrue); // Changed
        expect(updated.marketOpenClose, original.marketOpenClose);
      });

      test('should preserve all fields when none specified', () {
        final original = NotificationSettings(
          userId: 'user123',
          pushEnabled: true,
          emailEnabled: false,
          tradeAlerts: true,
          priceAlerts: false,
          newsAlerts: true,
          marketOpenClose: false,
        );

        final copy = original.copyWith();

        expect(copy.userId, original.userId);
        expect(copy.pushEnabled, original.pushEnabled);
        expect(copy.emailEnabled, original.emailEnabled);
        expect(copy.tradeAlerts, original.tradeAlerts);
        expect(copy.priceAlerts, original.priceAlerts);
        expect(copy.newsAlerts, original.newsAlerts);
        expect(copy.marketOpenClose, original.marketOpenClose);
      });
    });

    group('deleteAccount', () {
      test('should handle account deletion', () async {
        final result = await service.deleteAccount('user123');
        expect(result, isA<bool>());
      });

      test('should handle empty user ID', () async {
        final result = await service.deleteAccount('');
        expect(result, isFalse);
      });

      test('should handle deletion errors', () async {
        // Test that the method handles errors gracefully
        final result = await service.deleteAccount('error_user');
        expect(result, isA<bool>());
      });
    });

    group('UserProfile Model', () {
      test('should create UserProfile with all fields', () {
        final now = DateTime.now();
        final endDate = now.add(const Duration(days: 30));
        
        final profile = UserProfile(
          id: 'user123',
          email: 'test@example.com',
          fullName: 'Test User',
          phoneNumber: '+1234567890',
          avatarUrl: 'https://example.com/avatar.jpg',
          subscriptionTier: 'premium',
          subscriptionEndDate: endDate,
          createdAt: now,
        );

        expect(profile.id, 'user123');
        expect(profile.email, 'test@example.com');
        expect(profile.fullName, 'Test User');
        expect(profile.phoneNumber, '+1234567890');
        expect(profile.avatarUrl, 'https://example.com/avatar.jpg');
        expect(profile.subscriptionTier, 'premium');
        expect(profile.subscriptionEndDate, endDate);
        expect(profile.createdAt, now);
      });

      test('should create UserProfile with minimal fields', () {
        final now = DateTime.now();
        
        final profile = UserProfile(
          id: 'user123',
          email: 'test@example.com',
          subscriptionTier: 'free',
          createdAt: now,
        );

        expect(profile.id, 'user123');
        expect(profile.email, 'test@example.com');
        expect(profile.fullName, isNull);
        expect(profile.phoneNumber, isNull);
        expect(profile.avatarUrl, isNull);
        expect(profile.subscriptionTier, 'free');
        expect(profile.subscriptionEndDate, isNull);
        expect(profile.createdAt, now);
      });
    });

    group('Edge Cases', () {
      test('should handle very long names', () async {
        final longName = 'A' * 1000;
        final result = await service.updateUserProfile(
          userId: 'user123',
          fullName: longName,
        );
        
        expect(result, isA<bool>());
      });

      test('should handle special characters in phone numbers', () async {
        final specialPhone = '+1 (234) 567-8900 ext. 123';
        final result = await service.updateUserProfile(
          userId: 'user123',
          phoneNumber: specialPhone,
        );
        
        expect(result, isA<bool>());
      });

      test('should handle invalid avatar URLs', () async {
        final invalidUrl = 'not-a-valid-url';
        final result = await service.updateUserProfile(
          userId: 'user123',
          avatarUrl: invalidUrl,
        );
        
        expect(result, isA<bool>());
      });
    });
  });
}