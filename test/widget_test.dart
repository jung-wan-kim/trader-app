import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trader_app/main.dart';
import 'package:trader_app/screens/splash_screen.dart';

void main() {
  setUpAll(() {
    // SharedPreferences 모킹
    SharedPreferences.setMockInitialValues({});
  });

  group('TraderApp Main Screen Tests', () {
    testWidgets('should display splash screen on launch', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: TraderApp(),
          ),
        );

        // 스플래시 화면이 표시되는지 확인
        expect(find.byType(SplashScreen), findsOneWidget);
        expect(find.text('Trader App'), findsOneWidget);
        expect(find.byIcon(Icons.trending_up), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets('should apply dark theme', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: TraderApp(),
          ),
        );

        final MaterialApp app = tester.widget(find.byType(MaterialApp));
        expect(app.theme?.brightness, equals(Brightness.dark));
        expect(app.theme?.scaffoldBackgroundColor, equals(const Color(0xFF000000)));
      });
    });

    testWidgets('should have correct color scheme', (WidgetTester tester) async {
      await tester.runAsync(() async {
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
    });

    testWidgets('should not show debug banner', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: TraderApp(),
          ),
        );

        final MaterialApp app = tester.widget(find.byType(MaterialApp));
        expect(app.debugShowCheckedModeBanner, isFalse);
      });
    });
  });

  group('SplashScreen Timer Tests', () {
    testWidgets('should have timer for navigation', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: SplashScreen(),
            ),
          ),
        );

        // 스플래시 화면 표시 확인
        expect(find.byType(SplashScreen), findsOneWidget);
        expect(find.text('Trader App'), findsOneWidget);

        // 타이머가 시작되었는지 확인 (실제 대기는 하지 않음)
        await Future.delayed(const Duration(milliseconds: 100));
        await tester.pump();
        
        // 여전히 스플래시 화면에 있어야 함
        expect(find.byType(SplashScreen), findsOneWidget);
      });
    });
  });
}