class WatchlistItem {
  final String id;
  final String userId;
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChange;
  final double changePercent;
  final String volume;
  final DateTime addedAt;
  final DateTime? lastUpdated;

  WatchlistItem({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChange,
    required this.changePercent,
    required this.volume,
    required this.addedAt,
    this.lastUpdated,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange: (json['price_change'] ?? 0).toDouble(),
      changePercent: (json['change_percent'] ?? 0).toDouble(),
      volume: json['volume'] ?? '0',
      addedAt: DateTime.parse(json['added_at'] ?? DateTime.now().toIso8601String()),
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'symbol': symbol,
      'name': name,
      'current_price': currentPrice,
      'price_change': priceChange,
      'change_percent': changePercent,
      'volume': volume,
      'added_at': addedAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  WatchlistItem copyWith({
    String? id,
    String? userId,
    String? symbol,
    String? name,
    double? currentPrice,
    double? priceChange,
    double? changePercent,
    String? volume,
    DateTime? addedAt,
    DateTime? lastUpdated,
  }) {
    return WatchlistItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChange: priceChange ?? this.priceChange,
      changePercent: changePercent ?? this.changePercent,
      volume: volume ?? this.volume,
      addedAt: addedAt ?? this.addedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}