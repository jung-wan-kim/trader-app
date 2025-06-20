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

  Position copyWith({
    String? id,
    String? stockCode,
    String? stockName,
    double? entryPrice,
    double? currentPrice,
    int? quantity,
    String? side,
    DateTime? openedAt,
    double? stopLoss,
    double? takeProfit,
    String? recommendationId,
    String? status,
    bool clearStopLoss = false,
    bool clearTakeProfit = false,
  }) {
    return Position(
      id: id ?? this.id,
      stockCode: stockCode ?? this.stockCode,
      stockName: stockName ?? this.stockName,
      entryPrice: entryPrice ?? this.entryPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      quantity: quantity ?? this.quantity,
      side: side ?? this.side,
      openedAt: openedAt ?? this.openedAt,
      stopLoss: clearStopLoss ? null : (stopLoss ?? this.stopLoss),
      takeProfit: clearTakeProfit ? null : (takeProfit ?? this.takeProfit),
      recommendationId: recommendationId ?? this.recommendationId,
      status: status ?? this.status,
    );
  }

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      stockCode: json['stock_code'],
      stockName: json['stock_name'],
      entryPrice: (json['entry_price'] ?? 0).toDouble(),
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      side: json['side'] ?? 'LONG',
      openedAt: DateTime.parse(json['opened_at']),
      stopLoss: json['stop_loss']?.toDouble(),
      takeProfit: json['take_profit']?.toDouble(),
      recommendationId: json['recommendation_id'],
      status: json['status'] ?? 'OPEN',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock_code': stockCode,
      'stock_name': stockName,
      'entry_price': entryPrice,
      'current_price': currentPrice,
      'quantity': quantity,
      'side': side,
      'opened_at': openedAt.toIso8601String(),
      'stop_loss': stopLoss,
      'take_profit': takeProfit,
      'recommendation_id': recommendationId,
      'status': status,
    };
  }
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