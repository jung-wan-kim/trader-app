import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'dart:io';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/position_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Visual Regression 테스트 - 스크린샷 비교', () {
    late BaseUITest baseTest;
    
    setUp(() async {
      baseTest = BaseUITest();
      await loadAppFonts();
    });
    
    // 골든 파일 경로 설정
    final goldenDir = 'test/ui_automation/goldens';
    
    testWidgets('온보딩 화면 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(
        isFirstLaunch: true,
        locale: 'ko',
      );
      
      // 언어 선택 화면
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/onboarding/language_selection.png'),
      );
      
      // 한국어 선택
      await tester.tap(find.text('한국어'));
      await tester.pumpAndSettle();
      
      final onboarding = OnboardingPage(tester);
      
      // 온보딩 각 페이지 스크린샷
      for (int i = 0; i < 3; i++) {
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('$goldenDir/onboarding/page_$i.png'),
        );
        
        if (i < 2) {
          await onboarding.swipeToNextPage();
        }
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('로그인 화면 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: false);
      
      final login = LoginPage(tester);
      
      // 초기 상태
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/login/initial_state.png'),
      );
      
      // 입력 중 상태
      await login.enterEmail('test@example.com');
      await login.enterPassword('password');
      await tester.pump();
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/login/filled_state.png'),
      );
      
      // 에러 상태
      await login.clearFields();
      await login.tapLogin();
      await tester.pumpAndSettle();
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/login/error_state.png'),
      );
      
      await baseTest.teardown();
    });
    
    testWidgets('홈 화면 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 추천 목록
      await baseTest.waitForLoadingToComplete();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/home/recommendation_list.png'),
      );
      
      // 필터 다이얼로그
      await home.openFilters();
      await expectLater(
        find.byType(Dialog),
        matchesGoldenFile('$goldenDir/home/filter_dialog.png'),
      );
      
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      
      // 추천 상세
      await home.selectRecommendation(0);
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/home/recommendation_detail.png'),
      );
      
      await baseTest.teardown();
    });
    
    testWidgets('포지션 화면 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      await home.navigateToTab(2);
      await tester.pumpAndSettle();
      
      final position = PositionPage(tester);
      
      // 진행중 포지션
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/position/open_positions.png'),
      );
      
      // 종료된 포지션
      await position.switchToClosedPositions();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/position/closed_positions.png'),
      );
      
      await baseTest.teardown();
    });
    
    testWidgets('다크 모드 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      
      // 다크 모드 설정
      await baseTest.helper.setDarkMode(true);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 홈 화면 다크 모드
      await baseTest.waitForLoadingToComplete();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/dark_mode/home_dark.png'),
      );
      
      // 각 탭 다크 모드 스크린샷
      final tabs = ['전략', '포지션', '성과', '프로필'];
      for (int i = 1; i <= 4; i++) {
        final home = HomePage(tester);
        await home.navigateToTab(i);
        await tester.pumpAndSettle();
        
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('$goldenDir/dark_mode/${tabs[i-1]}_dark.png'),
        );
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('반응형 레이아웃 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      
      // 다양한 화면 크기에서 테스트
      final deviceConfigs = [
        {'name': 'phone_portrait', 'size': const Size(414, 896)},
        {'name': 'phone_landscape', 'size': const Size(896, 414)},
        {'name': 'tablet', 'size': const Size(768, 1024)},
      ];
      
      for (final config in deviceConfigs) {
        await baseTest.helper.setDeviceSize(config['size'] as Size);
        await baseTest.launchApp(isAuthenticated: true);
        await baseTest.waitForLoadingToComplete();
        
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('$goldenDir/responsive/${config['name']}.png'),
        );
        
        await baseTest.restartApp();
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('컴포넌트 상태별 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      // 버튼 상태
      final buttonStates = ['normal', 'pressed', 'disabled'];
      
      for (final state in buttonStates) {
        // 상태 설정
        switch (state) {
          case 'pressed':
            await tester.press(find.byType(ElevatedButton).first);
            await tester.pump();
            break;
          case 'disabled':
            // 비활성화된 버튼 찾기
            final disabledButton = find.byWidgetPredicate(
              (widget) => widget is ElevatedButton && !widget.enabled,
            );
            if (disabledButton.evaluate().isNotEmpty) {
              await tester.ensureVisible(disabledButton);
            }
            break;
        }
        
        await expectLater(
          find.byType(ElevatedButton).first,
          matchesGoldenFile('$goldenDir/components/button_$state.png'),
        );
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('에러 상태 UI 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      
      // 네트워크 에러 상태
      baseTest.container = ProviderContainer(
        overrides: MockProviders.getErrorOverrides(),
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      await tester.pumpAndSettle();
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/error_states/network_error.png'),
      );
      
      // 빈 데이터 상태
      baseTest.container = ProviderContainer(
        overrides: MockProviders.getEmptyDataOverrides(),
      );
      
      await baseTest.restartApp();
      await tester.pumpAndSettle();
      
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('$goldenDir/error_states/empty_state.png'),
      );
      
      await baseTest.teardown();
    });
    
    testWidgets('애니메이션 키프레임 골든 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 화면 전환 애니메이션 캡처
      final animationFrames = [0, 0.25, 0.5, 0.75, 1.0];
      
      for (final progress in animationFrames) {
        await home.navigateToTab(1);
        
        // 애니메이션 진행률에 맞춰 pump
        await tester.pump(
          Duration(milliseconds: (300 * progress).round()),
        );
        
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile(
            '$goldenDir/animations/tab_transition_${(progress * 100).toInt()}.png',
          ),
        );
      }
      
      await baseTest.teardown();
    });
  });
  
  // 골든 파일 업데이트 유틸리티
  group('골든 파일 관리', () {
    test('골든 파일 업데이트 모드', () {
      // CI 환경이 아닐 때만 골든 파일 업데이트
      final updateGoldens = Platform.environment['UPDATE_GOLDENS'] == 'true';
      
      if (updateGoldens) {
        print('골든 파일 업데이트 모드 활성화됨');
        print('새로운 골든 파일이 생성됩니다.');
      } else {
        print('골든 파일 비교 모드');
        print('기존 골든 파일과 비교합니다.');
      }
    });
    
    test('골든 파일 정리', () {
      final goldenDir = Directory('test/ui_automation/goldens');
      
      if (goldenDir.existsSync()) {
        final files = goldenDir.listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.png'));
        
        print('총 ${files.length}개의 골든 파일 발견');
        
        // 오래된 골든 파일 정리 (30일 이상)
        final cutoffDate = DateTime.now().subtract(Duration(days: 30));
        final oldFiles = files.where((file) {
          return file.statSync().modified.isBefore(cutoffDate);
        });
        
        if (oldFiles.isNotEmpty) {
          print('${oldFiles.length}개의 오래된 골든 파일 발견');
        }
      }
    });
  });
}