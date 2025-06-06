import 'dart:math';
import '../models/stock_recommendation.dart';
import '../models/trader_strategy.dart';
import '../models/candle_data.dart';

class MockDataService {
  final Random _random = Random();

  Future<List<StockRecommendation>> getRecommendations() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final stocks = [
      {'code': 'AAPL', 'name': 'Apple Inc.'},
      {'code': 'MSFT', 'name': 'Microsoft Corp.'},
      {'code': 'GOOGL', 'name': 'Alphabet Inc.'},
      {'code': 'AMZN', 'name': 'Amazon.com Inc.'},
      {'code': 'TSLA', 'name': 'Tesla Inc.'},
      {'code': 'NVDA', 'name': 'NVIDIA Corp.'},
      {'code': 'META', 'name': 'Meta Platforms'},
      {'code': 'JPM', 'name': 'JPMorgan Chase'},
      {'code': 'V', 'name': 'Visa Inc.'},
      {'code': 'WMT', 'name': 'Walmart Inc.'},
    ];

    final traders = [
      'Alexander Kim',
      'Sarah Chen',
      'Michael Ross',
      'Emma Wilson',
      'David Lee',
    ];

    final actions = ['BUY', 'SELL', 'HOLD'];
    final timeframes = ['SHORT', 'MEDIUM', 'LONG'];
    final riskLevels = ['LOW', 'MEDIUM', 'HIGH'];

