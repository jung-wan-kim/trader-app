import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart' as app;
import 'package:trader_app/screens/home_screen.dart';
import 'package:trader_app/screens/discover_screen.dart';
import 'package:trader_app/screens/position_screen.dart';
import 'package:trader_app/screens/inbox_screen.dart';
import 'package:trader_app/screens/profile_screen.dart';
import 'package:trader_app/widgets/recommendation_card.dart';
import 'package:trader_app/widgets/position_size_calculator.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Launch Tests', () {
    testWidgets('App should launch without crashing', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify app launches and shows the main screen
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ProviderScope), findsOneWidget);
    });

    testWidgets('All screens should render properly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test Home Screen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(RecommendationCard), findsWidgets);
      
      // Navigate to Discover Screen
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Position Screen
      await tester.tap(find.byIcon(Icons.add_box_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(PositionScreen), findsOneWidget);
      expect(find.byType(PositionSizeCalculator), findsOneWidget);

      // Navigate to Inbox Screen
      await tester.tap(find.byIcon(Icons.inbox));
      await tester.pumpAndSettle();
      expect(find.byType(InboxScreen), findsOneWidget);

      // Navigate to Profile Screen
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Navigation should work correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test bottom navigation
      final bottomNav = find.byType(BottomNavigationBar);
      expect(bottomNav, findsOneWidget);

      // Count navigation items
      final navItems = find.descendant(
        of: bottomNav,
        matching: find.byType(BottomNavigationBarItem),
      );
      expect(navItems, findsNWidgets(5));
    });

    testWidgets('Providers should initialize correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for providers to load
      await tester.pump(const Duration(seconds: 1));
      
      // Verify recommendations are loaded (by checking if recommendation cards exist)
      expect(find.byType(RecommendationCard), findsWidgets);
    });

    testWidgets('App should handle scrolling on home screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find scrollable widget
      final scrollable = find.byType(Scrollable).first;
      
      // Perform scroll
      await tester.drag(scrollable, const Offset(0, -500));
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('App should display loading states properly', (WidgetTester tester) async {
      app.main();
      await tester.pump(); // Don't wait for animations

      // Should show some loading indicator initially
      expect(
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
        find.text('Loading...').evaluate().isNotEmpty,
        isTrue,
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Loading indicators should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('App should maintain state during navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate away from home
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();

      // Navigate back to home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Home screen should still have data
      expect(find.byType(RecommendationCard), findsWidgets);
    });

    testWidgets('App should handle rapid navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Rapidly tap different navigation items
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_box_outlined));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.inbox));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // App should not crash and should be on home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('App should handle device orientation changes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Change to landscape
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle();

      // Verify app still works
      expect(find.byType(MaterialApp), findsOneWidget);

      // Change back to portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();

      // Verify app still works
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have proper theme', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get MaterialApp
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      
      // Verify theme is set
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('App should handle provider errors gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Even if providers have errors, app should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should show error messages when appropriate', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to different screens to check for error handling
      final screens = [
        Icons.explore,
        Icons.add_box_outlined,
        Icons.inbox,
        Icons.person_outline,
      ];

      for (final icon in screens) {
        await tester.tap(find.byIcon(icon));
        await tester.pumpAndSettle();
        
        // Should not show any unexpected error widgets
        expect(find.byType(ErrorWidget), findsNothing);
      }
    });
  });

  group('Performance Tests', () {
    testWidgets('App should launch within reasonable time', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // App should launch within 5 seconds
      expect(stopwatch.elapsed.inSeconds, lessThan(5));
    });

    testWidgets('Navigation should be responsive', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();
      
      // Navigate to a different screen
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // Navigation should complete within 1 second
      expect(stopwatch.elapsed.inMilliseconds, lessThan(1000));
    });
  });
}