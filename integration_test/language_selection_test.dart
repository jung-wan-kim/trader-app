import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trader_app/main.dart' as app;
import 'package:trader_app/screens/language_selection_screen.dart';
import 'package:trader_app/screens/onboarding_screen.dart';
import 'package:trader_app/screens/login_screen.dart';
import 'package:trader_app/screens/main_screen.dart';
import 'package:trader_app/screens/splash_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() async {
    // Clear SharedPreferences before tests
    SharedPreferences.setMockInitialValues({});
  });

  group('Language Selection and Navigation Tests', () {
    testWidgets('Should show language selection screen on first launch', 
        (WidgetTester tester) async {
      // Clear preferences for this test
      SharedPreferences.setMockInitialValues({});
      
      // Launch the app
      app.main();
      await tester.pump();
      
      // Wait for splash screen
      expect(find.byType(SplashScreen), findsOneWidget);
      
      // Wait for splash screen duration (3 seconds) plus navigation
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Should show language selection screen
      expect(find.byType(LanguageSelectionScreen), findsOneWidget);
      
      // Should show language options
      expect(find.text('English'), findsOneWidget);
      expect(find.text('한국어'), findsOneWidget);
      expect(find.text('中文简体'), findsOneWidget);
      expect(find.text('日本語'), findsOneWidget);
      
      // Should show Continue button
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('Should navigate through onboarding flow', 
        (WidgetTester tester) async {
      // Clear preferences for this test
      SharedPreferences.setMockInitialValues({});
      
      app.main();
      await tester.pump();
      
      // Wait for splash screen and navigation
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Select Korean language
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      // Tap Continue button
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      
      // Should show onboarding screen
      expect(find.byType(OnboardingScreen), findsOneWidget);
      
      // Look for Start button (might be in Korean now)
      final startButton = find.text('시작하기').evaluate().isEmpty 
          ? find.text('Start') 
          : find.text('시작하기');
      
      expect(startButton, findsOneWidget);
      
      // Tap Start button
      await tester.tap(startButton);
      await tester.pumpAndSettle();
      
      // Should show login screen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Should complete demo login flow', 
        (WidgetTester tester) async {
      // Clear preferences for this test
      SharedPreferences.setMockInitialValues({});
      
      app.main();
      await tester.pump();
      
      // Wait for splash screen and navigation
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Quick navigation to login
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      
      // Skip onboarding if present
      final startButton = find.text('Start');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();
      }
      
      // On login screen, look for demo button
      final demoButton = find.text('Continue with Demo');
      expect(demoButton, findsOneWidget);
      
      // Tap demo button
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      
      // Should navigate to main screen
      expect(find.byType(MainScreen), findsOneWidget);
      
      // Should show bottom navigation
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Should change language and update UI', 
        (WidgetTester tester) async {
      // Clear preferences for this test
      SharedPreferences.setMockInitialValues({});
      
      app.main();
      await tester.pump();
      
      // Wait for splash screen and navigation
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Select different languages and verify UI updates
      final languages = [
        {'lang': '한국어', 'continue': 'Continue'},
        {'lang': '中文简体', 'continue': 'Continue'},
        {'lang': '日本語', 'continue': 'Continue'},
        {'lang': 'English', 'continue': 'Continue'},
      ];
      
      for (final langData in languages) {
        await tester.tap(find.text(langData['lang']!));
        await tester.pumpAndSettle();
        
        // Continue button should still be visible
        expect(find.text(langData['continue']!), findsOneWidget);
      }
    });

    testWidgets('Should handle rapid language selection', 
        (WidgetTester tester) async {
      // Clear preferences for this test
      SharedPreferences.setMockInitialValues({});
      
      app.main();
      await tester.pump();
      
      // Wait for splash screen and navigation
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Rapidly tap different languages
      await tester.tap(find.text('한국어'));
      await tester.pump();
      await tester.tap(find.text('中文简体'));
      await tester.pump();
      await tester.tap(find.text('日本語'));
      await tester.pump();
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      
      // App should not crash
      expect(find.byType(LanguageSelectionScreen), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}