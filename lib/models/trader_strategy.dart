class TraderStrategy {
  final String id;
  final String traderId;
  final String traderName;
  final String strategyName;
  final String description;
  final String tradingStyle; // SCALPING, DAY_TRADING, SWING_TRADING, POSITION_TRADING
  final double winRate;
  final double averageReturn;
  final double maxDrawdown;
  final double sharpeRatio;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final List<String> preferredAssets;
  final Map<String, dynamic> performanceMetrics;
  final String riskManagement;
  final double minimumCapital;
  final int followers;
  final double rating; // 1-5
  final bool isActive;
  final String? profileImageUrl;

  TraderStrategy({
    required this.id,
    required this.traderId,
    required this.traderName,
    required this.strategyName,
    required this.description,
    required this.tradingStyle,
    required this.winRate,
    required this.averageReturn,
    required this.maxDrawdown,
    required this.sharpeRatio,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.createdAt,
    required this.lastUpdated,
    required this.preferredAssets,
    required this.performanceMetrics,
    required this.riskManagement,
    required this.minimumCapital,
    required this.followers,
    required this.rating,
    required this.isActive,
    this.profileImageUrl,
  });

  double get lossRate => 100 - winRate;
  double get profitFactor => winningTrades > 0 && losingTrades > 0 
      ? (winningTrades * averageReturn) / (losingTrades * averageReturn.abs()) 
      : 0;

  factory TraderStrategy.fromJson(Map<String, dynamic> json) {
    return TraderStrategy(
      id: json['id'],
      traderId: json['traderId'],
      traderName: json['traderName'],
      strategyName: json['strategyName'],
      description: json['description'],
      tradingStyle: json['tradingStyle'],
      winRate: json['winRate'].toDouble(),
      averageReturn: json['averageReturn'].toDouble(),
      maxDrawdown: json['maxDrawdown'].toDouble(),
      sharpeRatio: json['sharpeRatio'].toDouble(),
      totalTrades: json['totalTrades'],
      winningTrades: json['winningTrades'],
      losingTrades: json['losingTrades'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      preferredAssets: List<String>.from(json['preferredAssets']),
      performanceMetrics: json['performanceMetrics'],
      riskManagement: json['riskManagement'],
      minimumCapital: json['minimumCapital'].toDouble(),
      followers: json['followers'],
      rating: json['rating'].toDouble(),
      isActive: json['isActive'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'traderId': traderId,
      'traderName': traderName,
      'strategyName': strategyName,
      'description': description,
      'tradingStyle': tradingStyle,
      'winRate': winRate,
      'averageReturn': averageReturn,
      'maxDrawdown': maxDrawdown,
      'sharpeRatio': sharpeRatio,
      'totalTrades': totalTrades,
      'winningTrades': winningTrades,
      'losingTrades': losingTrades,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'preferredAssets': preferredAssets,
      'performanceMetrics': performanceMetrics,
      'riskManagement': riskManagement,
      'minimumCapital': minimumCapital,
      'followers': followers,
      'rating': rating,
      'isActive': isActive,
      'profileImageUrl': profileImageUrl,
    };
  }
}