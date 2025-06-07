import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trader_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full App Flow Test', () {
    testWidgets('App launches and navigates through screens', (tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 1. 스플래시 화면 확인
      expect(find.text('AI-Powered Stock Recommendations'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 언어 선택 화면
      expect(find.text('Choose Your Language'), findsOneWidget);
      expect(find.text('Select your preferred language for the app'), findsOneWidget);
      
      // 한국어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      // Continue 버튼 클릭
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // 3. 온보딩 화면
      expect(find.text('전설적인 트레이더 전략'), findsOneWidget);
      
      // 온보딩 스크린들을 스와이프
      for (int i = 0; i < 3; i++) {
        await tester.drag(find.byType(PageView), const Offset(-300, 0));
        await tester.pumpAndSettle();
      }
      
      // 시작하기 버튼 클릭
      await tester.tap(find.text('시작하기'));
      await tester.pumpAndSettle();

      // 4. 트레이더 선택 화면
      expect(find.text('당신의 트레이딩 마스터를 선택하세요'), findsOneWidget);
      
      // 첫 번째 트레이더 선택
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();
      
      // 선택 계속하기 버튼 클릭
      await tester.tap(find.text('선택 계속하기'));
      await tester.pumpAndSettle();

      // 5. 로그인 화면
      expect(find.text('로그인'), findsOneWidget);
      expect(find.text('이메일'), findsOneWidget);
      expect(find.text('비밀번호'), findsOneWidget);
      
      // 데모 모드 확인
      expect(find.text('데모 모드: 테스트 계정 자동 입력됨'), findsOneWidget);
      
      // 이메일과 비밀번호가 자동 입력되었는지 확인
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      
      expect(tester.widget<TextFormField>(emailField).controller?.text, 'demo@trader.app');
      expect(tester.widget<TextFormField>(passwordField).controller?.text, 'demo123456');
      
      // 로그인 버튼 클릭
      await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
      await tester.pumpAndSettle();

      // 6. 메인 화면
      expect(find.text('홈'), findsOneWidget);
      expect(find.text('시그널'), findsOneWidget);
      expect(find.text('포지션'), findsOneWidget);
      expect(find.text('프로필'), findsOneWidget);
      
      // 홈 화면 확인
      expect(find.text('시장 요약'), findsOneWidget);
      
      // 7. 네비게이션 테스트
      // 시그널 탭
      await tester.tap(find.text('시그널'));
      await tester.pumpAndSettle();
      expect(find.text('실시간 추천'), findsOneWidget);
      
      // 포지션 탭
      await tester.tap(find.text('포지션'));
      await tester.pumpAndSettle();
      expect(find.text('포트폴리오'), findsOneWidget);
      
      // 프로필 탭
      await tester.tap(find.text('프로필'));
      await tester.pumpAndSettle();
      expect(find.text('트레이더'), findsOneWidget);
      expect(find.text('구독 관리'), findsOneWidget);
      
      // 8. 설정 메뉴 테스트
      // 언어 설정
      await tester.tap(find.text('언어 설정'));
      await tester.pumpAndSettle();
      expect(find.text('언어 설정'), findsWidgets); // 화면 제목도 같은 텍스트
      
      // 뒤로가기
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // 구독 관리
      await tester.tap(find.text('구독 관리'));
      await tester.pumpAndSettle();
      expect(find.text('구독'), findsOneWidget);
      
      // 뒤로가기
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // 9. 로그아웃 테스트
      await tester.dragUntilVisible(
        find.text('로그아웃'),
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      
      await tester.tap(find.text('로그아웃'));
      await tester.pumpAndSettle();
      
      // 로그인 화면으로 돌아갔는지 확인
      expect(find.text('로그인'), findsOneWidget);
      expect(find.text('이메일'), findsOneWidget);
    });

    testWidgets('Screen navigation works correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 빠른 네비게이션을 위해 스플래시에서 바로 로그인으로
      // (이미 온보딩을 완료한 상태 시뮬레이션)
      
      // SharedPreferences를 모킹하여 온보딩 완료 상태로 설정
      // 실제 통합 테스트에서는 전체 플로우를 테스트하는 것이 좋음
    });

    testWidgets('Error handling and loading states', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 네트워크 에러 상황 테스트
      // 로딩 상태 테스트
      // 에러 메시지 표시 테스트
    });
  });
}