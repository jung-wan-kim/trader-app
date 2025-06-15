import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trader_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app flow test - from start to finish', (WidgetTester tester) async {
    print('\n🚀 Starting full app flow test...\n');
    
    // Clear all preferences to simulate first launch
    SharedPreferences.setMockInitialValues({});
    
    // Launch the app
    print('📱 Launching app...');
    app.main();
    await tester.pumpAndSettle();
    
    // 1. Splash Screen
    print('\n[1/7] 🎬 Splash Screen');
    // Check for splash screen elements
    final splashElements = find.byType(CircularProgressIndicator);
    if (splashElements.evaluate().isNotEmpty) {
      print('✅ Splash screen displayed with loading indicator');
    } else {
      print('⚠️ Splash screen might have already passed');
    }
    
    // Wait for splash screen duration
    await tester.pump(const Duration(seconds: 3, milliseconds: 500));
    await tester.pumpAndSettle();
    
    // 2. Language Selection Screen
    print('\n[2/7] 🌐 Language Selection Screen');
    expect(find.text('Choose Your Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('한국어'), findsOneWidget);
    expect(find.text('中文简体'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
    print('✅ All language options visible');
    
    // Select Korean
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();
    print('✅ Selected Korean language');
    
    // Tap Continue
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    
    // 3. Onboarding Screen
    print('\n[3/7] 📚 Onboarding Screen');
    // Check for onboarding title - using contains for more flexible matching
    final onboardingTitle = find.textContaining('전설적 트레이더');
    expect(onboardingTitle, findsOneWidget);
    print('✅ Onboarding screen in Korean');
    
    // Wait a bit for animations
    await tester.pump(const Duration(milliseconds: 500));
    
    // Navigate through onboarding pages
    final nextButton = find.text('다음');
    if (nextButton.evaluate().isNotEmpty) {
      // Page 1 -> Page 2
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      
      // Page 2 -> Page 3
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      
      // Page 3 -> Page 4
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
    }
    
    // Now we should see the start button
    final startButton = find.text('시작하기');
    expect(startButton, findsOneWidget);
    print('✅ Reached final onboarding page');
    
    // Tap Start
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    
    // 4. Login Screen
    print('\n[4/7] 🔐 Login Screen');
    expect(find.text('로그인'), findsOneWidget);
    final demoButton = find.text('Continue with Demo');
    expect(demoButton, findsOneWidget);
    print('✅ Login screen with demo option');
    
    // Tap Demo
    await tester.tap(demoButton);
    await tester.pumpAndSettle();
    
    // 5. Main Screen - Home Tab
    print('\n[5/7] 🏠 Main Screen - Home Tab');
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Check bottom navigation items
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    expect(find.byIcon(Icons.add_box_outlined), findsOneWidget);
    expect(find.byIcon(Icons.pie_chart_outline), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    print('✅ Bottom navigation with 5 tabs');
    
    // Check home content
    expect(find.text('AI 추천'), findsOneWidget);
    print('✅ Home screen content loaded');
    
    // 6. Navigate through tabs
    print('\n[6/7] 📊 Testing Navigation');
    
    // Go to Strategy tab
    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();
    expect(find.text('전략'), findsOneWidget);
    print('✅ Strategy tab');
    
    // Go to Position tab
    await tester.tap(find.byIcon(Icons.add_box_outlined));
    await tester.pumpAndSettle();
    expect(find.text('포지션'), findsOneWidget);
    print('✅ Position tab');
    
    // Go to Performance tab
    await tester.tap(find.byIcon(Icons.pie_chart_outline));
    await tester.pumpAndSettle();
    expect(find.text('성과'), findsOneWidget);
    print('✅ Performance tab');
    
    // Go to Profile tab
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text('프로필'), findsOneWidget);
    print('✅ Profile tab');
    
    // 7. Test some interactions
    print('\n[7/7] 🎯 Testing Interactions');
    
    // Return to home
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    
    // Try scrolling
    final scrollable = find.byType(Scrollable).first;
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pumpAndSettle();
    print('✅ Scrolling works');
    
    // Final summary
    print('\n' + '='*50);
    print('🎉 FULL APP FLOW TEST COMPLETED SUCCESSFULLY! 🎉');
    print('='*50);
    print('\nTested features:');
    print('  ✅ App launch and splash screen');
    print('  ✅ Language selection (Korean)');
    print('  ✅ Onboarding screen');
    print('  ✅ Login with demo mode');
    print('  ✅ Main screen with bottom navigation');
    print('  ✅ All 5 tabs navigation');
    print('  ✅ Content display in Korean');
    print('  ✅ Scrolling functionality');
    print('\n🏆 All tests passed!');
  });
}