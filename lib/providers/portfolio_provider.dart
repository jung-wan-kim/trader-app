import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_recommendation.dart';
import '../models/position.dart';
import '../services/portfolio_service.dart';
import '../services/mock_data_service.dart';
import 'mock_data_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PortfolioNotifier extends StateNotifier<AsyncValue<List<Position>>> {
  final PortfolioService? _portfolioService;
  final MockDataService _mockDataService;
  
  PortfolioNotifier(this._portfolioService, this._mockDataService) : super(const AsyncValue.loading()) {
    loadPositions();
  }

  Future<void> loadPositions() async {
    try {
      state = const AsyncValue.loading();
      
      // 실제 포트폴리오 서비스가 있으면 사용
      if (_portfolioService != null) {
        try {
          // 먼저 사용자의 활성 포트폴리오 ID 가져오기
          final portfolioResponse = await Supabase.instance.client
              .from('portfolios')
              .select('id')
              .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
              .eq('is_active', true)
              .maybeSingle();
          
          if (portfolioResponse != null) {
            final portfolioId = portfolioResponse['id'];
            
            // 해당 포트폴리오의 positions 조회
            final response = await Supabase.instance.client
                .from('positions')
                .select()
                .eq('portfolio_id', portfolioId)
                .eq('status', 'OPEN')
                .order('opened_at', ascending: false);
          
            final positions = (response as List)
                .map((json) => Position.fromJson(json))
                .toList();
            
            state = AsyncValue.data(positions);
          } else {
            // 활성 포트폴리오가 없으면 빈 리스트 반환
            state = AsyncValue.data([]);
          }
        } catch (e) {
          // 실제 데이터 조회 실패 시 Mock 데이터 사용
          print('Failed to load positions from Supabase: $e');
          print('Using mock data as fallback');
          final positions = _generateMockPositions();
          state = AsyncValue.data(positions);
        }
      } else {
        // 인증되지 않은 경우 Mock 데이터 사용
        final positions = _generateMockPositions();
        state = AsyncValue.data(positions);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  List<Position> _generateMockPositions() {
    return [
      Position(
        id: '1',
        stockCode: 'AAPL',
        stockName: 'Apple Inc.',
        entryPrice: 175.50,
        currentPrice: 182.30,
        quantity: 100,
        side: 'LONG',
        openedAt: DateTime.now().subtract(const Duration(days: 5)),
        stopLoss: 170.00,
        takeProfit: 190.00,
        status: 'OPEN',
      ),
      Position(
        id: '2',
        stockCode: 'MSFT',
        stockName: 'Microsoft Corp.',
        entryPrice: 380.00,
        currentPrice: 375.50,
        quantity: 50,
        side: 'LONG',
        openedAt: DateTime.now().subtract(const Duration(days: 3)),
        stopLoss: 370.00,
        takeProfit: 395.00,
        status: 'OPEN',
      ),
      Position(
        id: '3',
        stockCode: 'GOOGL',
        stockName: 'Alphabet Inc.',
        entryPrice: 140.00,
        currentPrice: 145.75,
        quantity: 75,
        side: 'LONG',
        openedAt: DateTime.now().subtract(const Duration(days: 10)),
        stopLoss: 135.00,
        takeProfit: 150.00,
        status: 'OPEN',
      ),
      Position(
        id: '4',
        stockCode: 'TSLA',
        stockName: 'Tesla Inc.',
        entryPrice: 220.00,
        currentPrice: 215.00,
        quantity: 30,
        side: 'LONG',
        openedAt: DateTime.now().subtract(const Duration(days: 2)),
        stopLoss: 210.00,
        takeProfit: 235.00,
        status: 'OPEN',
      ),
      Position(
        id: '5',
        stockCode: 'NVDA',
        stockName: 'NVIDIA Corp.',
        entryPrice: 480.00,
        currentPrice: 495.50,
        quantity: 25,
        side: 'LONG',
        openedAt: DateTime.now().subtract(const Duration(days: 7)),
        stopLoss: 470.00,
        takeProfit: 510.00,
        status: 'OPEN',
      ),
    ];
  }

  Future<void> openPosition(StockRecommendation recommendation, int quantity) async {
    try {
      final newPosition = Position(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        stockCode: recommendation.stockCode,
        stockName: recommendation.stockName,
        entryPrice: recommendation.currentPrice,
        currentPrice: recommendation.currentPrice,
        quantity: quantity,
        side: recommendation.action == 'BUY' ? 'LONG' : 'SHORT',
        openedAt: DateTime.now(),
        stopLoss: recommendation.stopLoss,
        takeProfit: recommendation.takeProfit,
        recommendationId: recommendation.id,
        status: 'OPEN',
      );
      
      // 실제 데이터베이스에 저장
      if (_portfolioService != null) {
        try {
          // 먼저 사용자의 활성 포트폴리오 ID 가져오기
          final portfolioResponse = await Supabase.instance.client
              .from('portfolios')
              .select('id')
              .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
              .eq('is_active', true)
              .maybeSingle();
          
          if (portfolioResponse != null) {
            final portfolioId = portfolioResponse['id'];
            
            final response = await Supabase.instance.client
                .from('positions')
                .insert({
                  'portfolio_id': portfolioId,
                  'symbol': newPosition.stockCode,
                  'stock_name': newPosition.stockName,
                  'entry_price': newPosition.entryPrice,
                  'current_price': newPosition.currentPrice,
                  'quantity': newPosition.quantity,
                  'side': newPosition.side,
                  'opened_at': newPosition.openedAt.toIso8601String(),
                  'stop_loss': newPosition.stopLoss,
                  'take_profit': newPosition.takeProfit,
                  'recommendation_id': newPosition.recommendationId,
                  'status': newPosition.status,
                })
                .select()
                .single();
          
            // DB에서 반환된 ID로 업데이트
            final savedPosition = Position.fromJson(response);
            
            state.whenData((positions) {
              state = AsyncValue.data([...positions, savedPosition]);
            });
          } else {
            throw Exception('No active portfolio found for user');
          }
        } catch (e) {
          print('Failed to save position to database: $e');
          // DB 저장 실패 시에도 로컬 상태에는 추가
          state.whenData((positions) {
            state = AsyncValue.data([...positions, newPosition]);
          });
        }
      } else {
        // 인증되지 않은 경우 로컬 상태에만 추가
        state.whenData((positions) {
          state = AsyncValue.data([...positions, newPosition]);
        });
      }
    } catch (e) {
      print('Error opening position: $e');
    }
  }

  Future<void> closePosition(String positionId) async {
    try {
      // 실제 데이터베이스에서 업데이트
      if (_portfolioService != null) {
        try {
          await Supabase.instance.client
              .from('positions')
              .update({
                'status': 'CLOSED',
                'closed_at': DateTime.now().toIso8601String(),
              })
              .eq('id', positionId);
        } catch (e) {
          print('Failed to close position in database: $e');
        }
      }
      
      // 로컬 상태 업데이트
      state.whenData((positions) {
        final updatedPositions = positions.map((p) {
          if (p.id == positionId) {
            return p.copyWith(status: 'CLOSED');
          }
          return p;
        }).toList();
        state = AsyncValue.data(updatedPositions);
      });
    } catch (e) {
      print('Error closing position: $e');
    }
  }

  Future<void> updatePositionPrice(String stockCode, double newPrice) async {
    try {
      // 실제 데이터베이스에 가격 업데이트
      if (_portfolioService != null) {
        try {
          await Supabase.instance.client
              .from('positions')
              .update({
                'current_price': newPrice,
              })
              .eq('symbol', stockCode)
              .eq('status', 'OPEN');
        } catch (e) {
          print('Failed to update price in database: $e');
        }
      }
      
      // 로컬 상태 업데이트
      state.whenData((positions) {
        final updatedPositions = positions.map((p) {
          if (p.stockCode == stockCode && p.status == 'OPEN') {
            return Position(
              id: p.id,
              stockCode: p.stockCode,
              stockName: p.stockName,
              entryPrice: p.entryPrice,
              currentPrice: newPrice,
              quantity: p.quantity,
              side: p.side,
              openedAt: p.openedAt,
              stopLoss: p.stopLoss,
              takeProfit: p.takeProfit,
              recommendationId: p.recommendationId,
              status: p.status,
            );
          }
          return p;
        }).toList();
        state = AsyncValue.data(updatedPositions);
      });
    } catch (e) {
      print('Error updating position price: $e');
    }
  }

  Future<void> updatePosition(Position updatedPosition) async {
    try {
      // 실제 데이터베이스에 업데이트
      if (_portfolioService != null) {
        try {
          await Supabase.instance.client
              .from('positions')
              .update({
                'quantity': updatedPosition.quantity,
                'stop_loss': updatedPosition.stopLoss,
                'take_profit': updatedPosition.takeProfit,
                'current_price': updatedPosition.currentPrice,
              })
              .eq('id', updatedPosition.id);
        } catch (e) {
          print('Failed to update position in database: $e');
        }
      }
      
      // 로컬 상태 업데이트
      state.whenData((positions) {
        final updatedPositions = positions.map((p) {
          if (p.id == updatedPosition.id) {
            return updatedPosition;
          }
          return p;
        }).toList();
        state = AsyncValue.data(updatedPositions);
      });
    } catch (e) {
      print('Error updating position: $e');
    }
  }
}

// Provider definitions
final portfolioServiceProvider = Provider<PortfolioService?>((ref) {
  final supabase = Supabase.instance.client;
  if (supabase.auth.currentUser != null) {
    return PortfolioService(supabase);
  }
  return null;
});

final portfolioProvider = 
    StateNotifierProvider<PortfolioNotifier, AsyncValue<List<Position>>>((ref) {
  final portfolioService = ref.watch(portfolioServiceProvider);
  final mockDataService = ref.watch(mockDataServiceProvider);
  return PortfolioNotifier(portfolioService, mockDataService);
});

final openPositionsProvider = Provider<List<Position>>((ref) {
  final portfolioAsync = ref.watch(portfolioProvider);
  return portfolioAsync.maybeWhen(
    data: (positions) => positions.where((p) => p.status == 'OPEN').toList(),
    orElse: () => [],
  );
});

final portfolioStatsProvider = Provider<PortfolioStats>((ref) {
  final positions = ref.watch(openPositionsProvider);
  
  if (positions.isEmpty) {
    return PortfolioStats(
      totalValue: 0,
      totalCost: 0,
      totalPnL: 0,
      totalPnLPercent: 0,
      dayPnL: 0,
      dayPnLPercent: 0,
      openPositions: 0,
      winningPositions: 0,
      losingPositions: 0,
      winRate: 0,
    );
  }

  final totalValue = positions.fold(0.0, (sum, p) => sum + p.marketValue);
  final totalCost = positions.fold(0.0, (sum, p) => sum + p.costBasis);
  final totalPnL = totalValue - totalCost;
  final totalPnLPercent = totalCost == 0 ? 0.0 : (totalPnL / totalCost) * 100;
  
  final winningPositions = positions.where((p) => p.isProfit).length;
  final losingPositions = positions.where((p) => !p.isProfit).length;
  final winRate = positions.isNotEmpty ? (winningPositions / positions.length) * 100 : 0;

  // Mock day P&L (실제로는 일일 가격 변동 데이터가 필요)
  final dayPnL = totalPnL * 0.1; // 임시 값
  final dayPnLPercent = totalCost == 0 ? 0.0 : (dayPnL / totalCost) * 100;

  return PortfolioStats(
    totalValue: totalValue,
    totalCost: totalCost,
    totalPnL: totalPnL,
    totalPnLPercent: totalPnLPercent,
    dayPnL: dayPnL,
    dayPnLPercent: dayPnLPercent,
    openPositions: positions.length,
    winningPositions: winningPositions,
    losingPositions: losingPositions,
    winRate: winRate.toDouble(),
  );
});