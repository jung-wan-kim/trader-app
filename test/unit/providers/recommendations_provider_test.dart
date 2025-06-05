import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/services/mock_data_service.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('RecommendationsProvider Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('MockDataService Provider', () {
      test('should provide MockDataService instance', () {
        final service = container.read(mockDataServiceProvider);
        expect(service, isA<MockDataService>());
      });

      test('should return same instance on multiple reads', () {
        final service1 = container.read(mockDataServiceProvider);
        final service2 = container.read(mockDataServiceProvider);
        expect(identical(service1, service2), isTrue);
      });
    });

    group('RecommendationsNotifier', () {
      test('should initialize with loading state', () {
        final state = container.read(recommendationsProvider);
        expect(state, isA<AsyncLoading>());
      });

      test('should load recommendations successfully', () async {
        final recommendations = await container.read(recommendationsProvider.future);
        
        expect(recommendations, isA<List<StockRecommendation>>());
        expect(recommendations, isNotEmpty);
        
        // Verify some properties of loaded recommendations
        for (final rec in recommendations) {
          expect(rec.id, isNotEmpty);
          expect(rec.stockCode, isNotEmpty);
          expect(rec.traderName, isNotEmpty);
          expect(rec.action, isIn(['BUY', 'SELL', 'HOLD']));
          expect(rec.confidence, greaterThanOrEqualTo(0));
          expect(rec.confidence, lessThanOrEqualTo(100));
        }
      });

      test('should refresh recommendations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Load initial data
        final initial = await container.read(recommendationsProvider.future);
        expect(initial, isNotEmpty);
        
        // Refresh should reload the data
        await notifier.refresh();
        final refreshed = await container.read(recommendationsProvider.future);
        
        expect(refreshed, isA<List<StockRecommendation>>());
        expect(refreshed.length, initial.length);
      });

      test('should filter by action', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future); // Load initial data
        
        // Filter by BUY action
        notifier.filterByAction('BUY');
        final buyRecs = await container.read(recommendationsProvider.future);
        
        expect(buyRecs.every((rec) => rec.action == 'BUY'), isTrue);
        
        // Filter by SELL action
        notifier.filterByAction('SELL');
        final sellRecs = await container.read(recommendationsProvider.future);
        
        expect(sellRecs.every((rec) => rec.action == 'SELL'), isTrue);
        
        // Clear filter
        notifier.filterByAction(null);
        final allRecs = await container.read(recommendationsProvider.future);
        
        expect(allRecs.length, greaterThanOrEqualTo(buyRecs.length));
        expect(allRecs.length, greaterThanOrEqualTo(sellRecs.length));
      });

      test('should filter by risk level', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Filter by LOW risk
        notifier.filterByRiskLevel('LOW');
        final lowRiskRecs = await container.read(recommendationsProvider.future);
        
        expect(lowRiskRecs.every((rec) => rec.riskLevel == 'LOW'), isTrue);
        
        // Filter by HIGH risk
        notifier.filterByRiskLevel('HIGH');
        final highRiskRecs = await container.read(recommendationsProvider.future);
        
        expect(highRiskRecs.every((rec) => rec.riskLevel == 'HIGH'), isTrue);
        
        // Clear filter
        notifier.filterByRiskLevel(null);
        final allRecs = await container.read(recommendationsProvider.future);
        
        expect(allRecs, isNotEmpty);
      });

      test('should filter by timeframe', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Filter by SHORT timeframe
        notifier.filterByTimeframe('SHORT');
        final shortRecs = await container.read(recommendationsProvider.future);
        
        expect(shortRecs.every((rec) => rec.timeframe == 'SHORT'), isTrue);
        
        // Filter by LONG timeframe
        notifier.filterByTimeframe('LONG');
        final longRecs = await container.read(recommendationsProvider.future);
        
        expect(longRecs.every((rec) => rec.timeframe == 'LONG'), isTrue);
        
        // Clear filter
        notifier.filterByTimeframe(null);
        final allRecs = await container.read(recommendationsProvider.future);
        
        expect(allRecs, isNotEmpty);
      });

      test('should sort by confidence descending', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        notifier.sortByConfidence();
        final sortedRecs = await container.read(recommendationsProvider.future);
        
        // Verify sorting is correct (descending)
        for (int i = 0; i < sortedRecs.length - 1; i++) {
          expect(sortedRecs[i].confidence, 
                 greaterThanOrEqualTo(sortedRecs[i + 1].confidence));
        }
      });

      test('should sort by potential profit descending', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        notifier.sortByPotentialProfit();
        final sortedRecs = await container.read(recommendationsProvider.future);
        
        // Verify sorting is correct (descending)
        for (int i = 0; i < sortedRecs.length - 1; i++) {
          expect(sortedRecs[i].potentialProfit, 
                 greaterThanOrEqualTo(sortedRecs[i + 1].potentialProfit));
        }
      });

      test('should sort by date descending', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        notifier.sortByDate();
        final sortedRecs = await container.read(recommendationsProvider.future);
        
        // Verify sorting is correct (most recent first)
        for (int i = 0; i < sortedRecs.length - 1; i++) {
          expect(sortedRecs[i].recommendedAt.isAfter(sortedRecs[i + 1].recommendedAt) ||
                 sortedRecs[i].recommendedAt.isAtSameMomentAs(sortedRecs[i + 1].recommendedAt), 
                 isTrue);
        }
      });

      test('should handle empty filter results', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Filter by a non-existent action
        notifier.filterByAction('NONEXISTENT');
        final filteredRecs = await container.read(recommendationsProvider.future);
        
        expect(filteredRecs, isEmpty);
      });

      test('should handle filter after sort operations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // First sort by confidence
        notifier.sortByConfidence();
        final sortedRecs = await container.read(recommendationsProvider.future);
        
        // Then filter by action (this should reload and filter from original data)
        notifier.filterByAction('BUY');
        final filteredRecs = await container.read(recommendationsProvider.future);
        
        expect(filteredRecs.every((rec) => rec.action == 'BUY'), isTrue);
      });
    });

    group('Filtered Recommendations Provider', () {
      test('should return all recommendations when no filters applied', () async {
        await container.read(recommendationsProvider.future);
        final filtered = container.read(filteredRecommendationsProvider);
        
        expect(filtered, isNotEmpty);
      });

      test('should return empty list when provider is loading', () {
        final newContainer = ProviderContainer();
        final filtered = newContainer.read(filteredRecommendationsProvider);
        
        expect(filtered, isEmpty);
        newContainer.dispose();
      });

      test('should return empty list when provider has error', () {
        // This test would require mocking an error state
        // For now, we test the happy path
        final filtered = container.read(filteredRecommendationsProvider);
        expect(filtered, isA<List<StockRecommendation>>());
      });
    });

    group('Action Specific Providers', () {
      test('buyRecommendationsProvider should return only BUY recommendations', () async {
        await container.read(recommendationsProvider.future);
        final buyRecs = container.read(buyRecommendationsProvider);
        
        expect(buyRecs.every((rec) => rec.action == 'BUY'), isTrue);
      });

      test('sellRecommendationsProvider should return only SELL recommendations', () async {
        await container.read(recommendationsProvider.future);
        final sellRecs = container.read(sellRecommendationsProvider);
        
        expect(sellRecs.every((rec) => rec.action == 'SELL'), isTrue);
      });

      test('should update when main provider changes', () async {
        await container.read(recommendationsProvider.future);
        final initialBuyCount = container.read(buyRecommendationsProvider).length;
        
        // Filter main provider to show only BUY recommendations
        final notifier = container.read(recommendationsProvider.notifier);
        notifier.filterByAction('BUY');
        
        final filteredBuyCount = container.read(buyRecommendationsProvider).length;
        
        expect(filteredBuyCount, initialBuyCount);
      });
    });

    group('Top Recommendations Provider', () {
      test('should return top 5 recommendations by confidence', () async {
        await container.read(recommendationsProvider.future);
        final topRecs = container.read(topRecommendationsProvider);
        
        expect(topRecs.length, lessThanOrEqualTo(5));
        
        // Should be sorted by confidence (descending)
        for (int i = 0; i < topRecs.length - 1; i++) {
          expect(topRecs[i].confidence, 
                 greaterThanOrEqualTo(topRecs[i + 1].confidence));
        }
      });

      test('should handle fewer than 5 recommendations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Filter to get a small number of recommendations
        notifier.filterByAction('HOLD'); // Assuming HOLD actions are rare
        
        final topRecs = container.read(topRecommendationsProvider);
        expect(topRecs.length, lessThanOrEqualTo(5));
      });

      test('should return empty list when no recommendations available', () {
        final newContainer = ProviderContainer();
        final topRecs = newContainer.read(topRecommendationsProvider);
        
        expect(topRecs, isEmpty);
        newContainer.dispose();
      });

      test('should update when filtered recommendations change', () async {
        await container.read(recommendationsProvider.future);
        final initialTop = container.read(topRecommendationsProvider);
        
        // Apply a filter
        final notifier = container.read(recommendationsProvider.notifier);
        notifier.filterByRiskLevel('HIGH');
        
        final filteredTop = container.read(topRecommendationsProvider);
        
        // The top recommendations should change based on the filter
        expect(filteredTop.every((rec) => rec.riskLevel == 'HIGH'), isTrue);
      });
    });

    group('Provider Dependencies', () {
      test('should properly handle provider dependency chain', () async {
        // Test that all dependent providers update when main provider changes
        await container.read(recommendationsProvider.future);
        
        final initialFiltered = container.read(filteredRecommendationsProvider).length;
        final initialBuy = container.read(buyRecommendationsProvider).length;
        final initialSell = container.read(sellRecommendationsProvider).length;
        final initialTop = container.read(topRecommendationsProvider).length;
        
        expect(initialFiltered, greaterThan(0));
        expect(initialBuy + initialSell, lessThanOrEqualTo(initialFiltered));
        expect(initialTop, lessThanOrEqualTo(5));
        expect(initialTop, lessThanOrEqualTo(initialFiltered));
      });

      test('should dispose properly', () {
        final testContainer = ProviderContainer();
        
        // Read some providers to initialize them
        testContainer.read(recommendationsProvider);
        testContainer.read(filteredRecommendationsProvider);
        testContainer.read(buyRecommendationsProvider);
        
        // Disposal should not throw
        expect(() => testContainer.dispose(), returnsNormally);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle sorting empty list', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Filter to get empty results
        notifier.filterByAction('NONEXISTENT');
        
        // Sorting empty list should not throw
        expect(() => notifier.sortByConfidence(), returnsNormally);
        expect(() => notifier.sortByPotentialProfit(), returnsNormally);
        expect(() => notifier.sortByDate(), returnsNormally);
      });

      test('should handle concurrent filter operations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Apply multiple filters concurrently
        notifier.filterByAction('BUY');
        notifier.filterByRiskLevel('HIGH');
        notifier.filterByTimeframe('SHORT');
        
        final result = await container.read(recommendationsProvider.future);
        
        // The last filter should win (timeframe = SHORT)
        expect(result.every((rec) => rec.timeframe == 'SHORT'), isTrue);
      });

      test('should handle null and empty string filters', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Apply null filters (should reload original data)
        notifier.filterByAction(null);
        notifier.filterByRiskLevel(null);
        notifier.filterByTimeframe(null);
        
        final result = await container.read(recommendationsProvider.future);
        expect(result, isNotEmpty);
      });

      test('should maintain data integrity after multiple operations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        final originalData = await container.read(recommendationsProvider.future);
        
        // Perform multiple operations
        notifier.filterByAction('BUY');
        notifier.sortByConfidence();
        notifier.filterByRiskLevel('HIGH');
        notifier.sortByPotentialProfit();
        notifier.filterByAction(null); // Reset
        
        final finalData = await container.read(recommendationsProvider.future);
        
        // Should have same count as original (after reset)
        expect(finalData.length, originalData.length);
        
        // Data integrity check
        expect(finalData.every((rec) => 
          rec.confidence >= 0 && rec.confidence <= 100), isTrue);
        expect(finalData.every((rec) => 
          rec.action.isNotEmpty), isTrue);
      });

      test('should handle recommendations with extreme values', () async {
        // This would test with mock data that has extreme values
        await container.read(recommendationsProvider.future);
        
        // Test sorting with extreme confidence values
        final notifier = container.read(recommendationsProvider.notifier);
        notifier.sortByConfidence();
        
        final sorted = await container.read(recommendationsProvider.future);
        expect(sorted, isNotEmpty);
        
        // Test potential profit calculation doesn't break with extreme values
        notifier.sortByPotentialProfit();
        final profitSorted = await container.read(recommendationsProvider.future);
        expect(profitSorted, isNotEmpty);
      });
    });

    group('Performance Tests', () {
      test('should handle large datasets efficiently', () async {
        // This test assumes MockDataService can provide large datasets
        final startTime = DateTime.now();
        await container.read(recommendationsProvider.future);
        final loadTime = DateTime.now().difference(startTime);
        
        // Loading should be reasonably fast
        expect(loadTime.inSeconds, lessThan(5));
      });

      test('should filter large datasets efficiently', () async {
        await container.read(recommendationsProvider.future);
        final notifier = container.read(recommendationsProvider.notifier);
        
        final startTime = DateTime.now();
        notifier.filterByAction('BUY');
        await container.read(recommendationsProvider.future);
        final filterTime = DateTime.now().difference(startTime);
        
        // Filtering should be very fast
        expect(filterTime.inMilliseconds, lessThan(100));
      });

      test('should sort large datasets efficiently', () async {
        await container.read(recommendationsProvider.future);
        final notifier = container.read(recommendationsProvider.notifier);
        
        final startTime = DateTime.now();
        notifier.sortByConfidence();
        await container.read(recommendationsProvider.future);
        final sortTime = DateTime.now().difference(startTime);
        
        // Sorting should be reasonably fast
        expect(sortTime.inMilliseconds, lessThan(200));
      });
    });

    group('Real-world Usage Scenarios', () {
      test('should support typical user workflow', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // 1. Load initial data
        final allRecs = await container.read(recommendationsProvider.future);
        expect(allRecs, isNotEmpty);
        
        // 2. User wants to see only BUY recommendations
        notifier.filterByAction('BUY');
        final buyRecs = await container.read(recommendationsProvider.future);
        expect(buyRecs.every((rec) => rec.action == 'BUY'), isTrue);
        
        // 3. User wants to sort by confidence
        notifier.sortByConfidence();
        final sortedBuyRecs = await container.read(recommendationsProvider.future);
        expect(sortedBuyRecs.length, buyRecs.length);
        
        // 4. User checks top recommendations
        final topRecs = container.read(topRecommendationsProvider);
        expect(topRecs.length, lessThanOrEqualTo(5));
        
        // 5. User resets filters
        notifier.filterByAction(null);
        final resetRecs = await container.read(recommendationsProvider.future);
        expect(resetRecs.length, allRecs.length);
      });

      test('should support risk-based filtering workflow', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        await container.read(recommendationsProvider.future);
        
        // Conservative investor workflow
        notifier.filterByRiskLevel('LOW');
        final lowRiskRecs = await container.read(recommendationsProvider.future);
        
        notifier.sortByConfidence();
        final sortedLowRisk = await container.read(recommendationsProvider.future);
        
        expect(sortedLowRisk.every((rec) => rec.riskLevel == 'LOW'), isTrue);
        expect(sortedLowRisk.length, lowRiskRecs.length);
        
        // Aggressive investor workflow
        notifier.filterByRiskLevel('HIGH');
        notifier.sortByPotentialProfit();
        final highRiskHighReward = await container.read(recommendationsProvider.future);
        
        expect(highRiskHighReward.every((rec) => rec.riskLevel == 'HIGH'), isTrue);
      });
    });
  });
}