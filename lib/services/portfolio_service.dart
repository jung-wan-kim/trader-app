import 'package:supabase_flutter/supabase_flutter.dart';

class PortfolioService {
  final SupabaseClient _client;
  
  PortfolioService(this._client);
  
  /// 포트폴리오 성과 계산
  Future<PortfolioPerformance> calculatePerformance(String portfolioId) async {
    try {
      final response = await _client.functions.invoke(
        'portfolio-management',
        body: {
          'action': 'calculate_performance',
          'portfolioId': portfolioId,
        },
      );
      
      if (response.data == null) {
        throw Exception('No performance data received');
      }
      
      return PortfolioPerformance.fromJson(response.data['performance']);
    } catch (e) {
      throw Exception('Failed to calculate performance: $e');
    }
  }
  
  /// 포트폴리오 목록 조회
  Future<List<Portfolio>> getPortfolios() async {
    try {
      final response = await _client
          .from('portfolios')
          .select()
          .eq('user_id', _client.auth.currentUser!.id)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Portfolio.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch portfolios: $e');
    }
  }
  
  /// 새 포트폴리오 생성
  Future<Portfolio> createPortfolio({
    required String name,
    String? description,
    required double initialCapital,
  }) async {
    try {
      final response = await _client
          .from('portfolios')
          .insert({
            'name': name,
            'description': description,
            'initial_capital': initialCapital,
            'currency': 'USD',
            'user_id': _client.auth.currentUser!.id,
          })
          .select()
          .single();
      
      return Portfolio.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create portfolio: $e');
    }
  }
}

// 포트폴리오 모델
class Portfolio {
  final String id;
  final String name;
  final String? description;
  final double initialCapital;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  
  Portfolio({
    required this.id,
    required this.name,
    this.description,
    required this.initialCapital,
    required this.currency,
    required this.isActive,
    required this.createdAt,
  });
  
  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      initialCapital: (json['initial_capital'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// 포트폴리오 성과 모델
class PortfolioPerformance {
  final String portfolioId;
  final double totalValue;
  final double totalReturn;
  final List<Position> positions;
  
  PortfolioPerformance({
    required this.portfolioId,
    required this.totalValue,
    required this.totalReturn,
    required this.positions,
  });
  
  factory PortfolioPerformance.fromJson(Map<String, dynamic> json) {
    return PortfolioPerformance(
      portfolioId: json['portfolioId'],
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      totalReturn: (json['totalReturn'] ?? 0).toDouble(),
      positions: (json['positions'] as List? ?? [])
          .map((p) => Position.fromJson(p))
          .toList(),
    );
  }
  
  String get formattedTotalValue => '\$${totalValue.toStringAsFixed(2)}';
  String get formattedReturn => '${totalReturn >= 0 ? '+' : ''}${totalReturn.toStringAsFixed(2)}%';
}

class Position {
  final String id;
  final String symbol;
  final int quantity;
  final double entryPrice;
  final double? currentPrice;
  final double? exitPrice;
  final String status;
  
  Position({
    required this.id,
    required this.symbol,
    required this.quantity,
    required this.entryPrice,
    this.currentPrice,
    this.exitPrice,
    required this.status,
  });
  
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      symbol: json['symbol'],
      quantity: json['quantity'],
      entryPrice: (json['entry_price'] ?? 0).toDouble(),
      currentPrice: json['currentPrice']?.toDouble(),
      exitPrice: json['exit_price']?.toDouble(),
      status: json['status'] ?? 'open',
    );
  }
  
  double get currentValue => quantity * (currentPrice ?? exitPrice ?? entryPrice);
  double get costBasis => quantity * entryPrice;
  double get profitLoss => currentValue - costBasis;
  double get profitLossPercent => (profitLoss / costBasis) * 100;
}