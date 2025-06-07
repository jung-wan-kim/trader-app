import 'package:supabase_flutter/supabase_flutter.dart';

class MarketService {
  final SupabaseClient _client;
  
  MarketService(this._client);
  
  /// 실시간 주식 시세 조회
  Future<StockQuote> getQuote(String symbol) async {
    try {
      final response = await _client.functions.invoke(
        'market-data',
        body: {
          'action': 'quote',
          'symbol': symbol.toUpperCase(),
        },
      );
      
      if (response.data == null) {
        throw Exception('No data received');
      }
      
      final data = response.data['data'];
      return StockQuote.fromJson(data, symbol);
    } catch (e) {
      throw Exception('Failed to fetch quote: $e');
    }
  }
  
  /// 회사 정보 조회
  Future<CompanyProfile> getCompanyProfile(String symbol) async {
    try {
      final response = await _client.functions.invoke(
        'market-data',
        body: {
          'action': 'profile',
          'symbol': symbol.toUpperCase(),
        },
      );
      
      if (response.data == null) {
        throw Exception('No data received');
      }
      
      final data = response.data['data'];
      return CompanyProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
  
  /// 여러 종목 시세 한번에 조회
  Future<List<StockQuote>> getMultipleQuotes(List<String> symbols) async {
    final quotes = <StockQuote>[];
    
    // 병렬 처리로 성능 향상
    await Future.wait(
      symbols.map((symbol) async {
        try {
          final quote = await getQuote(symbol);
          quotes.add(quote);
        } catch (e) {
          print('Error fetching $symbol: $e');
        }
      }),
    );
    
    return quotes;
  }
}

// 데이터 모델
class StockQuote {
  final String symbol;
  final double currentPrice;
  final double change;
  final double changePercent;
  final double high;
  final double low;
  final double open;
  final double previousClose;
  final int timestamp;
  
  StockQuote({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
    required this.open,
    required this.previousClose,
    required this.timestamp,
  });
  
  factory StockQuote.fromJson(Map<String, dynamic> json, [String? symbol]) {
    return StockQuote(
      symbol: symbol ?? '',
      currentPrice: (json['c'] ?? 0).toDouble(),
      change: (json['d'] ?? 0).toDouble(),
      changePercent: (json['dp'] ?? 0).toDouble(),
      high: (json['h'] ?? 0).toDouble(),
      low: (json['l'] ?? 0).toDouble(),
      open: (json['o'] ?? 0).toDouble(),
      previousClose: (json['pc'] ?? 0).toDouble(),
      timestamp: json['t'] ?? 0,
    );
  }
  
  bool get isPositive => change >= 0;
  
  String get formattedPrice => '\$${currentPrice.toStringAsFixed(2)}';
  String get formattedChange => '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}';
  String get formattedChangePercent => '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
}

class CompanyProfile {
  final String ticker;
  final String name;
  final String country;
  final String currency;
  final String exchange;
  final String industry;
  final String logo;
  final String weburl;
  final double marketCap;
  
  CompanyProfile({
    required this.ticker,
    required this.name,
    required this.country,
    required this.currency,
    required this.exchange,
    required this.industry,
    required this.logo,
    required this.weburl,
    required this.marketCap,
  });
  
  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      ticker: json['ticker'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      currency: json['currency'] ?? 'USD',
      exchange: json['exchange'] ?? '',
      industry: json['finnhubIndustry'] ?? '',
      logo: json['logo'] ?? '',
      weburl: json['weburl'] ?? '',
      marketCap: (json['marketCapitalization'] ?? 0).toDouble(),
    );
  }
  
  String get formattedMarketCap {
    if (marketCap >= 1000000) {
      return '\$${(marketCap / 1000000).toStringAsFixed(2)}T';
    } else if (marketCap >= 1000) {
      return '\$${(marketCap / 1000).toStringAsFixed(2)}B';
    }
    return '\$${marketCap.toStringAsFixed(2)}M';
  }
}