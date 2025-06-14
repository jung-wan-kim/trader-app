import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trader_app/main.dart' as app;
import 'package:trader_app/screens/language_selection_screen.dart';
import 'package:trader_app/screens/splash_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Simple UI flow test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Run the full app
    app.main();
    await tester.pump();
    
    // Initial pump to start animations
    await tester.pump();
    
    // Verify we start with splash screen
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Trader App'), findsOneWidget);
    
    // Wait for splash screen duration
    print('Waiting for splash screen...');
    await tester.pump(const Duration(seconds: 3, milliseconds: 500));
    await tester.pumpAndSettle();
    
    // Now we should see language selection screen
    print('Looking for language selection screen...');
    final languageScreen = find.byType(LanguageSelectionScreen);
    
    if (languageScreen.evaluate().isNotEmpty) {
      print('Found language selection screen!');
      
      // Look for language options
      final englishOption = find.text('English');
      final koreanOption = find.text('한국어');
      final chineseOption = find.text('中文简체');
      final japaneseOption = find.text('日本語');
      
      expect(englishOption, findsOneWidget);
      expect(koreanOption, findsOneWidget);
      expect(chineseOption, findsOneWidget);
      expect(japaneseOption, findsOneWidget);
      
      // Try tapping Korean
      print('Tapping Korean option...');
      await tester.tap(koreanOption);
      await tester.pumpAndSettle();
      
      // Look for Continue button
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      
      // Tap Continue
      print('Tapping Continue button...');
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      print('Test completed successfully!');
    } else {
      print('Language selection screen not found');
      
      // Debug: Print current widget tree
      final widgets = find.byType(Widget).evaluate();
      print('Current widgets on screen: ${widgets.length}');
      
      // Print specific widget types
      final materialApp = find.byType(MaterialApp);
      print('MaterialApp found: ${materialApp.evaluate().isNotEmpty}');
      
      final scaffold = find.byType(Scaffold);
      print('Scaffold found: ${scaffold.evaluate().isNotEmpty}');
    }
  });
}