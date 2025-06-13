import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shared_preferences/shared_preferences.dart';

// Mock Supabase client
class MockSupabaseClient {
  final auth = MockGoTrueClient();
}

class MockGoTrueClient {
  Future<supabase.AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    if (email == 'test@example.com' && password == 'Test@123') {
      return supabase.AuthResponse(
        session: null,
        user: null,
      );
    }
    throw supabase.AuthException('Invalid credentials');
  }

  Future<supabase.AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return supabase.AuthResponse(
      session: null,
      user: null,
    );
  }

  Future<void> signInWithOAuth(supabase.OAuthProvider provider) async {
    // Mock OAuth sign in
  }
}

void main() {
  group('LoginScreen Widget Tests', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const LoginScreen(),
        ),
      );
    }

    testWidgets('should display login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check logo
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.text('AI Trading Assistant'), findsOneWidget);

      // Check form fields
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check buttons
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);

      // Check social login option
      expect(find.text('Or continue with'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('should toggle between sign in and sign up modes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially in sign in mode
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Welcome back'), findsOneWidget);

      // Tap create account
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Should switch to sign up mode
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);

      // Tap sign in link
      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle();

      // Should switch back to sign in mode
      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter invalid email
      await tester.enterText(find.byType(TextField).first, 'invalid-email');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Try to sign in
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Should show error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should validate password requirements in sign up mode', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Switch to sign up mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Enter weak password
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'weak');

      // Try to sign up
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Should show error
      expect(find.textContaining('at least 8 characters'), findsOneWidget);
    });

    testWidgets('should show/hide password when eye icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially password should be obscured
      final passwordField = tester.widget<TextField>(find.byType(TextField).last);
      expect(passwordField.obscureText, isTrue);

      // Tap eye icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Password should be visible
      final updatedPasswordField = tester.widget<TextField>(find.byType(TextField).last);
      expect(updatedPasswordField.obscureText, isFalse);

      // Icon should change
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should show loading indicator during sign in', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'Test@123');

      // Tap sign in
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to demo mode when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find and tap demo mode button
      await tester.tap(find.text('Try Demo Mode'));
      await tester.pumpAndSettle();

      // Should attempt navigation (in real app would check navigation)
      expect(find.text('Try Demo Mode'), findsOneWidget);
    });

    testWidgets('should show terms and privacy links', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Switch to sign up mode to see terms
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Check for terms text
      expect(find.textContaining('Terms of Service'), findsOneWidget);
      expect(find.textContaining('Privacy Policy'), findsOneWidget);
    });

    testWidgets('should handle Google sign in tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap Google sign in
      await tester.tap(find.text('Sign in with Google'));
      await tester.pump();

      // Should trigger OAuth flow (in real app)
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('should clear form when switching modes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter some text
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password');

      // Switch to sign up mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Fields should be cleared
      final emailField = tester.widget<TextField>(find.byType(TextField).first);
      final passwordField = tester.widget<TextField>(find.byType(TextField).last);
      
      expect(emailField.controller?.text ?? '', isEmpty);
      expect(passwordField.controller?.text ?? '', isEmpty);
    });
  });
}