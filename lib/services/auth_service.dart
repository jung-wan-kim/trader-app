import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SupabaseClient _supabase = Supabase.instance.client;

  // 현재 사용자 가져오기
  User? get currentUser => _firebaseAuth.currentUser;

  // 인증 상태 변경 스트림
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Google 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google 로그인 플로우 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // 사용자가 로그인 취소
        return null;
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase 인증 자격 증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Supabase에도 사용자 정보 동기화
      await _syncUserToSupabase(userCredential.user!);

      return userCredential;
    } catch (e) {
      print('Google 로그인 오류: $e');
      rethrow;
    }
  }

  // Supabase에 사용자 정보 동기화
  Future<void> _syncUserToSupabase(User user) async {
    try {
      // Supabase auth 테이블에 사용자 정보 저장
      await _supabase.from('users').upsert({
        'id': user.uid,
        'email': user.email,
        'name': user.displayName,
        'photo_url': user.photoURL,
        'provider': 'google',
        'created_at': DateTime.now().toIso8601String(),
        'last_login': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
    } catch (e) {
      print('Supabase 동기화 오류: $e');
      // 동기화 실패해도 로그인은 진행
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('로그아웃 오류: $e');
      rethrow;
    }
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Supabase에서 사용자 데이터 삭제
        await _supabase.from('users').delete().eq('id', user.uid);
        
        // Firebase에서 계정 삭제
        await user.delete();
        
        // Google 로그아웃
        await _googleSignIn.signOut();
      }
    } catch (e) {
      print('계정 삭제 오류: $e');
      
      // 재인증이 필요한 경우
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        // 재인증 후 다시 시도
        final credential = await signInWithGoogle();
        if (credential != null) {
          await deleteAccount();
        }
      } else {
        rethrow;
      }
    }
  }

  // 사용자 정보 업데이트
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateProfile(
          displayName: displayName,
          photoURL: photoURL,
        );
        
        // Supabase에도 업데이트
        final updates = <String, dynamic>{};
        if (displayName != null) updates['name'] = displayName;
        if (photoURL != null) updates['photo_url'] = photoURL;
        
        if (updates.isNotEmpty) {
          await _supabase.from('users').update(updates).eq('id', user.uid);
        }
      }
    } catch (e) {
      print('프로필 업데이트 오류: $e');
      rethrow;
    }
  }
}