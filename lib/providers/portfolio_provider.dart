import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_recommendation.dart';
import '../services/mock_data_service.dart';
import 'mock_data_provider.dart';

class Position {
  final String id;
  final String stockCode;
  final String stockName;
  final double entryPrice;
  final double currentPrice;
  final int quantity;
  final String side; // LONG, SHORT
  final DateTime openedAt;
  final double? stopLoss;
  final double? takeProfit;
  final String? recommendationId;
  final String status; // OPEN, CLOSED

  Position({
    required this.id,
    required this.stockCode,
    required this.stockName,
    required this.entryPrice,
    required this.currentPrice,
    required this.quantity,
    required this.side,
    required this.openedAt,
    this.stopLoss,
    this.takeProfit,
    this.recommendationId,
    required this.status,
  });

  double get marketValue => quantity * currentPrice;
  double get costBasis => quantity * entryPrice;
  double get unrealizedPnL => marketValue - costBasis;
  double get unrealizedPnLPercent => costBasis == 0 ? 0 : ((marketValue - costBasis) / costBasis) * 100;
  bool get isProfit => unrealizedPnL > 0;
}

class PortfolioStats {
  final double totalValue;
  final double totalCost;
  final double totalPnL;
  final double totalPnLPercent;
  final double dayPnL;
  final double dayPnLPercent;
  final int openPositions;
  final int winningPositions;
  final int losingPositions;
  final double winRate;

  PortfolioStats({
    required this.totalValue,
    required this.totalCost,
    required this.totalPnL,
    required this.totalPnLPercent,
    required this.dayPnL,
    required this.dayPnLPercent,
    required this.openPositions,
    required this.winningPositions,
    required this.losingPositions,
    required this.winRate,
  });
}

class PortfolioNotifier extends StateNotifier<AsyncValue<List<Position>>> {
  final MockDataService _mockDataService;
  
  PortfolioNotifier(this._mockDataService) : super(const AsyncValue.loading()) {
    loadPositions();
  }

  Future<void> loadPositions() async {
    try {
      state = const AsyncValue.loading();
      // Mock positions data
      final positions = _generateMockPositions();
      state = AsyncValue.data(positions);
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
    state.whenData((positions) {
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
      state = AsyncValue.data([...positions, newPosition]);
    });
  }

  Future<void> closePosition(String positionId) async {
    state.whenData((positions) {
      final updatedPositions = positions.map((p) {
        if (p.id == positionId) {
          return Position(
            id: p.id,
            stockCode: p.stockCode,
            stockName: p.stockName,
            entryPrice: p.entryPrice,
            currentPrice: p.currentPrice,
            quantity: p.quantity,
            side: p.side,
            openedAt: p.openedAt,
            stopLoss: p.stopLoss,
            takeProfit: p.takeProfit,
            recommendationId: p.recommendationId,
            status: 'CLOSED',
          );
        }
        return p;
      }).toList();
      state = AsyncValue.data(updatedPositions);
    });
  }

  Future<void> updatePositionPrice(String stockCode, double newPrice) async {
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
  }
}

// Provider definitions
final portfolioProvider = 
    StateNotifierProvider<PortfolioNotifier, AsyncValue<List<Position>>>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return PortfolioNotifier(mockDataService);
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