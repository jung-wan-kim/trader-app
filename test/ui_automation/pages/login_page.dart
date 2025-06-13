import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class LoginPage extends BasePage {
  LoginPage(WidgetTester tester) : super(tester);
  
  // Locators
  final emailField = find.byKey(const Key('email_field'));
  final passwordField = find.byKey(const Key('password_field'));
  final loginButton = find.byKey(const Key('login_button'));
  final signUpButton = find.byKey(const Key('signup_button'));
  final forgotPasswordButton = find.byKey(const Key('forgot_password_button'));
  final googleLoginButton = find.byKey(const Key('google_login_button'));
  final appleLoginButton = find.byKey(const Key('apple_login_button'));
  final kakaoLoginButton = find.byKey(const Key('kakao_login_button'));
  final showPasswordButton = find.byKey(const Key('show_password_button'));
  final rememberMeCheckbox = find.byKey(const Key('remember_me_checkbox'));
  final backButton = find.byIcon(Icons.arrow_back);
  
  // Error message locators
  final emailError = find.byKey(const Key('email_error'));
  final passwordError = find.byKey(const Key('password_error'));
  final generalError = find.byKey(const Key('general_error'));
  
  // Actions
  Future<void> enterEmail(String email) async {
    await tap(emailField);
    await enterText(emailField, email);
  }
  
  Future<void> enterPassword(String password) async {
    await tap(passwordField);
    await enterText(passwordField, password);
  }
  
  Future<void> tapLogin() async {
    await tap(loginButton);
  }
  
  Future<void> tapSignUp() async {
    await tap(signUpButton);
  }
  
  Future<void> tapForgotPassword() async {
    await tap(forgotPasswordButton);
  }
  
  Future<void> tapGoogleLogin() async {
    await tap(googleLoginButton);
  }
  
  Future<void> tapAppleLogin() async {
    await tap(appleLoginButton);
  }
  
  Future<void> tapKakaoLogin() async {
    await tap(kakaoLoginButton);
  }
  
  Future<void> togglePasswordVisibility() async {
    await tap(showPasswordButton);
  }
  
  Future<void> toggleRememberMe() async {
    await tap(rememberMeCheckbox);
  }
  
  Future<void> login(String email, String password) async {
    await enterEmail(email);
    await enterPassword(password);
    await tapLogin();
  }
  
  Future<void> clearFields() async {
    await tap(emailField);
    await tester.enterText(emailField, '');
    await tap(passwordField);
    await tester.enterText(passwordField, '');
  }
  
  // Assertions
  void verifyLoginButtonEnabled() {
    final button = tester.widget<ElevatedButton>(loginButton);
    expect(button.enabled, true);
  }
  
  void verifyLoginButtonDisabled() {
    final button = tester.widget<ElevatedButton>(loginButton);
    expect(button.enabled, false);
  }
  
  void verifyEmailError(String error) {
    expect(find.text(error), findsOneWidget);
  }
  
  void verifyPasswordError(String error) {
    expect(find.text(error), findsOneWidget);
  }
  
  void verifyGeneralError(String error) {
    expect(find.text(error), findsOneWidget);
  }
  
  void verifyPasswordVisible() {
    final TextField textField = tester.widget(passwordField);
    expect(textField.obscureText, false);
  }
  
  void verifyPasswordHidden() {
    final TextField textField = tester.widget(passwordField);
    expect(textField.obscureText, true);
  }
  
  void verifyRememberMeChecked() {
    final Checkbox checkbox = tester.widget(rememberMeCheckbox);
    expect(checkbox.value, true);
  }
  
  void verifyRememberMeUnchecked() {
    final Checkbox checkbox = tester.widget(rememberMeCheckbox);
    expect(checkbox.value, false);
  }
  
  void verifySocialLoginButtonsVisible() {
    expect(googleLoginButton, findsOneWidget);
    expect(appleLoginButton, findsOneWidget);
    expect(kakaoLoginButton, findsOneWidget);
  }
  
  void verifyLoadingState() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verifyLoginButtonDisabled();
  }
}