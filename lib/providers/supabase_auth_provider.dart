import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_auth_service.dart';

// Auth Service Provider
final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  return SupabaseAuthService();
});

// 현재 사용자 Provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(supabaseAuthServiceProvider);
  return authService.authStateChanges.map((state) => state.session?.user);
});

// 인증 상태 Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(supabaseAuthServiceProvider);
  return authService.authStateChanges;
});

// 세션 Provider
final sessionProvider = Provider<Session?>((ref) {
  final authService = ref.watch(supabaseAuthServiceProvider);
  return authService.currentSession;
});

// 로그인 상태 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  final session = ref.watch(sessionProvider);
  return session != null;
});