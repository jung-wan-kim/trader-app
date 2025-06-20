import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Google 로그인
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.trader_app://login-callback',
        scopes: 'email profile',
      );
      
      return true;
    } catch (e) {
      print('Google 로그인 에러: $e');
      return false;
    }
  }
  
  // 이메일 로그인
  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('이메일 로그인 에러: $e');
      return null;
    }
  }
  
  // 이메일 회원가입
  Future<AuthResponse?> signUpWithEmail(String email, String password, String name) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      
      // 사용자 프로필 생성
      if (response.user != null) {
        await _supabase.from('user_profiles').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': name,
          'created_at': DateTime.now().toIso8601String(),
          'subscription_tier': 'free',
        });
      }
      
      return response;
    } catch (e) {
      print('이메일 회원가입 에러: $e');
      rethrow;
    }
  }
  
  // 로그아웃
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print('로그아웃 에러: $e');
    }
  }
  
  // 현재 세션 가져오기
  Session? get currentSession => _supabase.auth.currentSession;
  
  // 현재 사용자 가져오기
  User? get currentUser => _supabase.auth.currentUser;
  
  // 인증 상태 스트림
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}