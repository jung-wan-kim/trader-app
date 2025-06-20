import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/watchlist_item.dart';
import '../config/env_config.dart';
import './finnhub_service.dart';

class WatchlistService {
  late final SupabaseClient _supabase;
  final FinnhubService _finnhubService = FinnhubService();
  
  WatchlistService() {
    if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
      throw Exception('Supabase configuration not found. Please check your environment variables.');
    }
    
    _supabase = SupabaseClient(EnvConfig.supabaseUrl, EnvConfig.supabaseAnonKey);
  }

  Future<List<WatchlistItem>> getUserWatchlist(String userId) async {
    try {
      final response = await _supabase
          .from('watchlists')
          .select()
          .eq('user_id', userId)
          .order('added_at', ascending: false);

      if (response == null) return [];

      final List<WatchlistItem> items = [];
      
      for (final item in response as List<dynamic>) {
        try {
          // 실시간 가격 정보 가져오기
          final priceData = await _finnhubService.getStockQuote(item['symbol']);
          
          final watchlistItem = WatchlistItem(
            id: item['id'] ?? '',
            userId: item['user_id'] ?? '',
            symbol: item['symbol'] ?? '',
            name: item['name'] ?? '',
            currentPrice: priceData['c'] ?? 0.0,
            priceChange: priceData['d'] ?? 0.0,
            changePercent: priceData['dp'] ?? 0.0,
            volume: _formatVolume(priceData['volume'] ?? 0),
            addedAt: DateTime.parse(item['added_at'] ?? DateTime.now().toIso8601String()),
            lastUpdated: DateTime.now(),
          );
          
          items.add(watchlistItem);
        } catch (e) {
          print('Error fetching price for ${item['symbol']}: $e');
          // 가격 정보를 가져올 수 없는 경우 기본값 사용
          items.add(WatchlistItem.fromJson(item));
        }
      }

      return items;
    } catch (e) {
      print('Error fetching watchlist: $e');
      return [];
    }
  }

  Future<bool> addToWatchlist(String userId, String symbol, String name) async {
    try {
      // 중복 체크
      final existing = await _supabase
          .from('watchlists')
          .select()
          .eq('user_id', userId)
          .eq('symbol', symbol)
          .maybeSingle();

      if (existing != null) {
        return false; // 이미 존재함
      }

      await _supabase.from('watchlists').insert({
        'user_id': userId,
        'symbol': symbol,
        'name': name,
        'added_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error adding to watchlist: $e');
      return false;
    }
  }

  Future<bool> removeFromWatchlist(String userId, String symbol) async {
    try {
      await _supabase
          .from('watchlists')
          .delete()
          .eq('user_id', userId)
          .eq('symbol', symbol);

      return true;
    } catch (e) {
      print('Error removing from watchlist: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchStocks(String query) async {
    try {
      // Finnhub API를 사용한 주식 검색
      final results = await _finnhubService.searchSymbol(query);
      return results;
    } catch (e) {
      print('Error searching stocks: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getMarketIndices() async {
    try {
      // 주요 지수 정보 가져오기
      final sp500 = await _finnhubService.getStockQuote('^GSPC');
      final nasdaq = await _finnhubService.getStockQuote('^IXIC');
      final dow = await _finnhubService.getStockQuote('^DJI');

      return {
        'sp500': {
          'value': sp500['c'] ?? 0,
          'change': sp500['d'] ?? 0,
          'changePercent': sp500['dp'] ?? 0,
        },
        'nasdaq': {
          'value': nasdaq['c'] ?? 0,
          'change': nasdaq['d'] ?? 0,
          'changePercent': nasdaq['dp'] ?? 0,
        },
        'dow': {
          'value': dow['c'] ?? 0,
          'change': dow['d'] ?? 0,
          'changePercent': dow['dp'] ?? 0,
        },
      };
    } catch (e) {
      print('Error fetching market indices: $e');
      // 에러 시 기본값 반환
      return {
        'sp500': {'value': 4567.23, 'change': 38.82, 'changePercent': 0.85},
        'nasdaq': {'value': 14234.56, 'change': 174.83, 'changePercent': 1.23},
        'dow': {'value': 33987.45, 'change': -115.56, 'changePercent': -0.34},
      };
    }
  }

  String _formatVolume(dynamic volume) {
    if (volume == null) return '0';
    
    final num = volume is String ? double.tryParse(volume) ?? 0 : volume.toDouble();
    
    if (num >= 1000000000) {
      return '${(num / 1000000000).toStringAsFixed(1)}B';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    
    return num.toStringAsFixed(0);
  }
}