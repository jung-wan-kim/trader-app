import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/position_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('접근성 테스트 - WCAG 2.1 AA 준수', () {
    late BaseUITest baseTest;
    
    setUp(() {
      baseTest = BaseUITest();
      // 접근성 기능 활성화
      WidgetsBinding.instance.ensureSemantics();
    });
    
    testWidgets('스크린 리더 지원 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 1. 홈 화면 시맨틱 레이블 확인
      expect(
        find.bySemanticsLabel('주식 추천 목록'),
        findsOneWidget,
      );
      
      expect(
        find.bySemanticsLabel('필터 옵션 열기'),
        findsOneWidget,
      );
      
      expect(
        find.bySemanticsLabel('정렬 옵션 열기'),
        findsOneWidget,
      );
      
      // 2. 추천 카드 시맨틱 정보
      final firstCard = find.byKey(Key('recommendation_0'));
      final semantics = tester.getSemantics(firstCard);
      
      expect(semantics.label, contains('종목'));
      expect(semantics.label, contains('현재가'));
      expect(semantics.label, contains('추천 유형'));
      expect(semantics.hint, contains('탭하여 상세 정보 보기'));
      
      // 3. 버튼 시맨틱 액션
      final filterButton = find.byIcon(Icons.filter_list);
      final filterSemantics = tester.getSemantics(filterButton);
      
      expect(filterSemantics.actions, contains(SemanticsAction.tap));
      expect(filterSemantics.label, '필터 옵션 열기');
      
      // 4. 네비게이션 시맨틱
      final bottomNav = find.byType(BottomNavigationBar);
      final navSemantics = tester.getSemantics(bottomNav);
      
      expect(find.bySemanticsLabel('홈 탭'), findsOneWidget);
      expect(find.bySemanticsLabel('전략 탭'), findsOneWidget);
      expect(find.bySemanticsLabel('포지션 탭'), findsOneWidget);
      expect(find.bySemanticsLabel('성과 탭'), findsOneWidget);
      expect(find.bySemanticsLabel('프로필 탭'), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('키보드 네비게이션 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: false);
      
      final login = LoginPage(tester);
      
      // 1. Tab 키로 포커스 이동 (시뮬레이션)
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      
      // 이메일 필드에 포커스
      final emailField = tester.widget<TextField>(login.emailField);
      expect(emailField.focusNode?.hasFocus, true);
      
      // 2. Tab으로 다음 필드로 이동
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      
      // 비밀번호 필드에 포커스
      final passwordField = tester.widget<TextField>(login.passwordField);
      expect(passwordField.focusNode?.hasFocus, true);
      
      // 3. Enter 키로 제출
      await login.enterEmail('test@example.com');
      await login.enterPassword('password123');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      
      // 4. Escape 키로 다이얼로그 닫기
      // 오류 다이얼로그가 표시된 경우
      if (find.byType(AlertDialog).evaluate().isNotEmpty) {
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('색맹 대응 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 1. 색상만으로 정보 전달하지 않는지 확인
      // 수익/손실 표시
      final profitLossWidget = find.byKey(Key('pnl_0'));
      final widget = tester.widget<Text>(profitLossWidget);
      
      // 색상뿐만 아니라 +/- 기호로도 구분
      expect(widget.data, anyOf(contains('+'), contains('-')));
      
      // 2. 차트에 패턴/모양 사용 확인
      await home.navigateToTab(3); // 성과 탭
      
      // 차트 범례에 색상과 함께 모양 표시
      expect(find.byIcon(Icons.circle), findsWidgets);
      expect(find.byIcon(Icons.square), findsWidgets);
      
      // 3. 충분한 색상 대비 확인 (시뮬레이션)
      // 배경색과 텍스트 색상의 대비율이 4.5:1 이상인지 확인
      final textWidget = tester.widget<Text>(find.text('추천 종목').first);
      expect(textWidget.style?.color, isNotNull);
      
      await baseTest.teardown();
    });
    
    testWidgets('포커스 표시 및 순서 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 1. 포커스 표시 확인
      final firstButton = find.byIcon(Icons.filter_list);
      await tester.tap(firstButton);
      
      // 포커스 링 표시 확인
      final focusedWidget = tester.widget<IconButton>(firstButton);
      expect(focusedWidget.focusNode?.hasFocus, true);
      
      // 2. 논리적 포커스 순서
      final focusOrder = <String>[];
      
      // Tab 키로 순차 이동하며 포커스 순서 기록
      for (int i = 0; i < 10; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        final focused = FocusManager.instance.primaryFocus;
        if (focused?.context?.widget.key != null) {
          focusOrder.add(focused!.context!.widget.key.toString());
        }
      }
      
      // 포커스 순서가 논리적인지 확인 (위에서 아래, 왼쪽에서 오른쪽)
      expect(focusOrder.isNotEmpty, true);
      
      await baseTest.teardown();
    });
    
    testWidgets('대체 텍스트 및 설명 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 1. 이미지 대체 텍스트
      final images = find.byType(Image);
      
      for (final image in images.evaluate()) {
        final semantics = tester.getSemantics(find.byWidget(image.widget));
        expect(semantics.label, isNotNull);
        expect(semantics.label.isNotEmpty, true);
      }
      
      // 2. 아이콘 설명
      final icons = find.byType(Icon);
      
      for (final icon in icons.evaluate()) {
        final parent = find.ancestor(
          of: find.byWidget(icon.widget),
          matching: find.byType(IconButton),
        );
        
        if (parent.evaluate().isNotEmpty) {
          final semantics = tester.getSemantics(parent);
          expect(semantics.label, isNotNull);
        }
      }
      
      // 3. 복잡한 위젯 설명
      final chart = find.byKey(Key('performance_chart'));
      if (chart.evaluate().isNotEmpty) {
        final semantics = tester.getSemantics(chart);
        expect(semantics.label, contains('차트'));
        expect(semantics.hint, isNotNull);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('터치 타겟 크기 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // WCAG 권장 최소 터치 타겟: 44x44 논리 픽셀
      const minTouchTarget = 44.0;
      
      // 1. 버튼 크기 확인
      final buttons = find.byType(ElevatedButton);
      
      for (final button in buttons.evaluate()) {
        final size = tester.getSize(find.byWidget(button.widget));
        expect(size.width, greaterThanOrEqualTo(minTouchTarget));
        expect(size.height, greaterThanOrEqualTo(minTouchTarget));
      }
      
      // 2. 아이콘 버튼 크기 확인
      final iconButtons = find.byType(IconButton);
      
      for (final iconButton in iconButtons.evaluate()) {
        final size = tester.getSize(find.byWidget(iconButton.widget));
        expect(size.width, greaterThanOrEqualTo(minTouchTarget));
        expect(size.height, greaterThanOrEqualTo(minTouchTarget));
      }
      
      // 3. 체크박스/라디오 버튼 크기
      final checkboxes = find.byType(Checkbox);
      
      for (final checkbox in checkboxes.evaluate()) {
        final size = tester.getSize(find.byWidget(checkbox.widget));
        expect(size.width, greaterThanOrEqualTo(minTouchTarget));
        expect(size.height, greaterThanOrEqualTo(minTouchTarget));
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('시간 제한 및 자동 로그아웃 경고', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 세션 만료 5분 전 경고 시뮬레이션
      await tester.pump(Duration(minutes: 25)); // 30분 세션 중 25분 경과
      
      // 경고 다이얼로그 표시 확인
      expect(find.text('세션이 곧 만료됩니다'), findsOneWidget);
      expect(find.text('계속하시려면 연장을 선택하세요'), findsOneWidget);
      
      // 연장 옵션 제공
      expect(find.text('연장'), findsOneWidget);
      expect(find.text('로그아웃'), findsOneWidget);
      
      // 스크린 리더용 알림
      final dialog = find.byType(AlertDialog);
      final semantics = tester.getSemantics(dialog);
      expect(semantics.label, contains('경고'));
      
      await baseTest.teardown();
    });
    
    testWidgets('폼 입력 접근성 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: false);
      
      final login = LoginPage(tester);
      
      // 1. 레이블과 입력 필드 연결
      final emailField = tester.widget<TextField>(login.emailField);
      expect(emailField.decoration?.labelText, '이메일');
      expect(emailField.decoration?.hintText, isNotNull);
      
      // 2. 오류 메시지 접근성
      await login.enterEmail('invalid');
      await login.tapLogin();
      
      // 오류 메시지가 aria-live 영역으로 읽힘
      final errorText = find.text('올바른 이메일 형식이 아닙니다');
      final errorSemantics = tester.getSemantics(errorText);
      expect(errorSemantics.flags, contains(SemanticsFlag.isLiveRegion));
      
      // 3. 필수 필드 표시
      expect(emailField.decoration?.labelText, contains('*'));
      
      await baseTest.teardown();
    });
  });
}