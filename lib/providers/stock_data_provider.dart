import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/candle_data.dart';
import '../services/finnhub_service.dart';
import '../services/mock_data_service.dart';
import '../services/market_service.dart';
import '../services/trading_service.dart';
import '../services/portfolio_service.dart';
import '../main.dart';
import 'mock_data_provider.dart';

// Finnhub 서비스 프로바이더
final finnhubServiceProvider = Provider((ref) => FinnhubService());

// 주식 차트 데이터 프로바이더
final stockCandleDataProvider = FutureProvider.family<List<CandleData>, String>(
  (ref, symbol) async {
    final finnhubService = ref.read(finnhubServiceProvider);
    
    // 60일 전부터 오늘까지 데이터 가져오기
    final to = DateTime.now();
    final from = to.subtract(const Duration(days: 60));
    
    // 실제 데이터 가져오기 시도
    final candles = await finnhubService.getStockCandles(
      symbol: symbol,
      from: from,
      to: to,
      resolution: 'D', // 일봉 데이터
    );
    
    // 데이터가 없거나 부족하면 목 데이터 사용
    if (candles.isEmpty || candles.length < 10) {
      final mockService = ref.read(mockDataServiceProvider);
      final currentPrice = await finnhubService.getCurrentPrice(symbol) ?? 100.0;
      return mockService.getCandleData(symbol, currentPrice);
    }
    
    return candles;
  },
);

// 현재가 프로바이더
final currentPriceProvider = FutureProvider.family<double, String>(
  (ref, symbol) async {
    final finnhubService = ref.read(finnhubServiceProvider);
    final price = await finnhubService.getCurrentPrice(symbol);
    
    // 가격을 가져올 수 없으면 기본값 반환
    return price ?? 100.0;
  },
);

// Supabase 서비스 프로바이더
final marketServiceProvider = Provider<MarketService>((ref) {
  return MarketService(supabase);
});

final tradingServiceProvider = Provider<TradingService>((ref) {
  return TradingService(supabase);
});

final portfolioServiceProvider = Provider<PortfolioService>((ref) {
  return PortfolioService(supabase);
});

// 선택된 트레이딩 전략 프로바이더
final selectedTradingStrategyProvider = StateProvider<TradingStrategy>((ref) {
  return TradingStrategy.jesseLivermore; // 기본값
});

// 실시간 주가 프로바이더 (Supabase)
final stockQuoteProvider = FutureProvider.family<StockQuote, String>((ref, symbol) async {
  final marketService = ref.watch(marketServiceProvider);
  return await marketService.getQuote(symbol);
});

// 트레이딩 신호 프로바이더
final tradingSignalProvider = FutureProvider.family<TradingSignal, String>((ref, symbol) async {
  final tradingService = ref.watch(tradingServiceProvider);
  final strategy = ref.watch(selectedTradingStrategyProvider);
  
  return await tradingService.getSignal(
    symbol: symbol,
    strategy: strategy,
  );
});