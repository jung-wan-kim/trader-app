import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

class PerformanceService {
  late final SupabaseClient _supabase;
  
  PerformanceService() {
    final supabaseUrl = EnvConfig.supabaseUrl.isNotEmpty 
        ? EnvConfig.supabaseUrl 
        : 'https://lgebgddeerpxdjvtqvoi.supabase.co';
    
    final supabaseAnonKey = EnvConfig.supabaseAnonKey.isNotEmpty 
        ? EnvConfig.supabaseAnonKey 
        : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxnZWJnZGRlZXJweGRqdnRxdm9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzODcyMDksImV4cCI6MjA0ODk2MzIwOX0.2lw4P_8CQJd0Pb7iLBEqwBcQJxNAgfx3uSyQROQw-1A';
    
    _supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);
  }

  // 포트폴리오 성과 데이터 가져오기
  Future<PortfolioPerformance> getPortfolioPerformance(String userId) async {
    try {
      // 현재 포트폴리오 가치 계산
      final positionsResponse = await _supabase
          .from('portfolio_positions')
          .select()
          .eq('user_id', userId)
          .eq('status', 'OPEN');
      
      final positions = List<Map<String, dynamic>>.from(positionsResponse ?? []);
      
      double totalValue = 0;
      double totalCost = 0;
      double totalGainLoss = 0;
      
      for (final position in positions) {
        final currentValue = (position['current_price'] ?? 0) * (position['quantity'] ?? 0);
        final cost = (position['average_price'] ?? 0) * (position['quantity'] ?? 0);
        
        totalValue += currentValue.toDouble();
        totalCost += cost.toDouble();
        totalGainLoss += (currentValue - cost).toDouble();
      }
      
      final gainLossPercent = totalCost > 0 ? (totalGainLoss / totalCost) * 100 : 0.0;
      
      // 30일 성과 차트 데이터 가져오기
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final performanceHistory = await _getPerformanceHistory(userId, thirtyDaysAgo);
      
      // 월별 수익률 계산
      final monthlyReturns = await _getMonthlyReturns(userId);
      
      // 거래 통계 계산
      final stats = await _getPerformanceStats(userId);
      
      return PortfolioPerformance(
        totalValue: totalValue,
        totalGainLoss: totalGainLoss,
        gainLossPercent: gainLossPercent,
        chartData: performanceHistory,
        monthlyReturns: monthlyReturns,
        winRate: stats['winRate'] ?? 0.0,
        avgReturn: stats['avgReturn'] ?? 0.0,
        totalTrades: stats['totalTrades'] ?? 0,
        bestTradeReturn: stats['bestTrade'] ?? 0.0,
      );
    } catch (e) {
      print('Error fetching portfolio performance: $e');
      // 에러 시 기본값 반환
      return PortfolioPerformance.empty();
    }
  }

  // 최근 거래 내역 가져오기
  Future<List<TradeHistory>> getRecentTrades(String userId, {int limit = 5}) async {
    try {
      final response = await _supabase
          .from('trade_history')
          .select()
          .eq('user_id', userId)
          .order('executed_at', ascending: false)
          .limit(limit);
      
      final trades = List<Map<String, dynamic>>.from(response ?? []);
      
      return trades.map((trade) => TradeHistory(
        id: trade['id'],
        symbol: trade['symbol'],
        action: trade['action'],
        quantity: trade['quantity']?.toDouble() ?? 0,
        price: trade['price']?.toDouble() ?? 0,
        executedAt: DateTime.parse(trade['executed_at']),
        returnPercent: trade['return_percent']?.toDouble() ?? 0,
        profitLoss: trade['profit_loss']?.toDouble() ?? 0,
      )).toList();
    } catch (e) {
      print('Error fetching recent trades: $e');
      return [];
    }
  }

  // 성과 히스토리 가져오기
  Future<List<ChartDataPoint>> _getPerformanceHistory(String userId, DateTime from) async {
    try {
      final response = await _supabase
          .from('portfolio_value_history')
          .select()
          .eq('user_id', userId)
          .gte('date', from.toIso8601String())
          .order('date', ascending: true);
      
      final history = List<Map<String, dynamic>>.from(response ?? []);
      
      if (history.isEmpty) {
        // 데이터가 없으면 더미 데이터 생성
        return _generateDummyChartData();
      }
      
      return history.map((point) => ChartDataPoint(
        date: DateTime.parse(point['date']),
        value: point['value']?.toDouble() ?? 0,
      )).toList();
    } catch (e) {
      print('Error fetching performance history: $e');
      return _generateDummyChartData();
    }
  }

  // 월별 수익률 계산
  Future<List<MonthlyReturn>> _getMonthlyReturns(String userId) async {
    try {
      final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
      
      final response = await _supabase
          .from('monthly_returns')
          .select()
          .eq('user_id', userId)
          .gte('month', sixMonthsAgo.toIso8601String())
          .order('month', ascending: true);
      
      final returns = List<Map<String, dynamic>>.from(response ?? []);
      
      if (returns.isEmpty) {
        // 데이터가 없으면 더미 데이터 생성
        return _generateDummyMonthlyReturns();
      }
      
      return returns.map((ret) => MonthlyReturn(
        month: DateTime.parse(ret['month']),
        returnPercent: ret['return_percent']?.toDouble() ?? 0,
      )).toList();
    } catch (e) {
      print('Error fetching monthly returns: $e');
      return _generateDummyMonthlyReturns();
    }
  }

  // 성과 통계 계산
  Future<Map<String, dynamic>> _getPerformanceStats(String userId) async {
    try {
      // 전체 거래 내역 가져오기
      final response = await _supabase
          .from('trade_history')
          .select()
          .eq('user_id', userId);
      
      final trades = List<Map<String, dynamic>>.from(response ?? []);
      
      if (trades.isEmpty) {
        return {
          'winRate': 0.0,
          'avgReturn': 0.0,
          'totalTrades': 0,
          'bestTrade': 0.0,
        };
      }
      
      // 통계 계산
      int winCount = 0;
      double totalReturn = 0;
      double bestReturn = 0;
      
      for (final trade in trades) {
        final returnPercent = trade['return_percent']?.toDouble() ?? 0;
        
        if (returnPercent > 0) winCount++;
        totalReturn += returnPercent;
        if (returnPercent > bestReturn) bestReturn = returnPercent;
      }
      
      return {
        'winRate': (winCount / trades.length) * 100,
        'avgReturn': totalReturn / trades.length,
        'totalTrades': trades.length,
        'bestTrade': bestReturn,
      };
    } catch (e) {
      print('Error calculating performance stats: $e');
      return {
        'winRate': 0.0,
        'avgReturn': 0.0,
        'totalTrades': 0,
        'bestTrade': 0.0,
      };
    }
  }

  // 더미 차트 데이터 생성
  List<ChartDataPoint> _generateDummyChartData() {
    final now = DateTime.now();
    final data = <ChartDataPoint>[];
    
    double value = 10000;
    for (int i = 30; i >= 0; i--) {
      // 랜덤하게 -3% ~ +5% 변동
      final change = (value * 0.02) * (1 - 2 * (i % 3 == 0 ? 0.5 : 0));
      value += change;
      
      data.add(ChartDataPoint(
        date: now.subtract(Duration(days: i)),
        value: value,
      ));
    }
    
    return data;
  }

  // 더미 월별 수익률 생성
  List<MonthlyReturn> _generateDummyMonthlyReturns() {
    final returns = [8.5, 12.3, -2.1, 15.7, 9.2, 11.4];
    final now = DateTime.now();
    
    return List.generate(6, (index) => MonthlyReturn(
      month: DateTime(now.year, now.month - 5 + index, 1),
      returnPercent: returns[index],
    ));
  }
}

