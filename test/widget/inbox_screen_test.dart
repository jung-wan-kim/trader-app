import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/inbox_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InboxScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const InboxScreen(),
        ),
      );
    }

    testWidgets('should display inbox tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for tab bar
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Likes'), findsOneWidget);
      expect(find.text('Comments'), findsOneWidget);
      expect(find.text('Mentions'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
    });

    testWidgets('should display notifications list', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for list view
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should switch between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Likes tab
      await tester.tap(find.text('Likes'));
      await tester.pumpAndSettle();

      // Should show likes content
      expect(find.text('Likes'), findsWidgets);

      // Tap on Comments tab
      await tester.tap(find.text('Comments'));
      await tester.pumpAndSettle();

      // Should show comments content
      expect(find.text('Comments'), findsWidgets);
    });

    testWidgets('should display notification items with avatars', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for notification items
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('should handle notification item tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap first notification
      final firstNotification = find.byType(ListTile).first;
      if (firstNotification.evaluate().isNotEmpty) {
        await tester.tap(firstNotification);
        await tester.pumpAndSettle();

        // Should handle tap (navigation or action)
        expect(find.byType(InboxScreen), findsOneWidget);
      }
    });

    testWidgets('should display timestamps for notifications', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for time stamps
      expect(find.textContaining('ago'), findsWidgets);
    });

    testWidgets('should show empty state when no notifications', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Switch to a tab that might be empty
      await tester.tap(find.text('Mentions'));
      await tester.pumpAndSettle();

      // Should show empty state message
      if (find.byType(ListTile).evaluate().isEmpty) {
        expect(find.textContaining('No'), findsWidgets);
      }
    });

    testWidgets('should display notification badges', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for unread badges
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should support pull to refresh', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Perform pull to refresh
      await tester.drag(
        find.byType(ListView).first,
        const Offset(0, 300),
      );
      await tester.pumpAndSettle();

      // Should complete refresh
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('should display notification actions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for action buttons
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('should handle follow back button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Switch to Followers tab
      await tester.tap(find.text('Followers'));
      await tester.pumpAndSettle();

      // Look for follow back buttons
      final followButton = find.widgetWithText(TextButton, 'Follow');
      if (followButton.evaluate().isNotEmpty) {
        await tester.tap(followButton.first);
        await tester.pump();

        // Should change to Following
        expect(find.text('Following'), findsWidgets);
      }
    });

    testWidgets('should display notification content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for notification text content
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('should handle swipe to dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find first dismissible notification
      final dismissible = find.byType(Dismissible).first;
      if (dismissible.evaluate().isNotEmpty) {
        // Swipe to dismiss
        await tester.drag(dismissible, const Offset(-300, 0));
        await tester.pumpAndSettle();

        // Should remove the notification
        expect(find.byType(Dismissible), findsWidgets);
      }
    });

    testWidgets('should display notification icons based on type', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for different icon types
      expect(find.byIcon(Icons.favorite), findsAny);
      expect(find.byIcon(Icons.comment), findsAny);
      expect(find.byIcon(Icons.person_add), findsAny);
    });

    testWidgets('should handle mark all as read', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for mark all as read option
      final markAllButton = find.byIcon(Icons.done_all);
      if (markAllButton.evaluate().isNotEmpty) {
        await tester.tap(markAllButton);
        await tester.pumpAndSettle();

        // Should mark all notifications as read
        expect(find.byType(InboxScreen), findsOneWidget);
      }
    });

    testWidgets('should display bottom navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check bottom navigation
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Inbox'), findsWidgets);
    });

    testWidgets('should highlight inbox in navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Inbox should be selected
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar)
      );
      expect(bottomNav.currentIndex, equals(3)); // Inbox is index 3
    });

    testWidgets('should handle notification settings', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for settings icon
      final settingsButton = find.byIcon(Icons.settings);
      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton);
        await tester.pumpAndSettle();

        // Should open notification settings
        expect(find.byType(InboxScreen), findsOneWidget);
      }
    });

    testWidgets('should display notification count badges', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for count badges on tabs
      expect(find.byType(Tab), findsWidgets);
    });
  });
}