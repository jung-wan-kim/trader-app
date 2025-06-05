class StockRecommendation {
  final String id;
  final String stockCode;
  final String stockName;
  final String traderName;
  final String traderId;
  final String action; // BUY, SELL, HOLD
  final double targetPrice;
  final double currentPrice;
  final double stopLoss;
  final double takeProfit;
  final String reasoning;
  final DateTime recommendedAt;
  final String timeframe; // SHORT, MEDIUM, LONG
  final double confidence; // 0-100
  final String riskLevel; // LOW, MEDIUM, HIGH
  final Map<String, dynamic>? technicalIndicators;
  final double? expectedReturn; // 예상 수익률
  final int likes;
  final int followers;

  StockRecommendation({
    required this.id,
    required this.stockCode,
    required this.stockName,
    required this.traderName,
    required this.traderId,
    required this.action,
    required this.targetPrice,
    required this.currentPrice,
    required this.stopLoss,
    required this.takeProfit,
    required this.reasoning,
    required this.recommendedAt,
    required this.timeframe,
    required this.confidence,
    required this.riskLevel,
    this.technicalIndicators,
    this.expectedReturn,
    this.likes = 0,
    this.followers = 0,
  });

  double get potentialProfit => ((targetPrice - currentPrice) / currentPrice) * 100;
  double get riskRewardRatio => (targetPrice - currentPrice) / (currentPrice - stopLoss);
  
  bool get isBullish => action == 'BUY';
  bool get isBearish => action == 'SELL';

  factory StockRecommendation.fromJson(Map<String, dynamic> json) {
    return StockRecommendation(
      id: json['id'],
      stockCode: json['stockCode'],
      stockName: json['stockName'],
      traderName: json['traderName'],
      traderId: json['traderId'],
      action: json['action'],
      targetPrice: json['targetPrice'].toDouble(),
      currentPrice: json['currentPrice'].toDouble(),
      stopLoss: json['stopLoss'].toDouble(),
      takeProfit: json['takeProfit'].toDouble(),
      reasoning: json['reasoning'],
      recommendedAt: DateTime.parse(json['recommendedAt']),
      timeframe: json['timeframe'],
      confidence: json['confidence'].toDouble(),
      riskLevel: json['riskLevel'],
      technicalIndicators: json['technicalIndicators'],
      expectedReturn: json['expectedReturn']?.toDouble(),
      likes: json['likes'] ?? 0,
      followers: json['followers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stockCode': stockCode,
      'stockName': stockName,
      'traderName': traderName,
      'traderId': traderId,
      'action': action,
      'targetPrice': targetPrice,
      'currentPrice': currentPrice,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'reasoning': reasoning,
      'recommendedAt': recommendedAt.toIso8601String(),
      'timeframe': timeframe,
      'confidence': confidence,
      'riskLevel': riskLevel,
      'technicalIndicators': technicalIndicators,
      'expectedReturn': expectedReturn,
      'likes': likes,
      'followers': followers,
    };
  }
}