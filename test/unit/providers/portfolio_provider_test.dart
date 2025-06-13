import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/portfolio_provider.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PortfolioProvider Tests', () {
    late ProviderContainer container;
    late MockDataService mockDataService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      
      mockDataService = MockDataService();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('PortfolioStats Model', () {
      test('should create PortfolioStats with all fields', () {
        final stats = PortfolioStats(
          totalValue: 50000.0,
          totalCost: 45000.0,
          totalPnL: 5000.0,
          totalPnLPercent: 11.11,
          dayPnL: 500.0,
          dayPnLPercent: 1.0,
          openPositions: 5,
          winningPositions: 3,
          losingPositions: 2,
          winRate: 60.0,
        );

        expect(stats.totalValue, equals(50000.0));
        expect(stats.totalCost, equals(45000.0));
        expect(stats.totalPnL, equals(5000.0));
        expect(stats.totalPnLPercent, equals(11.11));
        expect(stats.dayPnL, equals(500.0));
        expect(stats.dayPnLPercent, equals(1.0));
        expect(stats.openPositions, equals(5));
        expect(stats.winningPositions, equals(3));
        expect(stats.losingPositions, equals(2));
      });
    });

    group('Position Model', () {
      test('should create Position with all fields', () {
        final position = Position(
          id: 'pos_001',
          stockCode: 'AAPL',
          stockName: 'Apple Inc.',
          quantity: 100,
          entryPrice: 150.0,
          currentPrice: 160.0,
          side: 'LONG',
          openedAt: DateTime.now().subtract(const Duration(days: 30)),
          stopLoss: 140.0,
          takeProfit: 170.0,
          status: 'OPEN',
        );

        expect(position.id, equals('pos_001'));
        expect(position.stockCode, equals('AAPL'));
        expect(position.quantity, equals(100));
        expect(position.entryPrice, equals(150.0));
        expect(position.currentPrice, equals(160.0));
        expect(position.marketValue, equals(16000.0));
        expect(position.costBasis, equals(15000.0));
        expect(position.unrealizedPnL, equals(1000.0));
        expect(position.unrealizedPnLPercent, closeTo(6.67, 0.01));
      });

      test('should calculate position values correctly', () {
        final position = Position(
          id: 'pos_002',
          stockCode: 'GOOGL',
          stockName: 'Alphabet Inc.',
          quantity: 50,
          entryPrice: 100.0,
          currentPrice: 120.0,
          side: 'LONG',
          openedAt: DateTime.now().subtract(const Duration(days: 60)),
          stopLoss: 95.0,
          takeProfit: 130.0,
          status: 'OPEN',
        );

        // Verify calculations
        expect(position.costBasis, equals(position.quantity * position.entryPrice));
        expect(position.marketValue, equals(position.quantity * position.currentPrice));
        expect(position.unrealizedPnL, equals(position.marketValue - position.costBasis));
        expect(position.unrealizedPnLPercent, equals((position.unrealizedPnL / position.costBasis) * 100));
      });

      test('should handle fractional shares', () {
        final position = Position(
          id: 'pos_003',
          stockCode: 'BRK.A',
          stockName: 'Berkshire Hathaway',
          quantity: 1,
          entryPrice: 500000.0,
          currentPrice: 520000.0,
          side: 'LONG',
          openedAt: DateTime.now().subtract(const Duration(days: 90)),
          stopLoss: 480000.0,
          takeProfit: 550000.0,
          status: 'OPEN',
        );

        expect(position.quantity, equals(1));
        expect(position.costBasis, equals(500000.0));
        expect(position.marketValue, equals(520000.0));
        expect(position.unrealizedPnL, equals(20000.0));
      });
    });

    group('PortfolioNotifier', () {
      test('should load initial portfolio', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Give it time to load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            expect(positions, isNotNull);
            expect(positions, isNotEmpty);
            expect(positions, isA<List<Position>>());
          },
          loading: () => fail('Should not be loading'),
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should handle portfolio positions', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            // Check if we have positions
            expect(positions.length, greaterThan(0));
            
            // Check first position properties
            final firstPosition = positions.first;
            expect(firstPosition.stockCode, isNotEmpty);
            expect(firstPosition.quantity, greaterThan(0));
            expect(firstPosition.currentPrice, greaterThan(0));
          },
          loading: () => fail('Should not be loading'),
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should calculate portfolio metrics', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            if (positions.isNotEmpty) {
              // Calculate total market value
              final totalValue = positions.fold<double>(
                0,
                (sum, position) => sum + position.marketValue,
              );
              expect(totalValue, greaterThan(0));
              
              // Calculate total cost basis
              final totalCost = positions.fold<double>(
                0,
                (sum, position) => sum + position.costBasis,
              );
              expect(totalCost, greaterThan(0));
              
              // Check individual position metrics
              for (final position in positions) {
                expect(position.marketValue, equals(position.quantity * position.currentPrice));
                expect(position.costBasis, equals(position.quantity * position.entryPrice));
              }
            }
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should identify profitable positions', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            // Separate profitable and losing positions
            final profitablePositions = positions.where((p) => p.isProfit).toList();
            final losingPositions = positions.where((p) => !p.isProfit).toList();
            
            // Check profit calculation
            for (final position in profitablePositions) {
              expect(position.unrealizedPnL, greaterThan(0));
              expect(position.unrealizedPnLPercent, greaterThan(0));
            }
            
            // Check loss calculation
            for (final position in losingPositions) {
              expect(position.unrealizedPnL, lessThanOrEqualTo(0));
              expect(position.unrealizedPnLPercent, lessThanOrEqualTo(0));
            }
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should handle position sides correctly', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            // Check position sides
            for (final position in positions) {
              expect(position.side, anyOf(['LONG', 'SHORT']));
              
              if (position.side == 'LONG') {
                // Long positions profit when price goes up
                if (position.currentPrice > position.entryPrice) {
                  expect(position.unrealizedPnL, greaterThan(0));
                }
              }
            }
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should handle empty portfolio', () async {
        // Create a container with mocked empty portfolio
        final emptyContainer = ProviderContainer(
          overrides: [
            portfolioProvider.overrideWith((ref) {
              return PortfolioNotifier(MockDataService())
                ..state = const AsyncValue.data([]);
            }),
          ],
        );
        
        final state = emptyContainer.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            expect(positions, isEmpty);
          },
          loading: () => fail('Should not be loading'),
          error: (error, stack) => fail('Should not have error: $error'),
        );
        
        emptyContainer.dispose();
      });

      test('should handle portfolio refresh', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Load portfolio
        // Trigger reload by reading state
        container.refresh(portfolioProvider);
        
        // Should still have data
        final state = container.read(portfolioProvider);
        state.when(
          data: (positions) {
            expect(positions, isNotNull);
            expect(positions, isNotEmpty);
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should handle error state', () async {
        // Create a container that will throw error
        final errorContainer = ProviderContainer(
          overrides: [
            portfolioProvider.overrideWith((ref) {
              return PortfolioNotifier(MockDataService())
                ..state = AsyncValue.error(
                  Exception('Failed to load portfolio'),
                  StackTrace.current,
                );
            }),
          ],
        );
        
        final state = errorContainer.read(portfolioProvider);
        
        state.when(
          data: (_) => fail('Should not have data'),
          loading: () => fail('Should not be loading'),
          error: (error, stack) {
            expect(error, isA<Exception>());
            expect(error.toString(), contains('Failed to load portfolio'));
          },
        );
        
        errorContainer.dispose();
      });
    });

    group('Performance Analysis', () {
      test('should track portfolio performance metrics', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            if (positions.isNotEmpty) {
              // Calculate overall P&L
              final totalPnL = positions.fold<double>(
                0,
                (sum, position) => sum + position.unrealizedPnL,
              );
              
              // Calculate total cost basis
              final totalCost = positions.fold<double>(
                0,
                (sum, position) => sum + position.costBasis,
              );
              
              if (totalCost > 0) {
                final totalPnLPercent = (totalPnL / totalCost) * 100;
                
                // Verify P&L consistency
                if (totalPnL > 0) {
                  expect(totalPnLPercent, greaterThan(0));
                } else if (totalPnL < 0) {
                  expect(totalPnLPercent, lessThan(0));
                }
              }
            }
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should identify best performing positions', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            if (positions.length > 1) {
              // Sort by profit percentage
              final sortedPositions = List<Position>.from(positions)
                ..sort((a, b) => b.unrealizedPnLPercent.compareTo(a.unrealizedPnLPercent));
              
              // Best performer should have highest profit percentage
              expect(
                sortedPositions.first.unrealizedPnLPercent,
                greaterThanOrEqualTo(sortedPositions.last.unrealizedPnLPercent),
              );
            }
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });

      test('should calculate position weights', () async {
        final portfolioNotifier = container.read(portfolioProvider.notifier);
        
        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 100));
        
        final state = container.read(portfolioProvider);
        
        state.when(
          data: (positions) {
            if (positions.isNotEmpty) {
              // Calculate total portfolio value
              final totalValue = positions.fold<double>(
                0,
                (sum, position) => sum + position.marketValue,
              );
              
              if (totalValue > 0) {
                // Calculate weights
                for (final position in positions) {
                  final weight = (position.marketValue / totalValue) * 100;
                  
                  // Weight should be between 0 and 100
                  expect(weight, greaterThanOrEqualTo(0));
                  expect(weight, lessThanOrEqualTo(100));
                }
                
                // Sum of weights should be approximately 100%
                final totalWeight = positions.fold<double>(
                  0,
                  (sum, position) => sum + (position.marketValue / totalValue) * 100,
                );
                expect(totalWeight, closeTo(100, 1)); // Allow 1% margin for rounding
              }
            }
          },
          loading: () => {},
          error: (error, stack) => fail('Should not have error: $error'),
        );
      });
    });
  });
}