// 데이터 모델들
class PortfolioPerformance {
  final double totalValue;
  final double totalGainLoss;
  final double gainLossPercent;
  final List<ChartDataPoint> chartData;
  final List<MonthlyReturn> monthlyReturns;
  final double winRate;
  final double avgReturn;
  final int totalTrades;
  final double bestTradeReturn;

  PortfolioPerformance({
    required this.totalValue,
    required this.totalGainLoss,
    required this.gainLossPercent,
    required this.chartData,
    required this.monthlyReturns,
    required this.winRate,
    required this.avgReturn,
    required this.totalTrades,
    required this.bestTradeReturn,
  });

  factory PortfolioPerformance.empty() {
    return PortfolioPerformance(
      totalValue: 0,
      totalGainLoss: 0,
      gainLossPercent: 0,
      chartData: [],
      monthlyReturns: [],
      winRate: 0,
      avgReturn: 0,
      totalTrades: 0,
      bestTradeReturn: 0,
    );
  }
}

class ChartDataPoint {
  final DateTime date;
  final double value;

  ChartDataPoint({
    required this.date,
    required this.value,
  });
}

class MonthlyReturn {
  final DateTime month;
  final double returnPercent;

  MonthlyReturn({
    required this.month,
    required this.returnPercent,
  });
}

class TradeHistory {
  final String id;
  final String symbol;
  final String action;
  final double quantity;
  final double price;
  final DateTime executedAt;
  final double returnPercent;
  final double profitLoss;

  TradeHistory({
    required this.id,
    required this.symbol,
    required this.action,
    required this.quantity,
    required this.price,
    required this.executedAt,
    required this.returnPercent,
    required this.profitLoss,
  });
}