import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/main.dart';
import '../helpers/test_helper.dart';
import '../helpers/mock_providers.dart';

abstract class BaseUITest {
  late WidgetTester tester;
  late TestHelper helper;
  late ProviderContainer container;
  
  Future<void> setup(WidgetTester widgetTester) async {
    tester = widgetTester;
    helper = TestHelper(tester);
    container = ProviderContainer(
      overrides: MockProviders.getDefaultOverrides(),
    );
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
        child: const TraderApp(),
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
    test(testName, () async {
      await setup(tester);
      try {
        await testBody();
      } finally {
        await teardown();
      }
    });
  }
}