import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './finnhub_service.dart';
import '../providers/portfolio_provider.dart';
import '../providers/watchlist_provider.dart';

class RealTimePriceService {
  final FinnhubService _finnhubService = FinnhubService();
  Timer? _priceUpdateTimer;
  Timer? _watchlistUpdateTimer;
  
  // 가격 업데이트 주기 (초)
  static const int portfolioUpdateInterval = 30; // 포트폴리오는 30초마다
  static const int watchlistUpdateInterval = 60; // 워치리스트는 60초마다
  
  // 실시간 가격 스트림
  final _priceStreamController = StreamController<Map<String, double>>.broadcast();
  Stream<Map<String, double>> get priceStream => _priceStreamController.stream;
  
  // 현재 추적 중인 심볼들
  final Set<String> _trackedSymbols = {};
  
  void startPriceUpdates(Ref ref) {
    // 포트폴리오 가격 업데이트
    _priceUpdateTimer = Timer.periodic(
      Duration(seconds: portfolioUpdateInterval),
      (_) => _updatePortfolioPrices(ref),
    );
    
    // 워치리스트 가격 업데이트
    _watchlistUpdateTimer = Timer.periodic(
      Duration(seconds: watchlistUpdateInterval),
      (_) => _updateWatchlistPrices(ref),
    );
    
    // 초기 업데이트 실행
    _updatePortfolioPrices(ref);
    _updateWatchlistPrices(ref);
  }
  
  void stopPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _watchlistUpdateTimer?.cancel();
    _priceUpdateTimer = null;
    _watchlistUpdateTimer = null;
  }
  
  Future<void> _updatePortfolioPrices(Ref ref) async {
    try {
      final portfolioAsync = ref.read(portfolioProvider);
      
      portfolioAsync.whenData((positions) async {
        final openPositions = positions.where((p) => p.status == 'OPEN').toList();
        final symbols = openPositions.map((p) => p.stockCode).toSet();
        
        final priceUpdates = <String, double>{};
        
        for (final symbol in symbols) {
          try {
            final quote = await _finnhubService.getStockQuote(symbol);
            final currentPrice = quote['c'] as double? ?? 0.0;
            
            if (currentPrice > 0) {
              priceUpdates[symbol] = currentPrice;
              _trackedSymbols.add(symbol);
              
              // 포트폴리오 가격 업데이트
              await ref.read(portfolioProvider.notifier)
                  .updatePositionPrice(symbol, currentPrice);
            }
          } catch (e) {
            print('Error updating price for $symbol: $e');
          }
        }
        
        // 가격 스트림에 브로드캐스트
        if (priceUpdates.isNotEmpty) {
          _priceStreamController.add(priceUpdates);
        }
      });
    } catch (e) {
      print('Error updating portfolio prices: $e');
    }
  }
  
  Future<void> _updateWatchlistPrices(Ref ref) async {
    try {
      // 워치리스트 새로고침 (Provider가 자동으로 가격을 가져옴)
      ref.read(watchlistNotifierProvider.notifier).refresh();
    } catch (e) {
      print('Error updating watchlist prices: $e');
    }
  }
  
  // 특정 심볼의 실시간 가격 구독
  void subscribeToSymbol(String symbol) {
    _trackedSymbols.add(symbol);
  }
  
  // 특정 심볼의 실시간 가격 구독 해제
  void unsubscribeFromSymbol(String symbol) {
    _trackedSymbols.remove(symbol);
  }
  
  // 단일 심볼의 가격 업데이트
  Future<double?> fetchCurrentPrice(String symbol) async {
    try {
      final quote = await _finnhubService.getStockQuote(symbol);
      return quote['c'] as double?;
    } catch (e) {
      print('Error fetching price for $symbol: $e');
      return null;
    }
  }
  
  void dispose() {
    stopPriceUpdates();
    _priceStreamController.close();
  }
}

// Provider
final realTimePriceServiceProvider = Provider((ref) {
  final service = RealTimePriceService();
  
  // Provider가 dispose될 때 서비스도 정리
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

// 자동 시작 Provider
final realTimePriceProvider = Provider((ref) {
  final service = ref.watch(realTimePriceServiceProvider);
  
  // 서비스 시작
  service.startPriceUpdates(ref);
  
  // Provider가 dispose될 때 업데이트 중지
  ref.onDispose(() {
    service.stopPriceUpdates();
  });
  
  return service;
});

// 가격 스트림 Provider
final priceStreamProvider = StreamProvider<Map<String, double>>((ref) {
  final service = ref.watch(realTimePriceServiceProvider);
  return service.priceStream;
});