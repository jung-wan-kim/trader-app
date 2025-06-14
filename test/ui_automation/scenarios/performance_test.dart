import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'dart:io';
import '../base/base_test.dart';
import '../pages/home_page.dart';
import '../pages/position_page.dart';
import '../helpers/mock_providers.dart';
import '../fixtures/test_data_factory.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('성능 테스트 - 렌더링, 메모리, 로딩 시간', () {
    late BaseUITest baseTest;
    late Map<String, dynamic> performanceMetrics;
    
    setUp(() {
      baseTest = BaseUITest();
      performanceMetrics = {};
    });
    
    tearDown(() {
      // 성능 메트릭 출력
      print('\n=== Performance Metrics ===');
      performanceMetrics.forEach((key, value) {
        print('$key: $value');
      });
      print('========================\n');
    });
    
    testWidgets('앱 초기 로딩 시간 측정', (tester) async {
      await baseTest.setup(tester);
      
      final startTime = DateTime.now();
      
      await baseTest.launchApp(isAuthenticated: true);
      await baseTest.waitForLoadingToComplete();
      
      final loadTime = DateTime.now().difference(startTime);
      performanceMetrics['Initial Load Time'] = '${loadTime.inMilliseconds}ms';
      
      // 목표: 2초 이내 로딩
      expect(loadTime.inSeconds, lessThan(2));
      
      // Time to Interactive (TTI)
      final home = HomePage(tester);
      final ttiStart = DateTime.now();
      
      await home.selectRecommendation(0);
      
      final ttiTime = DateTime.now().difference(ttiStart);
      performanceMetrics['Time to Interactive'] = '${ttiTime.inMilliseconds}ms';
      
      // 목표: 100ms 이내 상호작용 가능
      expect(ttiTime.inMilliseconds, lessThan(100));
      
      await baseTest.teardown();
    });
    
    testWidgets('리스트 스크롤 성능 (FPS)', (tester) async {
      await baseTest.setup(tester);
      
      // 1000개 항목으로 테스트
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) {
            return MockRecommendationsNotifier(
              TestDataFactory.createRecommendationList(count: 1000),
            );
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      await baseTest.waitForLoadingToComplete();
      
      // 프레임 타이밍 기록 시작
      final frameTimings = <FrameTiming>[];
      void recordFrames(List<FrameTiming> timings) {
        frameTimings.addAll(timings);
      }
      
      binding.addTimingsCallback(recordFrames);
      
      // 스크롤 수행
      final home = HomePage(tester);
      final scrollStartTime = DateTime.now();
      
      for (int i = 0; i < 10; i++) {
        await tester.fling(
          home.recommendationList,
          const Offset(0, -500),
          1000,
        );
        await tester.pumpAndSettle();
      }
      
      final scrollDuration = DateTime.now().difference(scrollStartTime);
      
      // 프레임 타이밍 분석
      binding.removeTimingsCallback(recordFrames);
      
      if (frameTimings.isNotEmpty) {
        final totalFrames = frameTimings.length;
        final droppedFrames = frameTimings.where((timing) {
          return timing.totalSpan.inMilliseconds > 16; // 60fps = 16.67ms per frame
        }).length;
        
        final fps = (totalFrames / scrollDuration.inSeconds).round();
        final jankPercentage = (droppedFrames / totalFrames * 100);
        
        performanceMetrics['Average FPS'] = fps;
        performanceMetrics['Jank Percentage'] = '${jankPercentage.toStringAsFixed(2)}%';
        performanceMetrics['Total Frames'] = totalFrames;
        performanceMetrics['Dropped Frames'] = droppedFrames;
        
        // 목표: 평균 55fps 이상, Jank 5% 이하
        expect(fps, greaterThan(55));
        expect(jankPercentage, lessThan(5));
      }
      
      await baseTest.teardown();
    });
    
    testWidgets('메모리 사용량 측정', (tester) async {
      await baseTest.setup(tester);
      
      // 초기 메모리
      final initialMemory = ProcessInfo.currentRss;
      performanceMetrics['Initial Memory'] = '${(initialMemory / 1024 / 1024).toStringAsFixed(2)} MB';
      
      await baseTest.launchApp(isAuthenticated: true);
      
      // 앱 로드 후 메모리
      final afterLoadMemory = ProcessInfo.currentRss;
      performanceMetrics['After Load Memory'] = '${(afterLoadMemory / 1024 / 1024).toStringAsFixed(2)} MB';
      
      // 대량 데이터 로드
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) {
            return MockRecommendationsNotifier(
              TestDataFactory.createRecommendationList(count: 1000),
            );
          }),
        ],
      );
      
      await baseTest.restartApp();
      await baseTest.waitForLoadingToComplete();
      
      // 대량 데이터 로드 후 메모리
      final afterBulkLoadMemory = ProcessInfo.currentRss;
      performanceMetrics['After Bulk Load Memory'] = '${(afterBulkLoadMemory / 1024 / 1024).toStringAsFixed(2)} MB';
      
      // 메모리 증가량
      final memoryIncrease = (afterBulkLoadMemory - initialMemory) / 1024 / 1024;
      performanceMetrics['Memory Increase'] = '${memoryIncrease.toStringAsFixed(2)} MB';
      
      // 목표: 200MB 이하 증가
      expect(memoryIncrease, lessThan(200));
      
      await baseTest.teardown();
    });
    
    testWidgets('화면 전환 성능', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      final transitions = <String, int>{};
      
      // 각 탭으로 전환 시간 측정
      final tabs = ['전략', '포지션', '성과', '프로필'];
      
      for (int i = 1; i < tabs.length; i++) {
        final startTime = DateTime.now();
        
        await home.navigateToTab(i);
        await tester.pumpAndSettle();
        
        final transitionTime = DateTime.now().difference(startTime);
        transitions['Home to ${tabs[i-1]}'] = transitionTime.inMilliseconds;
        
        // 목표: 300ms 이내 전환
        expect(transitionTime.inMilliseconds, lessThan(300));
      }
      
      performanceMetrics['Screen Transitions'] = transitions;
      
      await baseTest.teardown();
    });
    
    testWidgets('이미지 로딩 성능', (tester) async {
      await baseTest.setup(tester);
      
      // 이미지가 포함된 데이터
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) {
            return MockRecommendationsNotifier(
              TestDataFactory.createRecommendationList(count: 50),
            );
          }),
        ],
      );
      
      final startTime = DateTime.now();
      
      await baseTest.launchApp(isAuthenticated: true);
      
      // 모든 이미지 로드 대기
      await tester.pump(const Duration(seconds: 2));
      
      final imageLoadTime = DateTime.now().difference(startTime);
      performanceMetrics['Image Load Time'] = '${imageLoadTime.inMilliseconds}ms';
      
      // 이미지 캐싱 확인
      await baseTest.restartApp();
      
      final cachedStartTime = DateTime.now();
      await baseTest.waitForLoadingToComplete();
      
      final cachedLoadTime = DateTime.now().difference(cachedStartTime);
      performanceMetrics['Cached Load Time'] = '${cachedLoadTime.inMilliseconds}ms';
      
      // 캐시된 로드가 더 빨라야 함
      expect(cachedLoadTime.inMilliseconds, lessThan(imageLoadTime.inMilliseconds));
      
      await baseTest.teardown();
    });
    
    testWidgets('실시간 데이터 업데이트 성능', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      await home.navigateToTab(2); // 포지션 탭
      
      final position = PositionPage(tester);
      
      // 실시간 가격 업데이트 시뮬레이션
      final updateTimings = <int>[];
      
      for (int i = 0; i < 10; i++) {
        final startTime = DateTime.now();
        
        // 가격 업데이트 트리거
        await tester.pump(const Duration(seconds: 1));
        
        final updateTime = DateTime.now().difference(startTime);
        updateTimings.add(updateTime.inMilliseconds);
      }
      
      final avgUpdateTime = updateTimings.reduce((a, b) => a + b) / updateTimings.length;
      performanceMetrics['Avg Realtime Update'] = '${avgUpdateTime.toStringAsFixed(2)}ms';
      
      // 목표: 평균 50ms 이내 업데이트
      expect(avgUpdateTime, lessThan(50));
      
      await baseTest.teardown();
    });
    
    testWidgets('차트 렌더링 성능', (tester) async {
      await baseTest.setup(tester);
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 성과 탭으로 이동
      final chartStartTime = DateTime.now();
      
      await home.navigateToTab(3);
      await tester.pumpAndSettle();
      
      final chartRenderTime = DateTime.now().difference(chartStartTime);
      performanceMetrics['Chart Render Time'] = '${chartRenderTime.inMilliseconds}ms';
      
      // 목표: 500ms 이내 차트 렌더링
      expect(chartRenderTime.inMilliseconds, lessThan(500));
      
      // 차트 상호작용 성능
      final interactionStart = DateTime.now();
      
      // 기간 변경
      await tester.tap(find.text('1개월'));
      await tester.pumpAndSettle();
      
      final interactionTime = DateTime.now().difference(interactionStart);
      performanceMetrics['Chart Interaction'] = '${interactionTime.inMilliseconds}ms';
      
      // 목표: 200ms 이내 상호작용
      expect(interactionTime.inMilliseconds, lessThan(200));
      
      await baseTest.teardown();
    });
    
    testWidgets('검색 성능', (tester) async {
      await baseTest.setup(tester);
      
      // 1000개 데이터
      baseTest.container = ProviderContainer(
        overrides: [
          ...MockProviders.getDefaultOverrides(),
          recommendationsProvider.overrideWith((ref) {
            return MockRecommendationsNotifier(
              TestDataFactory.createRecommendationList(count: 1000),
            );
          }),
        ],
      );
      
      await baseTest.launchApp(isAuthenticated: true);
      
      final home = HomePage(tester);
      
      // 검색 수행
      final searchStart = DateTime.now();
      
      await home.searchStock('AAPL');
      
      final searchTime = DateTime.now().difference(searchStart);
      performanceMetrics['Search Time (1000 items)'] = '${searchTime.inMilliseconds}ms';
      
      // 목표: 100ms 이내 검색 결과
      expect(searchTime.inMilliseconds, lessThan(100));
      
      await baseTest.teardown();
    });
  });
}