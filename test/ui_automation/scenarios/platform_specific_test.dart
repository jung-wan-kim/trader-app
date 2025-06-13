import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/position_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('플랫폼별 테스트 - iOS/Android 차이점', () {
    late BaseUITest baseTest;
    final isIOS = Platform.isIOS;
    final isAndroid = Platform.isAndroid;
    
    setUp(() {
      baseTest = BaseUITest();
    });
    
    testWidgets('플랫폼별 네비게이션 패턴', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      if (isIOS) {
        // iOS: 스와이프 백 제스처
        final home = HomePage(tester);
        await home.selectRecommendation(0);
        
        // 상세 화면에서 스와이프 백
        await tester.drag(
          find.byType(Scaffold),
          const Offset(300, 0),
        );
        await tester.pumpAndSettle();
        
        // 홈 화면으로 돌아왔는지 확인
        expect(find.byType(HomePage), findsOneWidget);
        
        // iOS 스타일 네비게이션 바
        expect(find.byType(CupertinoNavigationBar), findsWidgets);
      } else if (isAndroid) {
        // Android: 백 버튼
        final home = HomePage(tester);
        await home.selectRecommendation(0);
        
        // 시스템 백 버튼 시뮬레이션
        await tester.binding.handlePointerEvent(
          const PointerDownEvent(
            position: Offset(50, 50),
            buttons: kSecondaryButton,
          ),
        );
        await tester.pumpAndSettle();
        
        // Material 디자인 AppBar
        expect(find.byType(AppBar), findsWidgets);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 UI 컴포넌트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: false);
      
      final login = LoginPage(tester);
      
      if (isIOS) {
        // iOS: Cupertino 스타일 컴포넌트
        expect(find.byType(CupertinoTextField), findsWidgets);
        expect(find.byType(CupertinoButton), findsWidgets);
        
        // iOS 스타일 스위치
        await tester.tap(find.byType(CupertinoSwitch));
        await tester.pumpAndSettle();
      } else if (isAndroid) {
        // Android: Material 스타일 컴포넌트
        expect(find.byType(TextField), findsWidgets);
        expect(find.byType(ElevatedButton), findsWidgets);
        
        // Material 스타일 스위치
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 스크롤 동작', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      if (isIOS) {
        // iOS: 바운스 스크롤 효과
        await tester.drag(
          home.recommendationList,
          const Offset(0, 300), // 위로 당기기
        );
        await tester.pump();
        
        // 바운스 효과 확인 (오버스크롤)
        final scrollable = tester.widget<Scrollable>(
          find.byType(Scrollable).first,
        );
        expect(scrollable.physics, isA<BouncingScrollPhysics>());
      } else if (isAndroid) {
        // Android: 글로우 효과
        await tester.drag(
          home.recommendationList,
          const Offset(0, 300),
        );
        await tester.pump();
        
        // 글로우 효과 확인
        expect(find.byType(GlowingOverscrollIndicator), findsWidgets);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 키보드 처리', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: false);
      
      final login = LoginPage(tester);
      
      // 이메일 필드에 포커스
      await login.tap(login.emailField);
      await tester.pump();
      
      if (isIOS) {
        // iOS: 키보드 위 도구 모음
        expect(find.byType(CupertinoTextSelectionToolbar), findsWidgets);
        
        // Done 버튼으로 키보드 닫기
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
      } else if (isAndroid) {
        // Android: IME 액션
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.pump();
        
        // 다음 필드로 포커스 이동 확인
        final passwordField = tester.widget<TextField>(login.passwordField);
        expect(passwordField.focusNode?.hasFocus, true);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 날짜/시간 선택기', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 성과 탭으로 이동
      final home = HomePage(tester);
      await home.navigateToTab(3);
      
      // 날짜 선택기 열기
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      
      if (isIOS) {
        // iOS: Cupertino 날짜 선택기
        expect(find.byType(CupertinoDatePicker), findsOneWidget);
        
        // 휠 스크롤로 날짜 선택
        await tester.drag(
          find.byType(CupertinoDatePicker),
          const Offset(0, -100),
        );
        await tester.pumpAndSettle();
      } else if (isAndroid) {
        // Android: Material 날짜 선택기
        expect(find.byType(CalendarDatePicker), findsOneWidget);
        
        // 탭으로 날짜 선택
        await tester.tap(find.text('15'));
        await tester.pumpAndSettle();
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 알림 권한 요청', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 프로필 탭으로 이동
      final home = HomePage(tester);
      await home.navigateToTab(4);
      
      // 알림 설정 열기
      await tester.tap(find.text('알림 설정'));
      await tester.pumpAndSettle();
      
      // 알림 토글
      await tester.tap(find.byKey(Key('notification_toggle')));
      await tester.pumpAndSettle();
      
      if (isIOS) {
        // iOS: 시스템 권한 다이얼로그 시뮬레이션
        expect(find.text('알림을 허용하시겠습니까?'), findsOneWidget);
        expect(find.text('거래 신호와 중요 업데이트를 받으실 수 있습니다'), findsOneWidget);
      } else if (isAndroid) {
        // Android: 권한 설명 다이얼로그
        expect(find.text('알림 권한이 필요합니다'), findsOneWidget);
        expect(find.text('설정으로 이동'), findsOneWidget);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 생체 인증', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: false);
      
      // 생체 인증 버튼 찾기
      final biometricButton = find.byKey(Key('biometric_login'));
      
      if (biometricButton.evaluate().isNotEmpty) {
        await tester.tap(biometricButton);
        await tester.pumpAndSettle();
        
        if (isIOS) {
          // iOS: Face ID / Touch ID
          expect(
            find.textContaining('Face ID') 
            .evaluate().isNotEmpty ||
            find.textContaining('Touch ID')
            .evaluate().isNotEmpty,
            true,
          );
        } else if (isAndroid) {
          // Android: 지문 인증
          expect(find.textContaining('지문'), findsOneWidget);
        }
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 공유 기능', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 추천 상세로 이동
      final home = HomePage(tester);
      await home.selectRecommendation(0);
      
      // 공유 버튼 탭
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();
      
      if (isIOS) {
        // iOS: UIActivityViewController 스타일
        expect(find.text('AirDrop'), findsWidgets);
        expect(find.text('메시지'), findsOneWidget);
      } else if (isAndroid) {
        // Android: 공유 시트
        expect(find.text('공유 대상'), findsOneWidget);
        expect(find.byType(BottomSheet), findsOneWidget);
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 상태바 스타일', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 상태바 스타일 확인
      final brightness = tester.binding.window.platformBrightness;
      
      if (isIOS) {
        // iOS: 상태바가 콘텐츠와 겹침
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.extendBodyBehindAppBar, isNotNull);
      } else if (isAndroid) {
        // Android: 상태바 색상 커스터마이징
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('플랫폼별 앱 라이프사이클', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 앱을 백그라운드로 보내기 시뮬레이션
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      
      // 다시 포그라운드로
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      
      if (isIOS) {
        // iOS: 백그라운드에서 블러 처리
        // 민감한 정보 보호
      } else if (isAndroid) {
        // Android: 백그라운드에서 메모리 관리
        // 불필요한 리소스 해제
      }
      
      // 앱이 정상적으로 복구되었는지 확인
      expect(find.byType(HomePage), findsOneWidget);
      
      await baseTest.teardown();
    });
  });
}