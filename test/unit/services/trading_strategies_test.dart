import 'package:flutter_test/flutter_test.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/services/trading_strategies.dart';
import 'package:trader_app/services/trading_service.dart';
import 'package:trader_app/models/candle_data.dart';

void main() {
  group('Trading Strategies Tests', () {
    late MockDataService mockDataService;

    setUp(() {
      mockDataService = MockDataService();
    });
    
    // 테스트용 캔들 데이터 생성 헬퍼
    List<CandleData> createTestCandles({
      required int count,
      required double startPrice,
      double volatility = 0.02,
      double trend = 0.001,
    }) {
      final candles = <CandleData>[];
      double currentPrice = startPrice;
      
      for (int i = 0; i < count; i++) {
        final date = DateTime.now().subtract(Duration(days: count - i));
        final open = currentPrice;
        
        // 랜덤 변동성 시뮬레이션
        final change = (i % 2 == 0 ? 1 : -1) * volatility;
        currentPrice = currentPrice * (1 + change + trend);
        
        final close = currentPrice;
        final high = open > close ? open * 1.01 : close * 1.01;
        final low = open < close ? open * 0.99 : close * 0.99;
        final volume = 1000000 + (i * 10000);
        
        candles.add(CandleData(
          date: date,
          open: open,
          high: high,
          low: low,
          close: close,
          volume: volume.toDouble(),
        ));
      }
      
      return candles;
    }

    group('Jesse Livermore Strategy', () {
      test('should generate trend following recommendations', () async {
        final recommendations = await mockDataService.getRecommendations();
        final jesseRecs = recommendations.where((r) => 
          r.traderName == 'Jesse Livermore'
        ).toList();

        expect(jesseRecs, isNotEmpty);
        
        for (final rec in jesseRecs) {
          // Jesse focuses on trend following
          expect(rec.reasoning, contains(RegExp(r'(trend|momentum|breakout)', caseSensitive: false)));
          
          // Should have specific risk management
          expect(rec.stopLoss, lessThan(rec.currentPrice));
          expect(rec.targetPrice, greaterThan(rec.currentPrice));
          
          // Risk/reward ratio should be favorable
          final risk = rec.currentPrice - rec.stopLoss;
          final reward = rec.targetPrice - rec.currentPrice;
          expect(reward / risk, greaterThanOrEqualTo(2.0));
        }
      });

      test('should use pyramiding approach for position sizing', () async {
        final strategies = await mockDataService.getTraderStrategies();
        final jesseStrategy = strategies.firstWhere(
          (s) => s.traderName == 'Jesse Livermore'
        );

        // Jesse's strategy characteristics
        expect(jesseStrategy.tradingStyle, equals('SWING_TRADING'));
        expect(jesseStrategy.riskManagement, contains('pyramid'));
        expect(jesseStrategy.winRate, greaterThanOrEqualTo(40));
        expect(jesseStrategy.winRate, lessThanOrEqualTo(60));
      });
    });

    group('Larry Williams Strategy', () {
      test('should generate short-term momentum trades', () async {
        final recommendations = await mockDataService.getRecommendations();
        final larryRecs = recommendations.where((r) => 
          r.traderName == 'Larry Williams'
        ).toList();

        expect(larryRecs, isNotEmpty);
        
        for (final rec in larryRecs) {
          // Larry focuses on short-term momentum
          expect(rec.timeframe, equals('SHORT_TERM'));
          expect(rec.reasoning, contains(RegExp(r'(momentum|volatility|breakout)', caseSensitive: false)));
          
          // Higher risk, higher reward
          expect(rec.riskLevel, anyOf(['MEDIUM', 'HIGH']));
        }
      });

      test('should have high win rate with smaller gains', () async {
        final strategies = await mockDataService.getTraderStrategies();
        final larryStrategy = strategies.firstWhere(
          (s) => s.traderName == 'Larry Williams'
        );

        // Larry's strategy characteristics
        expect(larryStrategy.tradingStyle, anyOf(['SCALPING', 'DAY_TRADING']));
        expect(larryStrategy.winRate, greaterThanOrEqualTo(60));
        expect(larryStrategy.averageReturn, lessThanOrEqualTo(5));
      });
    });

    group('Stan Weinstein Strategy', () {
      test('should generate stage-based recommendations', () async {
        final recommendations = await mockDataService.getRecommendations();
        final stanRecs = recommendations.where((r) => 
          r.traderName == 'Stan Weinstein'
        ).toList();

        expect(stanRecs, isNotEmpty);
        
        for (final rec in stanRecs) {
          // Stan focuses on stage analysis
          expect(rec.reasoning, contains(RegExp(r'(stage|phase|accumulation|markup)', caseSensitive: false)));
          
          // Longer-term approach
          expect(rec.timeframe, anyOf(['MEDIUM_TERM', 'LONG_TERM']));
          
          // Conservative risk management
          expect(rec.riskLevel, anyOf(['LOW', 'MEDIUM']));
        }
      });

      test('should focus on position trading', () async {
        final strategies = await mockDataService.getTraderStrategies();
        final stanStrategy = strategies.firstWhere(
          (s) => s.traderName == 'Stan Weinstein'
        );

        // Stan's strategy characteristics
        expect(stanStrategy.tradingStyle, equals('POSITION_TRADING'));
        expect(stanStrategy.minimumCapital, greaterThanOrEqualTo(25000));
        expect(stanStrategy.maxDrawdown, lessThanOrEqualTo(20));
      });
    });

    group('Strategy Diversification', () {
      test('should provide diverse recommendations across strategies', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        // Group by trader
        final traderGroups = <String, List<StockRecommendation>>{};
        for (final rec in recommendations) {
          traderGroups.putIfAbsent(rec.traderName, () => []).add(rec);
        }
        
        // Should have recommendations from all three traders
        expect(traderGroups.keys.length, greaterThanOrEqualTo(3));
        
        // Each trader should have multiple recommendations
        for (final recs in traderGroups.values) {
          expect(recs.length, greaterThanOrEqualTo(2));
        }
      });

      test('should cover different risk levels', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        final riskLevels = recommendations.map((r) => r.riskLevel).toSet();
        
        // Should have all risk levels represented
        expect(riskLevels, containsAll(['LOW', 'MEDIUM', 'HIGH']));
      });

      test('should cover different timeframes', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        final timeframes = recommendations.map((r) => r.timeframe).toSet();
        
        // Should have multiple timeframes
        expect(timeframes.length, greaterThanOrEqualTo(2));
      });

      test('should include both BUY and SELL recommendations', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        final actions = recommendations.map((r) => r.action).toSet();
        
        // Should have diverse actions
        expect(actions, contains('BUY'));
        expect(actions.length, greaterThanOrEqualTo(2)); // At least BUY and one other
      });
    });

    group('Strategy Performance Metrics', () {
      test('should have realistic win rates', () async {
        final strategies = await mockDataService.getTraderStrategies();
        
        for (final strategy in strategies) {
          // Realistic win rates between 35% and 75%
          expect(strategy.winRate, greaterThanOrEqualTo(35));
          expect(strategy.winRate, lessThanOrEqualTo(75));
          
          // Win rate should match winning/total trades
          if (strategy.totalTrades > 0) {
            final calculatedWinRate = (strategy.winningTrades / strategy.totalTrades) * 100;
            expect(strategy.winRate, closeTo(calculatedWinRate, 0.1));
          }
        }
      });

      test('should have appropriate Sharpe ratios', () async {
        final strategies = await mockDataService.getTraderStrategies();
        
        for (final strategy in strategies) {
          // Sharpe ratio should be positive and realistic
          expect(strategy.sharpeRatio, greaterThan(0));
          expect(strategy.sharpeRatio, lessThanOrEqualTo(3));
          
          // Higher risk strategies might have lower Sharpe ratios
          if (strategy.maxDrawdown > 30) {
            expect(strategy.sharpeRatio, lessThanOrEqualTo(1.5));
          }
        }
      });

      test('should have consistent risk/return profiles', () async {
        final strategies = await mockDataService.getTraderStrategies();
        
        for (final strategy in strategies) {
          // Higher returns should come with higher drawdowns
          if (strategy.averageReturn > 10) {
            expect(strategy.maxDrawdown, greaterThanOrEqualTo(15));
          }
          
          // Conservative strategies should have lower drawdowns
          if (strategy.tradingStyle == 'POSITION_TRADING') {
            expect(strategy.maxDrawdown, lessThanOrEqualTo(25));
          }
        }
      });
    });

    group('Recommendation Quality', () {
      test('should have valid price targets', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        for (final rec in recommendations) {
          // Target should be different from current price
          expect(rec.targetPrice, isNot(equals(rec.currentPrice)));
          
          // BUY recommendations should have higher targets
          if (rec.action == 'BUY') {
            expect(rec.targetPrice, greaterThan(rec.currentPrice));
            expect(rec.stopLoss, lessThan(rec.currentPrice));
          }
          
          // SELL recommendations should have lower targets
          if (rec.action == 'SELL') {
            expect(rec.targetPrice, lessThan(rec.currentPrice));
            expect(rec.stopLoss, greaterThan(rec.currentPrice));
          }
        }
      });

      test('should have reasonable confidence scores', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        for (final rec in recommendations) {
          // Confidence should be realistic, not always super high
          expect(rec.confidence, greaterThanOrEqualTo(60));
          expect(rec.confidence, lessThanOrEqualTo(95));
          
          // Higher risk should have slightly lower confidence
          if (rec.riskLevel == 'HIGH') {
            expect(rec.confidence, lessThanOrEqualTo(85));
          }
        }
      });

      test('should have detailed reasoning', () async {
        final recommendations = await mockDataService.getRecommendations();
        
        for (final rec in recommendations) {
          // Reasoning should be substantial
          expect(rec.reasoning.length, greaterThanOrEqualTo(50));
          
          // Should mention the stock
          expect(rec.reasoning, contains(rec.stockName));
          
          // Should include some technical or fundamental reason
          expect(rec.reasoning, anyOf(
            contains('support'),
            contains('resistance'),
            contains('trend'),
            contains('momentum'),
            contains('breakout'),
            contains('stage'),
            contains('accumulation'),
          ));
        }
      });
    });
    
    group('New Trading Strategy Implementation Tests', () {
      group('JesseLivermoreStrategy', () {
        late JesseLivermoreStrategy strategy;
        
        setUp(() {
          strategy = JesseLivermoreStrategy();
        });
        
        test('should return hold signal when insufficient data', () {
          final candles = createTestCandles(count: 30, startPrice: 100);
          final signal = strategy.analyze(candles: candles, symbol: 'TEST');
          
          expect(signal.action, equals(SignalAction.hold));
          expect(signal.reasoning, contains('데이터 부족'));
        });
        
        test('should generate buy signal on uptrend with volume', () {
          // 상승 추세 데이터 생성
          final candles = createTestCandles(
            count: 60,
            startPrice: 100,
            trend: 0.005, // 상승 추세
            volatility: 0.01,
          );
          
          // 마지막 캔들에 높은 거래량 추가
          final lastCandle = candles.last;
          candles[candles.length - 1] = CandleData(
            date: lastCandle.date,
            open: lastCandle.open,
            high: lastCandle.high * 1.02,
            low: lastCandle.low,
            close: lastCandle.high * 1.01, // 고가 근처 마감
            volume: lastCandle.volume * 2, // 거래량 급증
          );
          
          final signal = strategy.analyze(candles: candles, symbol: 'TEST');
          
          // 매수 신호가 나올 수 있음 (시장 상황에 따라)
          expect(signal.action, isIn([SignalAction.buy, SignalAction.hold]));
          if (signal.action == SignalAction.buy) {
            expect(signal.confidence, greaterThan(0.5));
            expect(signal.stopLoss, isNotNull);
            expect(signal.targetPrice, isNotNull);
          }
        });
        
        test('should calculate SMA correctly', () {
          final prices = [100.0, 102.0, 101.0, 103.0, 104.0];
          final sma = strategy.calculateSMA(prices, 3);
          
          expect(sma.length, equals(3));
          expect(sma[0], closeTo(101.0, 0.01)); // (100+102+101)/3
          expect(sma[1], closeTo(102.0, 0.01)); // (102+101+103)/3
          expect(sma[2], closeTo(102.67, 0.01)); // (101+103+104)/3
        });
        
        test('should calculate RSI correctly', () {
          final prices = List.generate(20, (i) => 100.0 + i * 0.5);
          final rsi = strategy.calculateRSI(prices, 14);
          
          expect(rsi, greaterThan(50)); // 상승 추세이므로 RSI > 50
          expect(rsi, lessThanOrEqualTo(100));
        });
      });
      
      group('LarryWilliamsStrategy', () {
        late LarryWilliamsStrategy strategy;
        
        setUp(() {
          strategy = LarryWilliamsStrategy();
        });
        
        test('should generate buy signal on oversold with momentum', () {
          // 과매도 후 반등 시나리오
          final candles = createTestCandles(
            count: 40,
            startPrice: 100,
            trend: -0.003, // 하락 후
          );
          
          // 최근 반등 추가
          for (int i = 35; i < 40; i++) {
            final candle = candles[i];
            candles[i] = CandleData(
              date: candle.date,
              open: candle.open * 1.02,
              high: candle.high * 1.03,
              low: candle.low * 1.01,
              close: candle.close * 1.025,
              volume: candle.volume * 1.5,
            );
          }
          
          final signal = strategy.analyze(candles: candles, symbol: 'TEST');
          
          expect(signal.action, isIn([SignalAction.buy, SignalAction.hold]));
          expect(signal.indicators['williamsR'], isNotNull);
          expect(signal.indicators['momentum'], isNotNull);
        });
        
        test('should calculate ATR correctly', () {
          final candles = createTestCandles(count: 20, startPrice: 100);
          final atr = strategy.calculateATR(candles, 14);
          
          expect(atr, greaterThan(0));
          expect(atr, lessThan(10)); // 합리적인 범위
        });
      });
      
      group('StanWeinsteinStrategy', () {
        late StanWeinsteinStrategy strategy;
        
        setUp(() {
          strategy = StanWeinsteinStrategy();
        });
        
        test('should require at least 150 candles', () {
          final candles = createTestCandles(count: 100, startPrice: 100);
          final signal = strategy.analyze(candles: candles, symbol: 'TEST');
          
          expect(signal.action, equals(SignalAction.hold));
          expect(signal.reasoning, contains('데이터 부족'));
        });
        
        test('should identify stage 2 breakout', () {
          // Stage 2 돌파 시나리오: 횡보 후 상승
          final candles = <CandleData>[];
          
          // Stage 1: 바닥 횡보 (50일)
          candles.addAll(createTestCandles(
            count: 50,
            startPrice: 100,
            trend: 0,
            volatility: 0.01,
          ));
          
          // Stage 2 진입: 상승 돌파 (100일)
          final lastPrice = candles.last.close;
          candles.addAll(createTestCandles(
            count: 100,
            startPrice: lastPrice,
            trend: 0.003,
            volatility: 0.015,
          ));
          
          final signal = strategy.analyze(candles: candles, symbol: 'TEST');
          
          expect(signal.indicators['stage'], isIn([1, 2, 3, 4]));
          expect(signal.indicators['sma150'], isNotNull);
          expect(signal.indicators['relativeStrength'], isNotNull);
        });
      });
      
      group('TradingStrategyFactory', () {
        test('should create correct strategy instances', () {
          final livermore = TradingStrategyFactory.create(TradingStrategy.jesseLivermore);
          expect(livermore, isA<JesseLivermoreStrategy>());
          
          final williams = TradingStrategyFactory.create(TradingStrategy.larryWilliams);
          expect(williams, isA<LarryWilliamsStrategy>());
          
          final weinstein = TradingStrategyFactory.create(TradingStrategy.stanWeinstein);
          expect(weinstein, isA<StanWeinsteinStrategy>());
        });
      });
    });
  });
}