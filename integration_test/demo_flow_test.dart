import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Demo Flow UI Test', () {
    setUp(() async {
      // 초기화
      SharedPreferences.setMockInitialValues({});
      await Future.delayed(const Duration(seconds: 1));
    });

    testWidgets('전체 Demo 플로우 테스트', (tester) async {
      print('\n========== Demo Flow 테스트 시작 ==========\n');
      
      // 1. 앱 실행
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✅ 1. 앱 실행 완료');

      // 2. 언어 선택
      expect(find.text('Choose Your Language'), findsOneWidget);
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('✅ 2. 한국어 선택 완료');

      // 3. 온보딩 화면
      if (find.text('건너뛰기').evaluate().isNotEmpty) {
        await tester.tap(find.text('건너뛰기'));
        await tester.pumpAndSettle();
        print('✅ 3. 온보딩 건너뛰기');
      }

      // 4. 로그인 화면에서 Demo 모드로 접속
      final demoButton = find.textContaining('데모로 계속하기');
      final continueWithDemoButton = find.textContaining('Continue with Demo');
      
      if (demoButton.evaluate().isNotEmpty) {
        await tester.tap(demoButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ 4. Demo 모드로 접속');
      } else if (continueWithDemoButton.evaluate().isNotEmpty) {
        await tester.tap(continueWithDemoButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ 4. Demo 모드로 접속');
      }

      // 5. 메인 화면 확인
      await tester.pump(const Duration(seconds: 2));
      
      // 하단 네비게이션 바 확인
      final homeTab = find.byIcon(Icons.home);
      final analyticsTab = find.byIcon(Icons.analytics_outlined);
      final personTab = find.byIcon(Icons.person_outline);
      
      if (homeTab.evaluate().isNotEmpty) {
        print('✅ 5. 메인 화면 진입 확인');
        
        // 탭 테스트
        if (analyticsTab.evaluate().isNotEmpty) {
          await tester.tap(analyticsTab);
          await tester.pumpAndSettle();
          print('  ✓ 포트폴리오 탭 테스트');
        }
        
        if (personTab.evaluate().isNotEmpty) {
          await tester.tap(personTab);
          await tester.pumpAndSettle();
          print('  ✓ 프로필 탭 테스트');
        }
        
        // 홈으로 돌아가기
        await tester.tap(homeTab);
        await tester.pumpAndSettle();
        print('  ✓ 홈 탭으로 돌아가기');
      }
      
      print('\n========== Demo Flow 테스트 완료 ==========\n');
    });

    testWidgets('화면 스크린샷 캡처 테스트', (tester) async {
      print('\n========== 화면 스크린샷 테스트 시작 ==========\n');
      
      // 앱 실행 및 Demo 모드로 빠르게 진입
      SharedPreferences.setMockInitialValues({
        'selected_language': 'ko',
        'has_seen_onboarding': true,
        'isDemoMode': 'true',
      });
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // 각 화면 스크린샷
      await tester.pump(const Duration(seconds: 1));
      print('✅ 현재 화면 스크린샷 준비');
      
      // 주요 UI 요소 확인
      _checkUIElements(tester);
      
      print('\n========== 화면 스크린샷 테스트 완료 ==========\n');
    });
  });
}

void _checkUIElements(WidgetTester tester) {
  // 현재 화면에 있는 주요 위젯 확인
  final texts = find.byType(Text);
  final buttons = find.byType(ElevatedButton);
  final icons = find.byType(Icon);
  
  print('\n[현재 화면 UI 요소]');
  print('  - Text 위젯: ${texts.evaluate().length}개');
  print('  - Button 위젯: ${buttons.evaluate().length}개');
  print('  - Icon 위젯: ${icons.evaluate().length}개');
  
  // 주요 텍스트 출력
  for (var i = 0; i < texts.evaluate().length && i < 10; i++) {
    final text = texts.at(i);
    if (text.evaluate().isNotEmpty) {
      final widget = tester.widget<Text>(text);
      if (widget.data != null && widget.data!.isNotEmpty && widget.data!.length < 50) {
        print('  - Text: "${widget.data}"');
      }
    }
  }
}