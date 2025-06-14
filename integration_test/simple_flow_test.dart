import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/language_selection_screen.dart';
import 'package:trader_app/screens/onboarding_screen.dart';
import 'package:trader_app/screens/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Simple navigation flow test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Build just the language selection screen
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const LanguageSelectionScreen(),
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Verify we see language options
    expect(find.text('English'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
    
    // Tap Korean
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();
    
    // Tap Continue
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    
    // Should navigate to onboarding
    expect(find.byType(OnboardingScreen), findsOneWidget);
    
    // Find start button (might be in Korean)
    final startButton = find.text('시작하기');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();
      
      // Should navigate to login
      expect(find.byType(LoginScreen), findsOneWidget);
    }
  });
}