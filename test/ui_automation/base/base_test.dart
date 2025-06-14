import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trader_app/main.dart';
import '../helpers/test_helper.dart';
import '../helpers/mock_providers.dart';

class BaseUITest {
  late WidgetTester tester;
  late TestHelper helper;
  late ProviderContainer container;
  
  Future<void> setup(WidgetTester widgetTester) async {
    tester = widgetTester;
    helper = TestHelper(tester);
    container = ProviderContainer(
      overrides: MockProviders.getDefaultOverrides(),
    );
    
    // Initialize Supabase for testing if not already initialized
    try {
      Supabase.instance.client;
    } catch (e) {
      await Supabase.initialize(
        url: 'https://lgebgddeerpxdjvtqvoi.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxnZWJnZGRlZXJweGRqdnRxdm9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxOTc2MDksImV4cCI6MjA2NDc3MzYwOX0.NZxHOwzgRc-Vjw60XktU7L_hKiIMAW_5b_DHis6qKBE',
      );
    }
  }
  
  Future<void> teardown() async {
    container.dispose();
  }
  
  Future<void> launchApp({
    String locale = 'ko',
    bool isFirstLaunch = false,
    bool isAuthenticated = false,
  }) async {
    await helper.setupTestEnvironment(
      locale: locale,
      isFirstLaunch: isFirstLaunch,
      isAuthenticated: isAuthenticated,
    );
    
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    
    await tester.pumpAndSettle();
  }
  
  Future<void> restartApp() async {
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
    await launchApp();
  }
  
  void verifyCurrentScreen(String screenName) {
    helper.verifyCurrentRoute(screenName);
  }
  
  Future<void> waitForLoadingToComplete() async {
    while (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }
  
  Future<void> performTest(String testName, Future<void> Function() testBody) async {
    // performTest는 testWidgets 내부에서 호출되므로, 
    // 별도의 test 래퍼 없이 직접 실행
    try {
      await testBody();
    } catch (e) {
      // 에러 발생 시 재throw
      rethrow;
    }
  }
}