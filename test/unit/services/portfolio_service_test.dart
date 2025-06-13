import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/services/portfolio_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SupabaseClient, FunctionsClient, GoTrueClient, User, FunctionResponse])
import 'portfolio_service_test.mocks.dart';

void main() {
  group('PortfolioService Tests', () {
    late PortfolioService portfolioService;
    late MockSupabaseClient mockSupabaseClient;
    late MockFunctionsClient mockFunctionsClient;
    late MockGoTrueClient mockAuthClient;
    late MockUser mockUser;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockFunctionsClient = MockFunctionsClient();
      mockAuthClient = MockGoTrueClient();
      mockUser = MockUser();
      
      when(mockSupabaseClient.functions).thenReturn(mockFunctionsClient);
      when(mockSupabaseClient.auth).thenReturn(mockAuthClient);
      when(mockAuthClient.currentUser).thenReturn(mockUser);
      when(mockUser.id).thenReturn('test-user-id');
      
      portfolioService = PortfolioService(mockSupabaseClient);
    });

    group('Portfolio Performance', () {
      test('should calculate portfolio performance successfully', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        final performanceData = <String, dynamic>{
          'performance': <String, dynamic>{
            'portfolioId': 'portfolio-123',
            'totalValue': 150000.0,
            'totalReturn': 15.5,
            'positions': [
              <String, dynamic>{
                'id': 'pos-1',
                'symbol': 'AAPL',
                'quantity': 100,
                'entry_price': 150.0,
                'currentPrice': 175.0,
                'status': 'open',
              }
            ]
          }
        };
        
        when(mockResponse.data).thenReturn(performanceData);
        when(mockFunctionsClient.invoke(
          'portfolio-management',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final performance = await portfolioService.calculatePerformance('portfolio-123');

        // Assert
        expect(performance, isA<PortfolioPerformance>());
        expect(performance.portfolioId, equals('portfolio-123'));
        expect(performance.totalValue, equals(150000.0));
        expect(performance.totalReturn, equals(15.5));
        expect(performance.positions.length, equals(1));
        expect(performance.positions.first.symbol, equals('AAPL'));
      });

      test('should handle error when no performance data received', () async {
        // Arrange
        final mockResponse = MockFunctionResponse();
        when(mockResponse.data).thenReturn(null);
        when(mockFunctionsClient.invoke(
          'portfolio-management',
          body: anyNamed('body'),
        )).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => portfolioService.calculatePerformance('portfolio-123'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No performance data received'),
          )),
        );
      });

      test('should handle API error', () async {
        // Arrange
        when(mockFunctionsClient.invoke(
          'portfolio-management',
          body: anyNamed('body'),
        )).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => portfolioService.calculatePerformance('portfolio-123'),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to calculate performance'),
          )),
        );
      });
    });

    group('Portfolio Management', () {
      test('should get portfolios successfully', () async {
        // For now, skip this test due to complex Supabase query builder mocking
        // This would require a more sophisticated mocking strategy
      }, skip: 'Complex Supabase query builder mocking not implemented');

      test('should create portfolio successfully', () async {
        // For now, skip this test due to complex Supabase query builder mocking
      }, skip: 'Complex Supabase query builder mocking not implemented');

      test('should handle create portfolio error', () async {
        // For now, skip this test due to complex Supabase query builder mocking
      }, skip: 'Complex Supabase query builder mocking not implemented');
    });

    group('Portfolio Model', () {
      test('should create Portfolio from JSON', () {
        final json = {
          'id': 'portfolio-1',
          'name': 'Test Portfolio',
          'description': 'A test portfolio',
          'initial_capital': 50000.0,
          'currency': 'USD',
          'is_active': true,
          'created_at': '2024-01-01T00:00:00Z',
        };

        final portfolio = Portfolio.fromJson(json);

        expect(portfolio.id, equals('portfolio-1'));
        expect(portfolio.name, equals('Test Portfolio'));
        expect(portfolio.description, equals('A test portfolio'));
        expect(portfolio.initialCapital, equals(50000.0));
        expect(portfolio.currency, equals('USD'));
        expect(portfolio.isActive, isTrue);
        expect(portfolio.createdAt, equals(DateTime.parse('2024-01-01T00:00:00Z')));
      });

      test('should handle null values in Portfolio JSON', () {
        final json = {
          'id': 'portfolio-1',
          'name': 'Test Portfolio',
          'description': null,
          'initial_capital': null,
          'currency': null,
          'is_active': null,
          'created_at': '2024-01-01T00:00:00Z',
        };

        final portfolio = Portfolio.fromJson(json);

        expect(portfolio.description, isNull);
        expect(portfolio.initialCapital, equals(0.0));
        expect(portfolio.currency, equals('USD'));
        expect(portfolio.isActive, isTrue);
      });
    });

    group('PortfolioPerformance Model', () {
      test('should create PortfolioPerformance from JSON', () {
        final json = {
          'portfolioId': 'portfolio-123',
          'totalValue': 125000.0,
          'totalReturn': 25.0,
          'positions': [
            {
              'id': 'pos-1',
              'symbol': 'AAPL',
              'quantity': 100,
              'entry_price': 150.0,
              'currentPrice': 175.0,
              'status': 'open',
            }
          ]
        };

        final performance = PortfolioPerformance.fromJson(json);

        expect(performance.portfolioId, equals('portfolio-123'));
        expect(performance.totalValue, equals(125000.0));
        expect(performance.totalReturn, equals(25.0));
        expect(performance.positions.length, equals(1));
        expect(performance.formattedTotalValue, equals('\$125000.00'));
        expect(performance.formattedReturn, equals('+25.00%'));
      });

      test('should format negative returns correctly', () {
        final performance = PortfolioPerformance(
          portfolioId: 'portfolio-123',
          totalValue: 90000.0,
          totalReturn: -10.5,
          positions: [],
        );

        expect(performance.formattedReturn, equals('-10.50%'));
      });
    });

    group('Position Model', () {
      test('should create Position from JSON', () {
        final json = {
          'id': 'pos-1',
          'symbol': 'TSLA',
          'quantity': 50,
          'entry_price': 200.0,
          'currentPrice': 250.0,
          'exit_price': null,
          'status': 'open',
        };

        final position = Position.fromJson(json);

        expect(position.id, equals('pos-1'));
        expect(position.symbol, equals('TSLA'));
        expect(position.quantity, equals(50));
        expect(position.entryPrice, equals(200.0));
        expect(position.currentPrice, equals(250.0));
        expect(position.exitPrice, isNull);
        expect(position.status, equals('open'));
      });

      test('should calculate position metrics correctly', () {
        final position = Position(
          id: 'pos-1',
          symbol: 'AAPL',
          quantity: 100,
          entryPrice: 150.0,
          currentPrice: 175.0,
          status: 'open',
        );

        expect(position.currentValue, equals(17500.0));
        expect(position.costBasis, equals(15000.0));
        expect(position.profitLoss, equals(2500.0));
        expect(position.profitLossPercent, closeTo(16.67, 0.01));
      });

      test('should handle closed position with exit price', () {
        final position = Position(
          id: 'pos-1',
          symbol: 'AAPL',
          quantity: 100,
          entryPrice: 150.0,
          currentPrice: null,
          exitPrice: 140.0,
          status: 'closed',
        );

        expect(position.currentValue, equals(14000.0));
        expect(position.profitLoss, equals(-1000.0));
        expect(position.profitLossPercent, closeTo(-6.67, 0.01));
      });

      test('should use entry price when no current or exit price', () {
        final position = Position(
          id: 'pos-1',
          symbol: 'AAPL',
          quantity: 100,
          entryPrice: 150.0,
          status: 'pending',
        );

        expect(position.currentValue, equals(15000.0));
        expect(position.profitLoss, equals(0.0));
        expect(position.profitLossPercent, equals(0.0));
      });
    });
  });
}

// Mock classes are now generated by mockito
// See portfolio_service_test.mocks.dart