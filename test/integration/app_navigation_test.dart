import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';
import 'package:trader_app/screens/main_screen.dart';
import 'package:trader_app/screens/home_screen.dart';
import 'package:trader_app/screens/discover_screen.dart';
import 'package:trader_app/screens/position_screen.dart';
import 'package:trader_app/screens/profile_screen.dart';

void main() {
  group('App Navigation Integration Tests', () {
    Widget createTestApp() {
      return const ProviderScope(
        child: TraderApp(),
      );
    }

    testWidgets('should navigate between main screens using bottom navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Initially should show Home screen
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Find bottom navigation bar
      final bottomNav = find.byType(NavigationBar);
      expect(bottomNav, findsOneWidget);

      // Navigate to Discover screen
      final discoverIcon = find.byIcon(Icons.explore_outlined);
      expect(discoverIcon, findsOneWidget);
      await tester.tap(discoverIcon);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Position screen
      final positionIcon = find.byIcon(Icons.analytics_outlined);
      expect(positionIcon, findsOneWidget);
      await tester.tap(positionIcon);
      await tester.pumpAndSettle();
      expect(find.byType(PositionScreen), findsOneWidget);

      // Navigate to Profile screen
      final profileIcon = find.byIcon(Icons.person_outline);
      expect(profileIcon, findsOneWidget);
      await tester.tap(profileIcon);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Navigate back to Home screen
      final homeIcon = find.byIcon(Icons.home_outlined);
      expect(homeIcon, findsOneWidget);
      await tester.tap(homeIcon);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should maintain state when switching between screens', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Start at Home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Discover screen
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate back to Home - should maintain previous state
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should show selected state in bottom navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Initially Home should be selected
      final NavigationBar navBar = tester.widget(find.byType(NavigationBar));
      expect(navBar.selectedIndex, equals(0));

      // Navigate to Discover
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();
      final NavigationBar navBar2 = tester.widget(find.byType(NavigationBar));
      expect(navBar2.selectedIndex, equals(1));

      // Navigate to Position
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();
      final NavigationBar navBar3 = tester.widget(find.byType(NavigationBar));
      expect(navBar3.selectedIndex, equals(2));

      // Navigate to Profile
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      final NavigationBar navBar4 = tester.widget(find.byType(NavigationBar));
      expect(navBar4.selectedIndex, equals(3));
    });

    testWidgets('should handle rapid navigation taps gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Rapidly tap different navigation items
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();

      // Should end up at Home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should show correct icons for selected/unselected states', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Initially home is selected, should show filled icon
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsNothing);

      // Navigate to Discover
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();

      // Discover should show filled icon, Home should show outlined
      expect(find.byIcon(Icons.explore), findsOneWidget);
      expect(find.byIcon(Icons.explore_outlined), findsNothing);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home), findsNothing);
    });
  });
}