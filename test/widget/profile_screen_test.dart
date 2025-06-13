import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/profile_screen.dart';
import 'package:trader_app/providers/subscription_provider.dart';
import 'package:trader_app/models/user_subscription.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({
      UserSubscription? subscription,
    }) {
      if (subscription != null) {
        container = ProviderContainer(
          overrides: [
            subscriptionProvider.overrideWith((ref) {
              return SubscriptionNotifier(MockDataService())
                ..state = AsyncValue.data(subscription);
            }),
          ],
        );
      }

      return ProviderScope(
        parent: container,
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const ProfileScreen(),
        ),
      );
    }

    testWidgets('should display user profile information', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check profile header
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.text('Demo User'), findsOneWidget);
      expect(find.text('demo@aitrading.com'), findsOneWidget);
    });

    testWidgets('should display subscription information', (WidgetTester tester) async {
      final testSubscription = UserSubscription(
        id: 'sub_test',
        userId: 'user_test',
        planId: 'plan_pro',
        planName: 'Pro Trader',
        tier: SubscriptionTier.pro,
        price: 49.99,
        currency: 'USD',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        autoRenew: true,
        features: [
          'Unlimited recommendations',
          'Real-time alerts',
          'Advanced analytics',
        ],
        paymentMethod: PaymentMethod(
          id: 'pm_test',
          type: 'NONE',
          last4: '0000',
        ),
        history: [],
      );

      await tester.pumpWidget(createTestWidget(subscription: testSubscription));
      await tester.pumpAndSettle();

      // Check subscription details
      expect(find.text('Pro Trader'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.textContaining('\$49.99/month'), findsOneWidget);
    });

    testWidgets('should display menu items', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check menu items
      expect(find.text('Trading History'), findsOneWidget);
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('Terms & Privacy'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);

      // Check icons
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('should show upgrade button for free tier', (WidgetTester tester) async {
      final freeSubscription = UserSubscription(
        id: 'sub_free',
        userId: 'user_test',
        planId: 'plan_free',
        planName: 'Free',
        tier: SubscriptionTier.free,
        price: 0,
        currency: 'USD',
        startDate: DateTime.now(),
        isActive: true,
        autoRenew: false,
        features: ['Basic features'],
        paymentMethod: PaymentMethod(
          id: 'pm_test',
          type: 'NONE',
          last4: '0000',
        ),
        history: [],
      );

      await tester.pumpWidget(createTestWidget(subscription: freeSubscription));
      await tester.pumpAndSettle();

      // Should show upgrade button
      expect(find.text('Upgrade Plan'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should handle menu item taps', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Trading History
      await tester.tap(find.text('Trading History'));
      await tester.pumpAndSettle();

      // Should trigger navigation (in real app would check navigation)
      expect(find.text('Trading History'), findsOneWidget);

      // Tap on Language
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Should trigger navigation
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('should display achievement badges', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check achievements section
      expect(find.text('Achievements'), findsOneWidget);
      
      // Should show some achievement badges
      expect(find.byIcon(Icons.emoji_events), findsWidgets);
    });

    testWidgets('should display trading stats', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check stats section
      expect(find.text('Trading Stats'), findsOneWidget);
      
      // Should show stats cards
      expect(find.text('Total Trades'), findsOneWidget);
      expect(find.text('Win Rate'), findsOneWidget);
      expect(find.text('Avg. Return'), findsOneWidget);
    });

    testWidgets('should handle sign out tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap sign out
      await tester.tap(find.text('Sign Out'));
      await tester.pump();

      // Should show confirmation dialog
      expect(find.text('Sign Out'), findsNWidgets(2)); // One in menu, one in dialog
      expect(find.text('Are you sure you want to sign out?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Sign Out').last, findsOneWidget);
    });

    testWidgets('should display version information', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to bottom
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Should show version
      expect(find.textContaining('Version'), findsOneWidget);
    });

    testWidgets('should handle loading state', (WidgetTester tester) async {
      // Override with loading state
      final loadingContainer = ProviderContainer(
        overrides: [
          subscriptionProvider.overrideWith((ref) {
            return SubscriptionNotifier(MockDataService())
              ..state = const AsyncValue.loading();
          }),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: loadingContainer,
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const ProfileScreen(),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loadingContainer.dispose();
    });

    testWidgets('should display expired subscription warning', (WidgetTester tester) async {
      final expiredSubscription = UserSubscription(
        id: 'sub_expired',
        userId: 'user_test',
        planId: 'plan_pro',
        planName: 'Pro Trader',
        tier: SubscriptionTier.pro,
        price: 49.99,
        currency: 'USD',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
        isActive: false,
        autoRenew: false,
        features: [],
        paymentMethod: PaymentMethod(
          id: 'pm_test',
          type: 'NONE',
          last4: '0000',
        ),
        history: [],
      );

      await tester.pumpWidget(createTestWidget(subscription: expiredSubscription));
      await tester.pumpAndSettle();

      // Should show expired status
      expect(find.text('Expired'), findsOneWidget);
      expect(find.text('Renew Subscription'), findsOneWidget);
    });
  });
}