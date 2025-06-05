import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/portfolio_provider.dart';
import 'package:trader_app/services/mock_data_service.dart';
import '../../helpers/test_helper.dart';

void main() {
  group('PortfolioProvider Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Position Model', () {
      late Position testPosition;

      setUp(() {
        testPosition = Position(
          id: 'test-1',
          stockCode: 'AAPL',
          stockName: 'Apple Inc.',
          entryPrice: 150.0,
          currentPrice: 160.0,
          quantity: 100,
          side: 'LONG',
          openedAt: DateTime(2024, 1, 1),
          stopLoss: 145.0,
          takeProfit: 170.0,
          recommendationId: 'rec-1',
          status: 'OPEN',
        );
      });

      test('should calculate market value correctly', () {
        expect(testPosition.marketValue, 16000.0); // 100 * 160
      });

      test('should calculate cost basis correctly', () {
        expect(testPosition.costBasis, 15000.0); // 100 * 150
      });

      test('should calculate unrealized P&L correctly', () {
        expect(testPosition.unrealizedPnL, 1000.0); // 16000 - 15000
      });

      test('should calculate unrealized P&L percentage correctly', () {
        expect(testPosition.unrealizedPnLPercent, closeTo(6.67, 0.01)); // (1000/15000) * 100
      });

      test('should identify profit positions correctly', () {
        expect(testPosition.isProfit, isTrue);

        final lossPosition = Position(
          id: 'test-2',
          stockCode: 'MSFT',
          stockName: 'Microsoft',
          entryPrice: 300.0,
          currentPrice: 280.0,
          quantity: 50,
          side: 'LONG',
          openedAt: DateTime.now(),
          status: 'OPEN',
        );

        expect(lossPosition.isProfit, isFalse);
      });

      test('should handle zero quantity', () {
        final zeroPosition = Position(
          id: 'zero',
          stockCode: 'TEST',
          stockName: 'Test Stock',
          entryPrice: 100.0,
          currentPrice: 110.0,
          quantity: 0,
          side: 'LONG',
          openedAt: DateTime.now(),
          status: 'OPEN',
        );

        expect(zeroPosition.marketValue, 0.0);
        expect(zeroPosition.costBasis, 0.0);
        expect(zeroPosition.unrealizedPnL, 0.0);
      });

      test('should handle negative prices for short positions', () {
        final shortPosition = Position(
          id: 'short',
          stockCode: 'XYZ',
          stockName: 'XYZ Corp',
          entryPrice: 200.0,
          currentPrice: 180.0,
          quantity: 50,
          side: 'SHORT',
          openedAt: DateTime.now(),
          status: 'OPEN',
        );

        // For short positions, profit when current < entry
        expect(shortPosition.marketValue, 9000.0); // 50 * 180
        expect(shortPosition.costBasis, 10000.0); // 50 * 200
        expect(shortPosition.unrealizedPnL, -1000.0); // Market calculation (not short logic)
      });
    });

    group('PortfolioStats Model', () {
      test('should create portfolio stats with all fields', () {
        final stats = PortfolioStats(
          totalValue: 100000.0,
          totalCost: 95000.0,
          totalPnL: 5000.0,
          totalPnLPercent: 5.26,
          dayPnL: 500.0,
          dayPnLPercent: 0.53,
          openPositions: 5,
          winningPositions: 3,
          losingPositions: 2,
          winRate: 60.0,
        );

        expect(stats.totalValue, 100000.0);
        expect(stats.totalCost, 95000.0);
        expect(stats.totalPnL, 5000.0);
        expect(stats.totalPnLPercent, 5.26);
        expect(stats.dayPnL, 500.0);
        expect(stats.dayPnLPercent, 0.53);
        expect(stats.openPositions, 5);
        expect(stats.winningPositions, 3);
        expect(stats.losingPositions, 2);
        expect(stats.winRate, 60.0);
      });
    });

    group('PortfolioNotifier', () {
      test('should initialize with loading state', () {
        final notifier = container.read(portfolioProvider.notifier);
        final state = container.read(portfolioProvider);
        
        expect(state, isA<AsyncLoading>());
      });

      test('should load mock positions successfully', () async {
        final positions = await container.read(portfolioProvider.future);
        
        expect(positions, isA<List<Position>>());
        expect(positions, isNotEmpty);
        expect(positions.length, 5); // Mock data has 5 positions
      });

      test('should open new position from recommendation', () async {
        final notifier = container.read(portfolioProvider.notifier);
        final recommendation = TestHelper.createMockStockRecommendation(
          stockCode: 'NVDA',
          stockName: 'NVIDIA Corp',
          currentPrice: 500.0,
          action: 'BUY',
        );

        await notifier.openPosition(recommendation, 10);
        
        final positions = await container.read(portfolioProvider.future);
        final nvidiaPosition = positions.firstWhere(
          (p) => p.stockCode == 'NVDA' && p.recommendationId == recommendation.id,
        );

        expect(nvidiaPosition.stockCode, 'NVDA');
        expect(nvidiaPosition.stockName, 'NVIDIA Corp');
        expect(nvidiaPosition.quantity, 10);
        expect(nvidiaPosition.side, 'LONG');
        expect(nvidiaPosition.status, 'OPEN');
        expect(nvidiaPosition.entryPrice, 500.0);
      });

      test('should create SHORT position for SELL recommendation', () async {
        final notifier = container.read(portfolioProvider.notifier);
        final recommendation = TestHelper.createMockStockRecommendation(
          action: 'SELL',
        );

        await notifier.openPosition(recommendation, 20);
        
        final positions = await container.read(portfolioProvider.future);
        final shortPosition = positions.firstWhere(
          (p) => p.recommendationId == recommendation.id,
        );

        expect(shortPosition.side, 'SHORT');
      });

      test('should close position by ID', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future); // Load initial positions
        
        final positions = await container.read(portfolioProvider.future);
        final positionToClose = positions.first;
        
        await notifier.closePosition(positionToClose.id);
        
        final updatedPositions = await container.read(portfolioProvider.future);
        final closedPosition = updatedPositions.firstWhere(
          (p) => p.id == positionToClose.id,
        );
        
        expect(closedPosition.status, 'CLOSED');
      });

      test('should update position price by stock code', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future); // Load initial positions
        
        const newPrice = 200.0;
        await notifier.updatePositionPrice('AAPL', newPrice);
        
        final positions = await container.read(portfolioProvider.future);
        final applePositions = positions.where((p) => p.stockCode == 'AAPL' && p.status == 'OPEN');
        
        for (final position in applePositions) {
          expect(position.currentPrice, newPrice);
        }
      });

      test('should not update closed positions', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future);
        
        final positions = await container.read(portfolioProvider.future);
        final firstPosition = positions.first;
        
        // Close the position first
        await notifier.closePosition(firstPosition.id);
        
        // Try to update price
        await notifier.updatePositionPrice(firstPosition.stockCode, 999.0);
        
        final updatedPositions = await container.read(portfolioProvider.future);
        final closedPosition = updatedPositions.firstWhere(
          (p) => p.id == firstPosition.id,
        );
        
        // Price should not be updated for closed position
        expect(closedPosition.currentPrice, isNot(999.0));
      });
    });

    group('openPositionsProvider', () {
      test('should return only open positions', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future);
        
        final allPositions = await container.read(portfolioProvider.future);
        final firstPosition = allPositions.first;
        
        // Close one position
        await notifier.closePosition(firstPosition.id);
        
        final openPositions = container.read(openPositionsProvider);
        
        expect(openPositions.length, allPositions.length - 1);
        expect(openPositions.every((p) => p.status == 'OPEN'), isTrue);
        expect(openPositions.any((p) => p.id == firstPosition.id), isFalse);
      });

      test('should return empty list when no positions loaded', () {
        final newContainer = ProviderContainer();
        final openPositions = newContainer.read(openPositionsProvider);
        
        expect(openPositions, isEmpty);
        newContainer.dispose();
      });
    });

    group('portfolioStatsProvider', () {
      test('should calculate stats for empty portfolio', () {
        final newContainer = ProviderContainer();
        final stats = newContainer.read(portfolioStatsProvider);
        
        expect(stats.totalValue, 0);
        expect(stats.totalCost, 0);
        expect(stats.totalPnL, 0);
        expect(stats.totalPnLPercent, 0);
        expect(stats.openPositions, 0);
        expect(stats.winningPositions, 0);
        expect(stats.losingPositions, 0);
        expect(stats.winRate, 0);
        
        newContainer.dispose();
      });

      test('should calculate correct portfolio statistics', () async {
        await container.read(portfolioProvider.future); // Load positions
        final stats = container.read(portfolioStatsProvider);
        
        expect(stats.totalValue, greaterThan(0));
        expect(stats.totalCost, greaterThan(0));
        expect(stats.openPositions, greaterThan(0));
        expect(stats.winRate, greaterThanOrEqualTo(0));
        expect(stats.winRate, lessThanOrEqualTo(100));
        
        // Total P&L should equal totalValue - totalCost
        expect(stats.totalPnL, closeTo(stats.totalValue - stats.totalCost, 0.01));
        
        // Win + Loss positions should equal total open positions
        expect(stats.winningPositions + stats.losingPositions, stats.openPositions);
      });

      test('should update stats when positions change', () async {
        await container.read(portfolioProvider.future);
        final initialStats = container.read(portfolioStatsProvider);
        
        // Add a new profitable position
        final notifier = container.read(portfolioProvider.notifier);
        final recommendation = TestHelper.createMockStockRecommendation(
          stockCode: 'PROFITABLE',
          currentPrice: 100.0,
          targetPrice: 150.0,
        );
        
        await notifier.openPosition(recommendation, 100);
        // Update price to make it profitable
        await notifier.updatePositionPrice('PROFITABLE', 120.0);
        
        final newStats = container.read(portfolioStatsProvider);
        
        expect(newStats.openPositions, initialStats.openPositions + 1);
        expect(newStats.totalValue, greaterThan(initialStats.totalValue));
        expect(newStats.totalCost, greaterThan(initialStats.totalCost));
      });

      test('should calculate win rate correctly', () async {
        // Create a controlled scenario
        final newContainer = ProviderContainer();
        final notifier = newContainer.read(portfolioProvider.notifier);
        
        // Add 2 winning positions
        for (int i = 0; i < 2; i++) {
          final rec = TestHelper.createMockStockRecommendation(
            id: 'win-$i',
            stockCode: 'WIN$i',
            currentPrice: 100.0,
          );
          await notifier.openPosition(rec, 10);
          await notifier.updatePositionPrice('WIN$i', 110.0); // +10% profit
        }
        
        // Add 1 losing position
        final lossRec = TestHelper.createMockStockRecommendation(
          id: 'loss-1',
          stockCode: 'LOSS1',
          currentPrice: 100.0,
        );
        await notifier.openPosition(lossRec, 10);
        await notifier.updatePositionPrice('LOSS1', 90.0); // -10% loss
        
        final stats = newContainer.read(portfolioStatsProvider);
        
        expect(stats.openPositions, 3);
        expect(stats.winningPositions, 2);
        expect(stats.losingPositions, 1);
        expect(stats.winRate, closeTo(66.67, 0.01)); // 2/3 * 100
        
        newContainer.dispose();
      });

      test('should handle division by zero in P&L calculation', () {
        // This is a edge case test - in practice, costBasis should never be 0
        // if there are open positions, but we test defensive programming
        final newContainer = ProviderContainer();
        final stats = newContainer.read(portfolioStatsProvider);
        
        // With no positions, percentages should be 0
        expect(stats.totalPnLPercent, 0);
        expect(stats.dayPnLPercent, 0);
        
        newContainer.dispose();
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle concurrent position operations', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future);
        
        final rec1 = TestHelper.createMockStockRecommendation(id: '1', stockCode: 'STOCK1');
        final rec2 = TestHelper.createMockStockRecommendation(id: '2', stockCode: 'STOCK2');
        
        // Open multiple positions concurrently
        await Future.wait([
          notifier.openPosition(rec1, 10),
          notifier.openPosition(rec2, 20),
        ]);
        
        final positions = await container.read(portfolioProvider.future);
        expect(positions.where((p) => p.stockCode == 'STOCK1'), hasLength(1));
        expect(positions.where((p) => p.stockCode == 'STOCK2'), hasLength(1));
      });

      test('should handle very large position quantities', () async {
        final notifier = container.read(portfolioProvider.notifier);
        final recommendation = TestHelper.createMockStockRecommendation(
          currentPrice: 1.0,
        );
        
        await notifier.openPosition(recommendation, 1000000); // 1 million shares
        
        final positions = await container.read(portfolioProvider.future);
        final largePosition = positions.firstWhere(
          (p) => p.recommendationId == recommendation.id,
        );
        
        expect(largePosition.quantity, 1000000);
        expect(largePosition.marketValue, 1000000.0);
      });

      test('should handle positions with zero prices', () {
        final zeroPosition = Position(
          id: 'zero-price',
          stockCode: 'ZERO',
          stockName: 'Zero Corp',
          entryPrice: 0.0,
          currentPrice: 0.0,
          quantity: 100,
          side: 'LONG',
          openedAt: DateTime.now(),
          status: 'OPEN',
        );
        
        expect(zeroPosition.marketValue, 0.0);
        expect(zeroPosition.costBasis, 0.0);
        expect(zeroPosition.unrealizedPnL, 0.0);
        // This should not throw an exception
        expect(() => zeroPosition.unrealizedPnLPercent, returnsNormally);
      });

      test('should handle negative quantities', () {
        final negativePosition = Position(
          id: 'negative',
          stockCode: 'NEG',
          stockName: 'Negative Corp',
          entryPrice: 100.0,
          currentPrice: 110.0,
          quantity: -50, // Negative quantity
          side: 'LONG',
          openedAt: DateTime.now(),
          status: 'OPEN',
        );
        
        expect(negativePosition.marketValue, -5500.0); // -50 * 110
        expect(negativePosition.costBasis, -5000.0); // -50 * 100
        expect(negativePosition.unrealizedPnL, -500.0);
      });

      test('should handle update price for non-existent stock', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future);
        
        final initialPositions = await container.read(portfolioProvider.future);
        
        // Try to update price for stock that doesn't exist
        await notifier.updatePositionPrice('NONEXISTENT', 999.0);
        
        final finalPositions = await container.read(portfolioProvider.future);
        
        // Positions should remain unchanged
        expect(finalPositions.length, initialPositions.length);
        expect(finalPositions.any((p) => p.currentPrice == 999.0), isFalse);
      });

      test('should handle close non-existent position', () async {
        final notifier = container.read(portfolioProvider.notifier);
        await container.read(portfolioProvider.future);
        
        final initialPositions = await container.read(portfolioProvider.future);
        
        // Try to close position that doesn't exist
        await notifier.closePosition('non-existent-id');
        
        final finalPositions = await container.read(portfolioProvider.future);
        
        // Positions should remain unchanged
        expect(finalPositions.length, initialPositions.length);
      });
    });

    group('Performance and Memory', () {
      test('should handle large number of positions', () async {
        final newContainer = ProviderContainer();
        final notifier = newContainer.read(portfolioProvider.notifier);
        
        // Add many positions
        for (int i = 0; i < 100; i++) {
          final rec = TestHelper.createMockStockRecommendation(
            id: 'pos-$i',
            stockCode: 'STOCK$i',
          );
          await notifier.openPosition(rec, 10);
        }
        
        final positions = await newContainer.read(portfolioProvider.future);
        final stats = newContainer.read(portfolioStatsProvider);
        
        expect(positions.length, greaterThan(100)); // Include initial mock positions
        expect(stats.openPositions, greaterThan(100));
        
        newContainer.dispose();
      });

      test('should calculate stats efficiently for large portfolios', () async {
        final newContainer = ProviderContainer();
        final notifier = newContainer.read(portfolioProvider.notifier);
        
        // Create a large portfolio
        for (int i = 0; i < 500; i++) {
          final rec = TestHelper.createMockStockRecommendation(
            id: 'large-$i',
            stockCode: 'LRG$i',
            currentPrice: 100.0 + (i % 50), // Varying prices
          );
          await notifier.openPosition(rec, 10);
        }
        
        final startTime = DateTime.now();
        final stats = newContainer.read(portfolioStatsProvider);
        final endTime = DateTime.now();
        
        // Stats calculation should be fast (less than 100ms for 500 positions)
        final duration = endTime.difference(startTime);
        expect(duration.inMilliseconds, lessThan(100));
        
        expect(stats.openPositions, greaterThan(500));
        expect(stats.totalValue, greaterThan(0));
        
        newContainer.dispose();
      });
    });
  });
}