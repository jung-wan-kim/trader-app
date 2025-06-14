import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trader_app/main.dart';
import 'helpers/test_helper.dart';
import 'helpers/mock_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() async {
    // Mock SharedPreferences for tests
    SharedPreferences.setMockInitialValues({});
    
    // Initialize Supabase for tests with mock storage
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      anonKey: 'test-anon-key',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );
  });
  
  testWidgets('Simple app launch test', (WidgetTester tester) async {
    // Setup test helper
    final helper = TestHelper(tester);
    
    // Setup test environment
    await helper.setupTestEnvironment(
      locale: 'ko',
      isFirstLaunch: false,
      isAuthenticated: true,
    );
    
    // Create provider container with mock overrides
    final container = ProviderContainer(
      overrides: MockProviders.getDefaultOverrides(),
    );
    
    // Launch the app
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    
    // Wait for the app to settle
    await tester.pumpAndSettle();
    
    // Verify the app launched successfully
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Clean up
    container.dispose();
  });
}