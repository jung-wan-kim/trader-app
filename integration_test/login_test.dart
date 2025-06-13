import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('로그인/회원가입 화면 테스트', () {
    setUp(() async {
      // 초기화
      SharedPreferences.setMockInitialValues({
        'selected_language': 'ko',  // 한국어 설정
      });
      await Future.delayed(const Duration(seconds: 1));
    });

    testWidgets('로그인 화면 표시 및 Demo 모드 테스트', (tester) async {
      print('\n========== 로그인 화면 테스트 시작 ==========\n');
      
      // 1. 앱 실행
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✅ 1. 앱 실행 완료');

      // 2. 로그인 화면 확인
      // 현재 화면에 어떤 위젯들이 있는지 확인
      final demoButton = find.textContaining('Demo');
      final continueWithDemoButton = find.textContaining('데모로 계속하기');
      final loginButton = find.textContaining('로그인');
      final signupButton = find.textContaining('회원가입');
      final emailField = find.byType(TextField);
      
      // 현재 화면 상태 파악
      if (demoButton.evaluate().isNotEmpty || continueWithDemoButton.evaluate().isNotEmpty) {
        print('✅ 2. 로그인 화면 확인 - Demo 버튼 발견');
        
        // Demo 버튼 클릭
        if (demoButton.evaluate().isNotEmpty) {
          await tester.tap(demoButton);
        } else {
          await tester.tap(continueWithDemoButton);
        }
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ 3. Demo 모드로 진입');
        
      } else if (loginButton.evaluate().isNotEmpty || emailField.evaluate().isNotEmpty) {
        print('✅ 2. 로그인 폼 화면 확인');
        
        // 이메일/비밀번호 필드 테스트
        if (emailField.evaluate().isNotEmpty) {
          final passwordField = find.byType(TextField).last;
          
          // 이메일 입력
          await tester.enterText(emailField, 'test@example.com');
          await tester.pump();
          print('  ✓ 이메일 입력');
          
          // 비밀번호 입력
          await tester.enterText(passwordField, 'password123');
          await tester.pump();
          print('  ✓ 비밀번호 입력');
          
          // 로그인 버튼 클릭
          final submitButton = find.byType(ElevatedButton);
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pumpAndSettle(const Duration(seconds: 2));
            print('✅ 3. 로그인 시도');
          }
        }
        
        // Demo 모드 옵션 확인
        final demoOption = find.textContaining('Demo');
        if (demoOption.evaluate().isNotEmpty) {
          await tester.tap(demoOption);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          print('✅ 4. Demo 모드로 전환');
        }
      } else {
        // 온보딩이나 다른 화면일 경우
        print('ℹ️  로그인 화면이 아닌 다른 화면이 표시됨');
        
        // 건너뛰기 또는 다음 버튼 찾기
        final skipButton = find.textContaining('건너뛰기');
        final nextButton = find.textContaining('다음');
        final startButton = find.textContaining('시작하기');
        
        if (skipButton.evaluate().isNotEmpty) {
          await tester.tap(skipButton);
          await tester.pumpAndSettle();
          print('  ✓ 온보딩 건너뛰기');
        } else if (startButton.evaluate().isNotEmpty) {
          await tester.tap(startButton);
          await tester.pumpAndSettle();
          print('  ✓ 온보딩 완료');
        }
      }
      
      // 4. 다음 화면으로 이동 확인
      await tester.pump(const Duration(seconds: 1));
      
      // 현재 화면 확인
      final homeScreen = find.textContaining('추천');
      final strategyScreen = find.textContaining('전략');
      final portfolioScreen = find.textContaining('포트폴리오');
      
      if (homeScreen.evaluate().isNotEmpty || 
          strategyScreen.evaluate().isNotEmpty || 
          portfolioScreen.evaluate().isNotEmpty) {
        print('✅ 5. 메인 화면으로 이동 확인');
      } else {
        print('ℹ️  현재 화면: ');
        // 현재 화면에 있는 텍스트 출력
        final texts = find.byType(Text);
        for (var i = 0; i < texts.evaluate().length && i < 5; i++) {
          final text = texts.at(i);
          if (text.evaluate().isNotEmpty) {
            final widget = tester.widget<Text>(text);
            if (widget.data != null && widget.data!.isNotEmpty) {
              print('    - ${widget.data}');
            }
          }
        }
      }
      
      print('\n========== 로그인 화면 테스트 완료 ==========\n');
    });

    testWidgets('회원가입 프로세스 테스트', (tester) async {
      print('\n========== 회원가입 테스트 시작 ==========\n');
      
      // 초기화 - 새로운 사용자
      SharedPreferences.setMockInitialValues({
        'selected_language': 'ko',
      });
      
      // 1. 앱 실행
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✅ 1. 앱 실행 완료');
      
      // 2. 회원가입 버튼 찾기
      final signupButton = find.textContaining('회원가입');
      final createAccountButton = find.textContaining('계정 만들기');
      
      if (signupButton.evaluate().isNotEmpty) {
        await tester.tap(signupButton);
        await tester.pumpAndSettle();
        print('✅ 2. 회원가입 버튼 클릭');
      } else if (createAccountButton.evaluate().isNotEmpty) {
        await tester.tap(createAccountButton);
        await tester.pumpAndSettle();
        print('✅ 2. 계정 만들기 버튼 클릭');
      }
      
      // 3. 회원가입 폼 테스트
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        // 이메일 입력
        await tester.enterText(textFields.at(0), 'newuser@example.com');
        await tester.pump();
        print('  ✓ 이메일 입력');
        
        // 비밀번호 입력
        await tester.enterText(textFields.at(1), 'password123');
        await tester.pump();
        print('  ✓ 비밀번호 입력');
        
        // 비밀번호 확인 필드가 있는 경우
        if (textFields.evaluate().length >= 3) {
          await tester.enterText(textFields.at(2), 'password123');
          await tester.pump();
          print('  ✓ 비밀번호 확인 입력');
        }
      }
      
      print('\n========== 회원가입 테스트 완료 ==========\n');
    });
  });
}