    return List.generate(20, (index) {
      final stock = stocks[_random.nextInt(stocks.length)];
      final action = actions[_random.nextInt(actions.length)];
      final currentPrice = 50 + _random.nextDouble() * 450;
      final targetMultiplier = action == 'BUY' ? 1.05 + _random.nextDouble() * 0.15 
                                               : 0.85 + _random.nextDouble() * 0.10;
      final targetPrice = currentPrice * targetMultiplier;
      final stopLossMultiplier = action == 'BUY' ? 0.95 - _random.nextDouble() * 0.05
                                                 : 1.05 + _random.nextDouble() * 0.05;
      final stopLoss = currentPrice * stopLossMultiplier;
      
      return StockRecommendation(
        id: 'rec_$index',
        stockCode: stock['code']!,
        stockName: stock['name']!,
        traderName: traders[_random.nextInt(traders.length)],
        traderId: 'trader_${_random.nextInt(5)}',
        action: action,
        targetPrice: targetPrice,
        currentPrice: currentPrice,
        stopLoss: stopLoss,
        takeProfit: targetPrice,
        reasoning: _generateReasoning(action, stock['name']!),
        recommendedAt: DateTime.now().subtract(Duration(hours: _random.nextInt(72))),
        timeframe: timeframes[_random.nextInt(timeframes.length)],
        confidence: 60 + _random.nextDouble() * 35,
        riskLevel: riskLevels[_random.nextInt(riskLevels.length)],
        technicalIndicators: {
          'RSI': 30 + _random.nextDouble() * 40,
          'MACD': _random.nextBool() ? 'Bullish' : 'Bearish',
          'SMA50': currentPrice * (0.95 + _random.nextDouble() * 0.1),
          'SMA200': currentPrice * (0.90 + _random.nextDouble() * 0.2),
        },
        expectedReturn: (targetPrice - currentPrice) / currentPrice * 100,
        likes: _random.nextInt(500),
        followers: _random.nextInt(10000),
      );
    });
  }

  String _generateReasoning(String action, String stockName) {
    final reasons = {
      'BUY': [
        'Strong upward momentum with breakout above resistance levels',
        'Bullish technical patterns forming with increasing volume',
        'Positive earnings outlook and strong fundamentals',
        'Oversold conditions presenting buying opportunity',
        'Sector rotation favoring this position',
      ],
      'SELL': [
        'Bearish divergence in technical indicators',
        'Breaking below key support levels',
        'Overbought conditions with declining momentum',
        'Negative market sentiment and weak fundamentals',
        'Risk-off environment affecting growth stocks',
      ],
      'HOLD': [
        'Consolidation phase with unclear direction',
        'Waiting for earnings report before taking position',
        'Mixed signals from technical indicators',
        'Market volatility suggests caution',
        'Price action near fair value',
      ],
    };

    final actionReasons = reasons[action] ?? reasons['HOLD']!;
    return '${actionReasons[_random.nextInt(actionReasons.length)]} for $stockName';
  }

  Future<List<TraderStrategy>> getTraderStrategies() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final strategies = [
      TraderStrategy(
        id: 'strat_1',
        traderId: 'trader_1',
        traderName: 'Alexander Kim',
        strategyName: 'Momentum Master',
        description: 'High-frequency momentum trading focusing on tech stocks with strong volume patterns',
        tradingStyle: 'DAY_TRADING',
        winRate: 68.5,
        averageReturn: 2.3,
        maxDrawdown: 15.2,
        sharpeRatio: 1.85,
        totalTrades: 342,
        winningTrades: 234,
        losingTrades: 108,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        preferredAssets: ['AAPL', 'MSFT', 'NVDA', 'GOOGL'],
        performanceMetrics: {
          'avgWinSize': 3.2,
          'avgLossSize': 1.1,
          'profitFactor': 2.9,
          'bestMonth': 18.5,
          'worstMonth': -8.2,
        },
        riskManagement: '2% max risk per trade, 6% daily loss limit',
        minimumCapital: 10000,
        followers: 8420,
        rating: 4.7,
        isActive: true,
      ),
      TraderStrategy(
        id: 'strat_2',
        traderId: 'trader_2',
        traderName: 'Sarah Chen',
        strategyName: 'Value Swing Pro',
        description: 'Medium-term swing trading based on fundamental analysis and technical setups',
        tradingStyle: 'SWING_TRADING',
        winRate: 72.3,
        averageReturn: 4.8,
        maxDrawdown: 12.5,
        sharpeRatio: 2.15,
        totalTrades: 156,
        winningTrades: 113,
        losingTrades: 43,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
        preferredAssets: ['JPM', 'V', 'WMT', 'AMZN'],
        performanceMetrics: {
          'avgHoldingDays': 8.5,
          'avgWinSize': 6.2,
          'avgLossSize': 2.1,
          'profitFactor': 3.0,
        },
        riskManagement: '3% max risk per trade, position sizing based on volatility',
        minimumCapital: 25000,
        followers: 12350,
        rating: 4.9,
        isActive: true,
      ),
    ];

    return strategies;
  }

  // 캔들 차트 데이터 생성
  List<CandleData> getCandleData(String symbol, double currentPrice) {
    final List<CandleData> candles = [];
    final now = DateTime.now();
    double price = currentPrice * 0.8; // 20% 아래에서 시작
    
    // 최근 60일 데이터 생성
    for (int i = 59; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      
      // 랜덤 변동폭 (±2%)
      final changePercent = (_random.nextDouble() - 0.5) * 0.04;
      price = price * (1 + changePercent);
      
      final open = price;
      final close = price * (1 + (_random.nextDouble() - 0.5) * 0.02);
      final high = max(open, close) * (1 + _random.nextDouble() * 0.01);
      final low = min(open, close) * (1 - _random.nextDouble() * 0.01);
      final volume = 1000000 + _random.nextInt(9000000);
      
      candles.add(CandleData(
        date: date,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume.toDouble(),
      ));
      
      price = close; // 다음 캔들의 시작가는 이전 캔들의 종가
    }
    
    // 마지막 캔들이 현재가에 근접하도록 조정
    if (candles.isNotEmpty) {
      final lastCandle = candles.last;
      candles[candles.length - 1] = CandleData(
        date: lastCandle.date,
        open: lastCandle.open,
        high: max(lastCandle.open, currentPrice) * 1.005,
        low: min(lastCandle.open, currentPrice) * 0.995,
        close: currentPrice,
        volume: lastCandle.volume,
      );
    }
    
    return candles;
  }
}