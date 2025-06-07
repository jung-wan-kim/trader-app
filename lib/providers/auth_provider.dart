import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Auth 서비스 Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 현재 사용자 Provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// 인증 상태 Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  late final AuthService _authService;

  AuthStateNotifier(this._ref) : super(AuthState(status: AuthStatus.initial)) {
    _authService = _ref.read(authServiceProvider);
    _init();
  }

  void _init() {
    // 인증 상태 변경 감지
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
        );
      }
    });
  }

  // Google 로그인
  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    try {
      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: userCredential.user,
        );
      } else {
        // 사용자가 로그인 취소
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    try {
      await _authService.signOut();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    try {
      await _authService.deleteAccount();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}