import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';
import 'package:trader_app/screens/main_screen.dart';

void main() {
  group('TraderApp Main Screen Tests', () {
    testWidgets('should display TraderApp with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );

      // Verify app launches successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(MainScreen), findsOneWidget);
    });

    testWidgets('should have dark theme configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.brightness, equals(Brightness.dark));
      expect(app.theme?.primaryColor, equals(Colors.black));
      expect(app.theme?.scaffoldBackgroundColor, equals(Colors.black));
    });

    testWidgets('should have correct color scheme', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      final colorScheme = app.theme?.colorScheme;
      
      expect(colorScheme?.primary, equals(Colors.white));
      expect(colorScheme?.secondary, equals(const Color(0xFF00D632))); // Green for up
      expect(colorScheme?.tertiary, equals(const Color(0xFFFF3B30))); // Red for down
    });

    testWidgets('should not show debug banner', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, isFalse);
    });
  });
}
