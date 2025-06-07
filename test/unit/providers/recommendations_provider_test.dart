import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/providers/mock_data_provider.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/services/mock_data_service.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('RecommendationsProvider Tests', () {
    late ProviderContainer container;

    setUpAll(() async {
      container = ProviderContainer();
      // Force provider to initialize
      container.read(recommendationsProvider);
      // Wait for initial load to complete
      await Future.delayed(const Duration(milliseconds: 700));
    });

    tearDownAll(() {
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
      test('should have loaded state after initialization', () async {
        final state = container.read(recommendationsProvider);
        expect(state, isA<AsyncData<List<StockRecommendation>>>());
      });

      test('should have loaded recommendations successfully', () async {
        final state = container.read(recommendationsProvider);
        
        expect(state, isA<AsyncData<List<StockRecommendation>>>());
        
        state.whenData((recommendations) {
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
      });

      test('should refresh recommendations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        final initialState = container.read(recommendationsProvider);
        expect(initialState, isA<AsyncData>());
        
        int initialLength = 0;
        initialState.whenData((data) {
          initialLength = data.length;
        });
        
        // Refresh should reload the data
        await notifier.refresh();
        
        final refreshedState = container.read(recommendationsProvider);
        expect(refreshedState, isA<AsyncData>());
        
        refreshedState.whenData((data) {
          expect(data.length, initialLength);
        });
      });

      test('should filter by action', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        // Filter by BUY action
        notifier.filterByAction('BUY');
        
        final buyState = container.read(recommendationsProvider);
        buyState.whenData((buyRecs) {
          expect(buyRecs.every((rec) => rec.action == 'BUY'), isTrue);
        });
        
        // Filter by SELL action
        notifier.filterByAction('SELL');
        
        final sellState = container.read(recommendationsProvider);
        sellState.whenData((sellRecs) {
          expect(sellRecs.every((rec) => rec.action == 'SELL'), isTrue);
        });
        
        // Clear filter
        await notifier.refresh();
        
        final allState = container.read(recommendationsProvider);
        allState.whenData((allRecs) {
          expect(allRecs, isNotEmpty);
        });
      });

      test('should filter by risk level', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        // Filter by LOW risk
        notifier.filterByRiskLevel('LOW');
        
        final lowRiskState = container.read(recommendationsProvider);
        lowRiskState.whenData((lowRiskRecs) {
          if (lowRiskRecs.isNotEmpty) {
            expect(lowRiskRecs.every((rec) => rec.riskLevel == 'LOW'), isTrue);
          }
        });
        
        // Filter by HIGH risk
        notifier.filterByRiskLevel('HIGH');
        
        final highRiskState = container.read(recommendationsProvider);
        highRiskState.whenData((highRiskRecs) {
          if (highRiskRecs.isNotEmpty) {
            expect(highRiskRecs.every((rec) => rec.riskLevel == 'HIGH'), isTrue);
          }
        });
        
        // Clear filter
        await notifier.refresh();
        
        final allState = container.read(recommendationsProvider);
        allState.whenData((allRecs) {
          expect(allRecs, isNotEmpty);
        });
      });

      test('should filter by timeframe', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        // Filter by SHORT timeframe
        notifier.filterByTimeframe('SHORT');
        
        final shortState = container.read(recommendationsProvider);
        shortState.whenData((shortRecs) {
          if (shortRecs.isNotEmpty) {
            expect(shortRecs.every((rec) => rec.timeframe == 'SHORT'), isTrue);
          }
        });
        
        // Filter by LONG timeframe
        notifier.filterByTimeframe('LONG');
        
        final longState = container.read(recommendationsProvider);
        longState.whenData((longRecs) {
          if (longRecs.isNotEmpty) {
            expect(longRecs.every((rec) => rec.timeframe == 'LONG'), isTrue);
          }
        });
        
        // Clear filter
        await notifier.refresh();
        
        final allState = container.read(recommendationsProvider);
        allState.whenData((allRecs) {
          expect(allRecs, isNotEmpty);
        });
      });

      test('should sort by confidence descending', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        notifier.sortByConfidence();
        
        final sortedState = container.read(recommendationsProvider);
        sortedState.whenData((sortedRecs) {
          // Verify sorting is correct (descending)
          for (int i = 0; i < sortedRecs.length - 1; i++) {
            expect(sortedRecs[i].confidence, 
                   greaterThanOrEqualTo(sortedRecs[i + 1].confidence));
          }
        });
      });

      test('should sort by potential profit descending', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        notifier.sortByPotentialProfit();
        
        final sortedState = container.read(recommendationsProvider);
        sortedState.whenData((sortedRecs) {
          // Verify sorting is correct (descending)
          for (int i = 0; i < sortedRecs.length - 1; i++) {
            expect(sortedRecs[i].potentialProfit, 
                   greaterThanOrEqualTo(sortedRecs[i + 1].potentialProfit));
          }
        });
      });

      test('should sort by date descending', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        notifier.sortByDate();
        
        final sortedState = container.read(recommendationsProvider);
        sortedState.whenData((sortedRecs) {
          // Verify sorting is correct (most recent first)
          for (int i = 0; i < sortedRecs.length - 1; i++) {
            expect(sortedRecs[i].recommendedAt.isAfter(sortedRecs[i + 1].recommendedAt) ||
                   sortedRecs[i].recommendedAt.isAtSameMomentAs(sortedRecs[i + 1].recommendedAt), 
                   isTrue);
          }
        });
      });

      test('should handle empty filter results', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Filter by a non-existent action
        notifier.filterByAction('NONEXISTENT');
        
        final filteredState = container.read(recommendationsProvider);
        filteredState.whenData((filteredRecs) {
          expect(filteredRecs, isEmpty);
        });
        
        // Restore original data
        await notifier.refresh();
      });

      test('should handle filter after sort operations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // First refresh to get original data
        await notifier.refresh();
        
        // First sort by confidence
        notifier.sortByConfidence();
        
        // Then filter by action
        notifier.filterByAction('BUY');
        
        final filteredState = container.read(recommendationsProvider);
        filteredState.whenData((filteredRecs) {
          if (filteredRecs.isNotEmpty) {
            expect(filteredRecs.every((rec) => rec.action == 'BUY'), isTrue);
          }
        });
        
        // Restore original data
        await notifier.refresh();
      });
    });

    group('Filtered Recommendations Provider', () {
      test('should return all recommendations when no filters applied', () async {
        final filtered = container.read(filteredRecommendationsProvider);
        expect(filtered, isNotEmpty);
      });

      test('should update when main provider updates', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Apply a filter
        notifier.filterByAction('BUY');
        
        final filtered = container.read(filteredRecommendationsProvider);
        expect(filtered.every((rec) => rec.action == 'BUY'), isTrue);
        
        // Restore original data
        await notifier.refresh();
      });
    });

    group('Action Specific Providers', () {
      test('buyRecommendationsProvider should return only BUY recommendations', () async {
        final buyRecs = container.read(buyRecommendationsProvider);
        
        if (buyRecs.isNotEmpty) {
          expect(buyRecs.every((rec) => rec.action == 'BUY'), isTrue);
        }
      });

      test('sellRecommendationsProvider should return only SELL recommendations', () async {
        final sellRecs = container.read(sellRecommendationsProvider);
        
        if (sellRecs.isNotEmpty) {
          expect(sellRecs.every((rec) => rec.action == 'SELL'), isTrue);
        }
      });
    });

    group('Top Recommendations Provider', () {
      test('should return top 5 recommendations by confidence', () async {
        final topRecs = container.read(topRecommendationsProvider);
        
        expect(topRecs.length, lessThanOrEqualTo(5));
        
        // Should be sorted by confidence (descending)
        for (int i = 0; i < topRecs.length - 1; i++) {
          expect(topRecs[i].confidence, 
                 greaterThanOrEqualTo(topRecs[i + 1].confidence));
        }
      });

      test('should update when filtered recommendations change', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Apply a filter
        notifier.filterByRiskLevel('HIGH');
        
        final filteredTop = container.read(topRecommendationsProvider);
        
        // The top recommendations should be filtered
        if (filteredTop.isNotEmpty) {
          expect(filteredTop.every((rec) => rec.riskLevel == 'HIGH'), isTrue);
        }
        
        // Restore original data
        await notifier.refresh();
      });
    });

    group('Provider Dependencies', () {
      test('should properly handle provider dependency chain', () async {
        final initialFiltered = container.read(filteredRecommendationsProvider).length;
        final initialBuy = container.read(buyRecommendationsProvider).length;
        final initialSell = container.read(sellRecommendationsProvider).length;
        final initialTop = container.read(topRecommendationsProvider).length;
        
        expect(initialFiltered, greaterThan(0));
        expect(initialBuy + initialSell, lessThanOrEqualTo(initialFiltered));
        expect(initialTop, lessThanOrEqualTo(5));
        expect(initialTop, lessThanOrEqualTo(initialFiltered));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle sorting empty list', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Filter to get empty results
        notifier.filterByAction('NONEXISTENT');
        
        // Sorting empty list should not throw
        expect(() => notifier.sortByConfidence(), returnsNormally);
        expect(() => notifier.sortByPotentialProfit(), returnsNormally);
        expect(() => notifier.sortByDate(), returnsNormally);
        
        // Restore original data
        await notifier.refresh();
      });

      test('should handle concurrent filter operations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Apply multiple filters concurrently
        notifier.filterByAction('BUY');
        notifier.filterByRiskLevel('HIGH');
        notifier.filterByTimeframe('SHORT');
        
        final state = container.read(recommendationsProvider);
        state.whenData((result) {
          // The last filter should win (timeframe = SHORT)
          if (result.isNotEmpty) {
            expect(result.every((rec) => rec.timeframe == 'SHORT'), isTrue);
          }
        });
        
        // Restore original data
        await notifier.refresh();
      });

      test('should maintain data integrity after multiple operations', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        await notifier.refresh();
        
        int originalCount = 0;
        final originalState = container.read(recommendationsProvider);
        originalState.whenData((data) {
          originalCount = data.length;
        });
        
        // Perform multiple operations
        notifier.filterByAction('BUY');
        notifier.sortByConfidence();
        notifier.filterByRiskLevel('HIGH');
        notifier.sortByPotentialProfit();
        
        // Refresh to reset
        await notifier.refresh();
        
        final finalState = container.read(recommendationsProvider);
        finalState.whenData((finalData) {
          // Should have same count as original (after reset)
          expect(finalData.length, originalCount);
          
          // Data integrity check
          expect(finalData.every((rec) => 
            rec.confidence >= 0 && rec.confidence <= 100), isTrue);
          expect(finalData.every((rec) => 
            rec.action.isNotEmpty), isTrue);
        });
      });
    });

    group('Real-world Usage Scenarios', () {
      test('should support typical user workflow', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Start fresh
        await notifier.refresh();
        
        int allRecsCount = 0;
        final initialState = container.read(recommendationsProvider);
        initialState.whenData((allRecs) {
          expect(allRecs, isNotEmpty);
          allRecsCount = allRecs.length;
        });
        
        // User wants to see only BUY recommendations
        notifier.filterByAction('BUY');
        
        int buyRecsCount = 0;
        final buyState = container.read(recommendationsProvider);
        buyState.whenData((buyRecs) {
          if (buyRecs.isNotEmpty) {
            expect(buyRecs.every((rec) => rec.action == 'BUY'), isTrue);
            buyRecsCount = buyRecs.length;
          }
        });
        
        // User wants to sort by confidence
        notifier.sortByConfidence();
        
        final sortedState = container.read(recommendationsProvider);
        sortedState.whenData((sortedBuyRecs) {
          expect(sortedBuyRecs.length, buyRecsCount);
        });
        
        // User checks top recommendations
        final topRecs = container.read(topRecommendationsProvider);
        expect(topRecs.length, lessThanOrEqualTo(5));
        
        // User resets filters
        await notifier.refresh();
        
        final resetState = container.read(recommendationsProvider);
        resetState.whenData((resetRecs) {
          expect(resetRecs.length, allRecsCount);
        });
      });

      test('should support risk-based filtering workflow', () async {
        final notifier = container.read(recommendationsProvider.notifier);
        
        // Start fresh
        await notifier.refresh();
        
        // Conservative investor workflow
        notifier.filterByRiskLevel('LOW');
        
        int lowRiskCount = 0;
        final lowRiskState = container.read(recommendationsProvider);
        lowRiskState.whenData((lowRiskRecs) {
          if (lowRiskRecs.isNotEmpty) {
            expect(lowRiskRecs.every((rec) => rec.riskLevel == 'LOW'), isTrue);
            lowRiskCount = lowRiskRecs.length;
          }
        });
        
        notifier.sortByConfidence();
        
        final sortedLowRiskState = container.read(recommendationsProvider);
        sortedLowRiskState.whenData((sortedLowRisk) {
          if (sortedLowRisk.isNotEmpty) {
            expect(sortedLowRisk.every((rec) => rec.riskLevel == 'LOW'), isTrue);
            expect(sortedLowRisk.length, lowRiskCount);
          }
        });
        
        // Aggressive investor workflow
        notifier.filterByRiskLevel('HIGH');
        notifier.sortByPotentialProfit();
        
        final highRiskState = container.read(recommendationsProvider);
        highRiskState.whenData((highRiskHighReward) {
          if (highRiskHighReward.isNotEmpty) {
            expect(highRiskHighReward.every((rec) => rec.riskLevel == 'HIGH'), isTrue);
          }
        });
        
        // Restore original data
        await notifier.refresh();
      });
    });
  });
}