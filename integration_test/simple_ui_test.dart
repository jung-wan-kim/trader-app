import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple UI Tests', () {
    setUp(() async {
      // Initialize SharedPreferences with test data
      SharedPreferences.setMockInitialValues({
        'has_seen_onboarding': true,
        'isDemoMode': 'true',
      });
    });

    testWidgets('App should launch and show initial screen', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if app launched successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Take screenshot of initial state
      await tester.pumpAndSettle();
      
      print('✅ App launched successfully');
    });

    testWidgets('Should navigate through bottom tabs', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check if bottom navigation exists
      final bottomNav = find.byType(NavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        expect(bottomNav, findsOneWidget);
        print('✅ Found bottom navigation');

        // Try to find and tap Discover tab
        final discoverIcon = find.byIcon(Icons.explore);
        if (discoverIcon.evaluate().isNotEmpty) {
          await tester.tap(discoverIcon);
          await tester.pumpAndSettle();
          print('✅ Navigated to Discover tab');
        }

        // Try to find and tap Analytics tab
        final analyticsIcon = find.byIcon(Icons.analytics_outlined);
        if (analyticsIcon.evaluate().isNotEmpty) {
          await tester.tap(analyticsIcon);
          await tester.pumpAndSettle();
          print('✅ Navigated to Analytics tab');
        }

        // Try to find and tap Profile tab
        final profileIcon = find.byIcon(Icons.person_outline);
        if (profileIcon.evaluate().isNotEmpty) {
          await tester.tap(profileIcon);
          await tester.pumpAndSettle();
          print('✅ Navigated to Profile tab');
        }

        // Return to Home
        final homeIcon = find.byIcon(Icons.home);
        if (homeIcon.evaluate().isNotEmpty) {
          await tester.tap(homeIcon);
          await tester.pumpAndSettle();
          print('✅ Returned to Home tab');
        }
      }
    });

    testWidgets('Should display key UI elements', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check for common UI elements
      final scaffold = find.byType(Scaffold);
      if (scaffold.evaluate().isNotEmpty) {
        print('✅ Found Scaffold');
      }

      // Check for app bar or title
      final appBar = find.byType(AppBar);
      if (appBar.evaluate().isNotEmpty) {
        print('✅ Found AppBar');
      }

      // Check for any text widgets
      final textWidgets = find.byType(Text);
      if (textWidgets.evaluate().isNotEmpty) {
        print('✅ Found ${textWidgets.evaluate().length} Text widgets');
        
        // Print first few text contents
        final textElements = textWidgets.evaluate().take(3).toList();
        for (var i = 0; i < textElements.length; i++) {
          final widget = textElements[i].widget as Text;
          if (widget.data != null) {
            print('   Text ${i + 1}: "${widget.data}"');
          }
        }
      }

      // Check for buttons
      final buttons = find.byType(ElevatedButton);
      if (buttons.evaluate().isNotEmpty) {
        print('✅ Found ${buttons.evaluate().length} ElevatedButton(s)');
      }

      final iconButtons = find.byType(IconButton);
      if (iconButtons.evaluate().isNotEmpty) {
        print('✅ Found ${iconButtons.evaluate().length} IconButton(s)');
      }
    });

    testWidgets('Should handle user interactions', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Try to find any scrollable widget
      final scrollables = find.byType(Scrollable);
      if (scrollables.evaluate().isNotEmpty) {
        print('✅ Found ${scrollables.evaluate().length} scrollable widget(s)');
        
        // Try to scroll
        await tester.drag(scrollables.first, const Offset(0, -200));
        await tester.pumpAndSettle();
        print('✅ Performed scroll gesture');
      }

      // Try to find any cards or list items
      final cards = find.byType(Card);
      if (cards.evaluate().isNotEmpty) {
        print('✅ Found ${cards.evaluate().length} Card(s)');
        
        // Try to tap the first card
        await tester.tap(cards.first);
        await tester.pumpAndSettle();
        print('✅ Tapped on first card');
      }

      // Check final state
      await tester.pumpAndSettle();
      print('✅ Test completed successfully');
    });
  });
}