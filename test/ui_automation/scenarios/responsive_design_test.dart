import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/position_page.dart';
import '../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('반응형 디자인 테스트 - 다양한 화면 크기', () {
    late BaseUITest baseTest;
    
    setUp(() {
      baseTest = BaseUITest();
    });
    
    // 디바이스 크기 정의
    final deviceSizes = {
      'Small Phone': const Size(360, 640),      // Galaxy S8
      'Medium Phone': const Size(414, 896),     // iPhone 11 Pro Max
      'Large Phone': const Size(428, 926),      // iPhone 14 Pro Max
      'Small Tablet': const Size(768, 1024),    // iPad Mini
      'Large Tablet': const Size(1024, 1366),   // iPad Pro 12.9
      'Foldable': const Size(280, 653),         // Galaxy Fold (closed)
      'Foldable Open': const Size(768, 841),    // Galaxy Fold (open)
    };
    
    for (final entry in deviceSizes.entries) {
      testWidgets('${entry.key} (${entry.value.width}x${entry.value.height}) 레이아웃', 
          (tester) async {
        await baseTest.setup(tester);
        
        // 디바이스 크기 설정
        await baseTest.helper.setDeviceSize(entry.value);
        await tester.pumpAndSettle();
        
        await baseTest.launchApp(isAuthenticated: true);
        
        final home = HomePage(tester);
        
        // 1. 네비게이션 바 확인
        if (entry.value.width < 600) {
          // 모바일: 하단 네비게이션
          expect(find.byType(BottomNavigationBar), findsOneWidget);
        } else {
          // 태블릿: 사이드 네비게이션 또는 확장된 하단 네비게이션
          expect(
            find.byType(NavigationRail).evaluate().isNotEmpty ||
            find.byType(BottomNavigationBar).evaluate().isNotEmpty,
            true,
          );
        }
        
        // 2. 그리드/리스트 레이아웃
        final recommendationList = find.byKey(Key('recommendation_list'));
        
        if (entry.value.width >= 768) {
          // 태블릿: 그리드 레이아웃
          expect(find.byType(GridView), findsOneWidget);
        } else {
          // 모바일: 리스트 레이아웃
          expect(find.byType(ListView), findsOneWidget);
        }
        
        // 3. 텍스트 크기 및 가독성
        final titleText = find.text('AI 추천 종목').first;
        final textWidget = tester.widget<Text>(titleText);
        final fontSize = textWidget.style?.fontSize ?? 0;
        
        if (entry.value.width < 400) {
          expect(fontSize, lessThanOrEqualTo(20));
        } else {
          expect(fontSize, greaterThanOrEqualTo(20));
        }
        
        await baseTest.teardown();
      });
    }
    
    testWidgets('가로/세로 방향 전환 테스트', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 1. 세로 모드 (Portrait)
      await baseTest.helper.setDeviceSize(const Size(414, 896));
      await tester.pumpAndSettle();
      
      // 세로 모드 레이아웃 확인
      expect(find.byType(ListView), findsOneWidget);
      home.verifyRecommendationCount(10);
      
      // 2. 가로 모드 (Landscape)
      await baseTest.helper.setDeviceSize(const Size(896, 414));
      await tester.pumpAndSettle();
      
      // 가로 모드에서 2열 그리드로 변경
      final gridView = find.byType(GridView);
      if (gridView.evaluate().isNotEmpty) {
        final grid = tester.widget<GridView>(gridView);
        final gridDelegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(gridDelegate.crossAxisCount, greaterThanOrEqualTo(2));
      }
      
      // 3. 다시 세로 모드로
      await baseTest.helper.setDeviceSize(const Size(414, 896));
      await tester.pumpAndSettle();
      
      // 레이아웃이 올바르게 복원되는지 확인
      expect(find.byType(ListView), findsOneWidget);
      
      await baseTest.teardown();
    });
    
    testWidgets('터치 타겟 크기 반응형 테스트', (tester) async {
      await baseTest.setup(tester);
      
      // 작은 화면
      await baseTest.helper.setDeviceSize(const Size(360, 640));
      await baseTest.launchApp(isAuthenticated: true);
      
      // 최소 터치 타겟 크기 확인 (44x44)
      final buttons = find.byType(ElevatedButton);
      
      for (final button in buttons.evaluate()) {
        final size = tester.getSize(find.byWidget(button.widget));
        expect(size.width, greaterThanOrEqualTo(44));
        expect(size.height, greaterThanOrEqualTo(44));
      }
      
      // 큰 화면
      await baseTest.helper.setDeviceSize(const Size(1024, 1366));
      await tester.pumpAndSettle();
      
      // 태블릿에서는 더 큰 터치 타겟
      for (final button in buttons.evaluate()) {
        final size = tester.getSize(find.byWidget(button.widget));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('폰트 스케일링 테스트', (tester) async {
      await baseTest.setup(tester);
      
      // 텍스트 스케일 팩터 설정
      final textScaleFactors = [0.85, 1.0, 1.15, 1.3, 1.5];
      
      for (final scaleFactor in textScaleFactors) {
        // 텍스트 스케일 설정
        tester.platformDispatcher.textScaleFactorTestValue = scaleFactor;
        
        await baseTest.launchApp(isAuthenticated: true);
        
        // 텍스트가 잘리지 않는지 확인
        final texts = find.byType(Text);
        
        for (final text in texts.evaluate().take(10)) {
          final widget = text.widget as Text;
          
          // overflow 속성이 설정되어 있는지 확인
          if (widget.overflow == null && widget.maxLines == null) {
            // 단일 라인 텍스트는 overflow 처리가 필요
            final renderObject = text.renderObject as RenderParagraph;
            expect(renderObject.didExceedMaxLines, false);
          }
        }
        
        // 레이아웃이 깨지지 않는지 확인
        expect(tester.takeException(), isNull);
        
        await baseTest.restartApp();
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('다크 모드 반응형 테스트', (tester) async {
      await baseTest.setup(tester);
      
      final sizes = [
        const Size(360, 640),   // Small
        const Size(768, 1024),  // Tablet
      ];
      
      for (final size in sizes) {
        await baseTest.helper.setDeviceSize(size);
        
        // 라이트 모드
        await baseTest.helper.setDarkMode(false);
        await baseTest.launchApp(isAuthenticated: true);
        
        // 라이트 모드 색상 확인
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.backgroundColor, equals(Colors.white));
        
        // 다크 모드
        await baseTest.helper.setDarkMode(true);
        await baseTest.restartApp();
        
        // 다크 모드 색상 확인
        final darkScaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(darkScaffold.backgroundColor, isNot(equals(Colors.white)));
        
        // 텍스트 가독성 확인
        final textWidgets = find.byType(Text);
        for (final textWidget in textWidgets.evaluate().take(5)) {
          final text = textWidget.widget as Text;
          if (text.style?.color != null) {
            // 충분한 대비 확인 (간단한 확인)
            expect(text.style!.color!.computeLuminance(), greaterThan(0.05));
          }
        }
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('스크롤 가능 영역 반응형 테스트', (tester) async {
      await baseTest.setup(tester);
      
      // 작은 화면에서 스크롤 필요
      await baseTest.helper.setDeviceSize(const Size(360, 640));
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 포지션 탭으로 이동
      await home.navigateToTab(2);
      await tester.pumpAndSettle();
      
      // 작은 화면에서는 스크롤 가능
      final scrollables = find.byType(Scrollable);
      expect(scrollables, findsAtLeastNWidgets(1));
      
      // 큰 화면에서는 스크롤 불필요할 수 있음
      await baseTest.helper.setDeviceSize(const Size(1024, 1366));
      await tester.pumpAndSettle();
      
      // 콘텐츠가 화면에 모두 표시되는지 확인
      final position = PositionPage(tester);
      position.verifyPositionCount(3); // 테스트 데이터
      
      await baseTest.teardown();
    });
    
    testWidgets('모달/다이얼로그 반응형 테스트', (tester) async {
      await baseTest.setup(tester);
      
      final sizes = [
        const Size(360, 640),   // Small
        const Size(768, 1024),  // Tablet
      ];
      
      for (final size in sizes) {
        await baseTest.helper.setDeviceSize(size);
        await baseTest.launchApp(isAuthenticated: true);
        
        // 필터 다이얼로그 열기
        final home = HomePage(tester);
        await home.openFilters();
        
        // 다이얼로그 크기 확인
        final dialog = find.byType(Dialog);
        final dialogSize = tester.getSize(dialog);
        
        if (size.width < 600) {
          // 모바일: 전체 화면 또는 큰 다이얼로그
          expect(dialogSize.width, greaterThan(size.width * 0.8));
        } else {
          // 태블릿: 적절한 크기의 다이얼로그
          expect(dialogSize.width, lessThan(size.width * 0.7));
          expect(dialogSize.width, greaterThan(400));
        }
        
        // 다이얼로그 닫기
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
      
      await baseTest.teardown();
    });
  });
}