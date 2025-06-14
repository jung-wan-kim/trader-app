import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/language_selection_screen.dart';
import 'package:trader_app/screens/onboarding_screen.dart';
import 'package:trader_app/screens/login_screen.dart';
import 'package:trader_app/screens/main_screen.dart';
import 'package:trader_app/screens/splash_screen.dart';
import 'package:trader_app/providers/language_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trader_app/generated/l10n/app_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Integration Tests', () {
    setUpAll(() async {
      // Initialize test environment
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });
    
    setUp(() async {
      // Reset SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Complete app flow from language selection to main screen', 
        (WidgetTester tester) async {
      // Build the app with test configuration
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            title: 'Trader App',
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageNotifier.supportedLocales,
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.black,
              scaffoldBackgroundColor: Colors.black,
            ),
            home: const SplashScreen(),
          ),
        ),
      );

      // Wait for initial render
      await tester.pumpAndSettle();

      // Verify splash screen
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('Trader App'), findsOneWidget);

      // Wait for splash screen to complete (3 seconds)
      await tester.pump(const Duration(seconds: 3, milliseconds: 500));
      await tester.pumpAndSettle();

      // Now should see language selection
      expect(find.byType(LanguageSelectionScreen), findsOneWidget);
      
      // Verify all language options are visible
      expect(find.text('English'), findsOneWidget);
      expect(find.text('한국어'), findsOneWidget);
      expect(find.text('中文简体'), findsOneWidget);
      expect(find.text('日本語'), findsOneWidget);
      
      // Select Korean
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      // Tap Continue
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      
      // Should now see onboarding screen
      expect(find.byType(OnboardingScreen), findsOneWidget);
      
      // Find and tap start button (in Korean)
      final startButton = find.text('시작하기');
      expect(startButton, findsOneWidget);
      await tester.tap(startButton);
      await tester.pumpAndSettle();
      
      // Should now see login screen
      expect(find.byType(LoginScreen), findsOneWidget);
      
      // Find and tap demo button
      final demoButton = find.text('Continue with Demo');
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle();
      
      // Should now see main screen
      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Language selection persists across app restarts', 
        (WidgetTester tester) async {
      // First run - select language
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const LanguageSelectionScreen(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageNotifier.supportedLocales,
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Select Japanese
      await tester.tap(find.text('日本語'));
      await tester.pumpAndSettle();
      
      // Tap Continue
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      
      // Simulate app restart
      await tester.pumpWidget(Container()); // Clear widget tree
      await tester.pumpAndSettle();
      
      // Mock SharedPreferences with saved language
      SharedPreferences.setMockInitialValues({
        'selectedLanguage': 'ja',
        'hasSeenOnboarding': false,
      });
      
      // Rebuild app
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SplashScreen(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageNotifier.supportedLocales,
          ),
        ),
      );
      
      // Wait for splash
      await tester.pump(const Duration(seconds: 3, milliseconds: 500));
      await tester.pumpAndSettle();
      
      // Should go directly to onboarding (not language selection)
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(LanguageSelectionScreen), findsNothing);
    });
  });
}