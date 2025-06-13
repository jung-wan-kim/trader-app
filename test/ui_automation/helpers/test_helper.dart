import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TestHelper {
  final WidgetTester tester;
  
  TestHelper(this.tester);
  
  Future<void> setupTestEnvironment({
    String locale = 'ko',
    bool isFirstLaunch = false,
    bool isAuthenticated = false,
  }) async {
    SharedPreferences.setMockInitialValues({
      'is_first_launch': isFirstLaunch,
      'selected_language': locale,
      'auth_token': isAuthenticated ? 'test_token' : null,
      'user_id': isAuthenticated ? 'test_user_123' : null,
    });
  }
  
  void verifyCurrentRoute(String expectedRoute) {
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    expect(navigator.widget.pages.last.name, expectedRoute);
  }
  
  Future<void> setDeviceSize(Size size) async {
    await tester.binding.setSurfaceSize(size);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
  }
  
  Future<void> setDarkMode(bool isDark) async {
    tester.platformDispatcher.platformBrightnessTestValue = 
        isDark ? Brightness.dark : Brightness.light;
  }
  
  Future<void> simulateNetworkError() async {
    // Mock network error by overriding providers
  }
  
  Future<void> simulateSlowNetwork() async {
    // Add network delay simulation
  }
  
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  Future<void> mockAuthentication({
    required String userId,
    required String token,
    String? subscriptionTier,
  }) async {
    SharedPreferences.setMockInitialValues({
      'auth_token': token,
      'user_id': userId,
      'subscription_tier': subscriptionTier ?? 'basic',
      'subscription_expires': DateTime.now()
          .add(const Duration(days: 30))
          .toIso8601String(),
    });
  }
  
  Future<void> waitForSnackBar() async {
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }
  
  void verifySnackBarText(String text) {
    expect(find.descendant(
      of: find.byType(SnackBar),
      matching: find.text(text),
    ), findsOneWidget);
  }
  
  Future<void> dismissSnackBar() async {
    await tester.drag(find.byType(SnackBar), const Offset(0, 100));
    await tester.pumpAndSettle();
  }
  
  Future<void> navigateBack() async {
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();
  }
  
  Future<void> scrollToBottom() async {
    final scrollable = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.text(''), // Dummy finder
      500,
      scrollable: scrollable,
      maxScrolls: 50,
    );
  }
  
  Future<void> pullToRefresh() async {
    await tester.drag(
      find.byType(RefreshIndicator),
      const Offset(0, 300),
    );
    await tester.pumpAndSettle();
  }
}