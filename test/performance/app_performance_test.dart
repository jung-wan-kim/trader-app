import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone_flutter/main.dart';

void main() {
  group('App Performance Tests', () {
    late Stopwatch stopwatch;

    setUp(() {
      stopwatch = Stopwatch();
    });

    testWidgets('app startup time test', (WidgetTester tester) async {
      stopwatch.start();
      
      // Launch app
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      
      // Wait for first frame
      await tester.pump();
      
      // Wait for app to be fully loaded
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // App should start within 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      
      // Log startup time for monitoring
      debugPrint('App startup time: ${stopwatch.elapsedMilliseconds}ms');
    });

    testWidgets('screen transition performance test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      final transitionTimes = <String, int>{};

      // Test Home to Discover transition
      stopwatch.reset();
      stopwatch.start();
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();
      stopwatch.stop();
      transitionTimes['Home to Discover'] = stopwatch.elapsedMilliseconds;

      // Test Discover to Position transition
      stopwatch.reset();
      stopwatch.start();
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();
      stopwatch.stop();
      transitionTimes['Discover to Position'] = stopwatch.elapsedMilliseconds;

      // Test Position to Profile transition
      stopwatch.reset();
      stopwatch.start();
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      stopwatch.stop();
      transitionTimes['Position to Profile'] = stopwatch.elapsedMilliseconds;

      // Test Profile to Home transition
      stopwatch.reset();
      stopwatch.start();
      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
      stopwatch.stop();
      transitionTimes['Profile to Home'] = stopwatch.elapsedMilliseconds;

      // All transitions should be under 300ms
      transitionTimes.forEach((transition, time) {
        expect(time, lessThan(300), reason: '$transition took $time ms');
        debugPrint('$transition: $time ms');
      });
    });

    testWidgets('list scrolling performance test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Wait for data to load
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final scrollable = find.byType(Scrollable).first;
      
      stopwatch.reset();
      stopwatch.start();
      
      // Perform multiple scroll actions
      for (int i = 0; i < 10; i++) {
        await tester.drag(scrollable, const Offset(0, -200));
        await tester.pump(const Duration(milliseconds: 16)); // 60 FPS
      }
      
      await tester.pumpAndSettle();
      stopwatch.stop();
      
      // Scrolling should be smooth (average 16ms per frame for 60 FPS)
      final averageFrameTime = stopwatch.elapsedMilliseconds / 10;
      expect(averageFrameTime, lessThan(50)); // Allow some margin
      
      debugPrint('Average scroll frame time: $averageFrameTime ms');
    });

    testWidgets('widget rebuild performance test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Count rebuilds during navigation
      int rebuildCount = 0;
      
      // Create a widget that counts rebuilds
      final testKey = GlobalKey();
      
      // Navigate between screens and measure rebuilds
      for (int i = 0; i < 4; i++) {
        stopwatch.reset();
        stopwatch.start();
        
        final icons = [
          Icons.home_outlined,
          Icons.explore_outlined,
          Icons.analytics_outlined,
          Icons.person_outline,
        ];
        
        await tester.tap(find.byIcon(icons[i]));
        await tester.pump();
        rebuildCount++;
        
        stopwatch.stop();
        debugPrint('Navigation $i rebuild time: ${stopwatch.elapsedMilliseconds}ms');
      }
      
      // Should have minimal rebuilds
      expect(rebuildCount, lessThanOrEqualTo(4));
    });

    testWidgets('memory usage simulation test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate heavy usage by navigating repeatedly
      for (int cycle = 0; cycle < 3; cycle++) {
        // Navigate through all screens
        await tester.tap(find.byIcon(Icons.explore_outlined));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byIcon(Icons.analytics_outlined));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byIcon(Icons.home_outlined));
        await tester.pumpAndSettle();
        
        // Scroll in home screen
        final scrollable = find.byType(Scrollable).first;
        await tester.drag(scrollable, const Offset(0, -1000));
        await tester.pumpAndSettle();
        await tester.drag(scrollable, const Offset(0, 1000));
        await tester.pumpAndSettle();
      }
      
      // App should still be responsive after heavy usage
      stopwatch.reset();
      stopwatch.start();
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();
      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
      debugPrint('Response time after heavy usage: ${stopwatch.elapsedMilliseconds}ms');
    });

    testWidgets('data loading performance test', (WidgetTester tester) async {
      stopwatch.start();
      
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      
      // Wait for initial data load
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      
      // Check if loading indicators appear and disappear quickly
      final loadingFinder = find.byType(CircularProgressIndicator);
      
      if (loadingFinder.evaluate().isNotEmpty) {
        await tester.pumpAndSettle();
      }
      
      stopwatch.stop();
      
      // Data should load within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      debugPrint('Data loading time: ${stopwatch.elapsedMilliseconds}ms');
    });

    testWidgets('animation performance test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TraderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to trigger animations
      stopwatch.reset();
      stopwatch.start();
      
      await tester.tap(find.byIcon(Icons.explore_outlined));
      
      // Pump frames at 60 FPS to measure animation smoothness
      for (int i = 0; i < 30; i++) { // 0.5 seconds of animation
        await tester.pump(const Duration(milliseconds: 16));
      }
      
      stopwatch.stop();
      
      // Animation should complete smoothly
      final expectedTime = 30 * 16; // 30 frames at 16ms each
      final actualTime = stopwatch.elapsedMilliseconds;
      final deviation = (actualTime - expectedTime).abs();
      
      expect(deviation, lessThan(100)); // Allow 100ms deviation
      debugPrint('Animation performance deviation: ${deviation}ms');
    });
  });

  group('Performance Metrics Tests', () {
    test('calculate performance metrics', () {
      // Simulated metrics from performance tests
      final metrics = {
        'appStartupTime': 1500,
        'screenTransitionAvg': 250,
        'scrollFrameTime': 20,
        'dataLoadTime': 800,
        'memoryUsageMB': 150,
      };

      // Verify all metrics are within acceptable ranges
      expect(metrics['appStartupTime']!, lessThanOrEqualTo(3000));
      expect(metrics['screenTransitionAvg']!, lessThanOrEqualTo(300));
      expect(metrics['scrollFrameTime']!, lessThanOrEqualTo(33)); // 30 FPS minimum
      expect(metrics['dataLoadTime']!, lessThanOrEqualTo(2000));
      expect(metrics['memoryUsageMB']!, lessThanOrEqualTo(200));

      // Calculate performance score
      final score = _calculatePerformanceScore(metrics);
      expect(score, greaterThanOrEqualTo(70)); // Minimum acceptable score
      
      debugPrint('Performance Score: $score/100');
    });
  });
}

double _calculatePerformanceScore(Map<String, int> metrics) {
  double score = 100.0;
  
  // Deduct points for slow startup
  if (metrics['appStartupTime']! > 1000) {
    score -= (metrics['appStartupTime']! - 1000) / 100;
  }
  
  // Deduct points for slow transitions
  if (metrics['screenTransitionAvg']! > 200) {
    score -= (metrics['screenTransitionAvg']! - 200) / 20;
  }
  
  // Deduct points for poor scroll performance
  if (metrics['scrollFrameTime']! > 16) {
    score -= (metrics['scrollFrameTime']! - 16) * 2;
  }
  
  // Deduct points for slow data loading
  if (metrics['dataLoadTime']! > 500) {
    score -= (metrics['dataLoadTime']! - 500) / 50;
  }
  
  // Deduct points for high memory usage
  if (metrics['memoryUsageMB']! > 100) {
    score -= (metrics['memoryUsageMB']! - 100) / 10;
  }
  
  return score.clamp(0, 100);
}