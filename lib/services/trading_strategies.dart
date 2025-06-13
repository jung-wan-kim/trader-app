import 'dart:math';
import '../models/candle_data.dart';
import 'trading_service.dart';

/// 트레이딩 전략 분석을 위한 기본 클래스
abstract class TradingStrategyAnalyzer {
  /// 매매 신호 생성
  TradingSignal analyze({
    required List<CandleData> candles,
    required String symbol,
  });
  
  /// 이동평균 계산
  List<double> calculateSMA(List<double> prices, int period) {
    if (prices.length < period) return [];
    
    final sma = <double>[];
    for (int i = period - 1; i < prices.length; i++) {
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += prices[i - j];
      }
      sma.add(sum / period);
    }
    return sma;
  }
  
  /// 지수이동평균 계산
  List<double> calculateEMA(List<double> prices, int period) {
    if (prices.length < period) return [];
    
    final ema = <double>[];
    final multiplier = 2 / (period + 1);
    
    // 첫 EMA는 SMA로 시작
    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += prices[i];
    }
    ema.add(sum / period);
    
    // 이후 EMA 계산
    for (int i = period; i < prices.length; i++) {
      final value = (prices[i] - ema.last) * multiplier + ema.last;
      ema.add(value);
    }
    
    return ema;
  }
  
  /// RSI (Relative Strength Index) 계산
  double calculateRSI(List<double> prices, int period) {
    if (prices.length < period + 1) return 50;
    
    double gains = 0;
    double losses = 0;
    
    // 초기 평균 계산
    for (int i = 1; i <= period; i++) {
      final change = prices[i] - prices[i - 1];
      if (change > 0) {
        gains += change;
      } else {
        losses += change.abs();
      }
    }
    
    double avgGain = gains / period;
    double avgLoss = losses / period;
    
    // Smoothed RSI 계산
    for (int i = period + 1; i < prices.length; i++) {
      final change = prices[i] - prices[i - 1];
      if (change > 0) {
        avgGain = (avgGain * (period - 1) + change) / period;
        avgLoss = (avgLoss * (period - 1)) / period;
      } else {
        avgGain = (avgGain * (period - 1)) / period;
        avgLoss = (avgLoss * (period - 1) + change.abs()) / period;
      }
    }
    
    if (avgLoss == 0) return 100;
    final rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }
  
  /// MACD 계산
  Map<String, List<double>> calculateMACD(List<double> prices) {
    final ema12 = calculateEMA(prices, 12);
    final ema26 = calculateEMA(prices, 26);
    
    if (ema12.isEmpty || ema26.isEmpty) {
      return {'macd': [], 'signal': [], 'histogram': []};
    }
    
    // MACD 라인 계산
    final macd = <double>[];
    final startIdx = 26 - 12; // EMA26이 시작되는 지점
    for (int i = 0; i < ema26.length; i++) {
      macd.add(ema12[i + startIdx] - ema26[i]);
    }
    
    // Signal 라인 (MACD의 9일 EMA)
    final signal = calculateEMA(macd, 9);
    
    // Histogram
    final histogram = <double>[];
    final signalStartIdx = 9 - 1;
    for (int i = 0; i < signal.length; i++) {
      histogram.add(macd[i + signalStartIdx] - signal[i]);
    }
    
    return {
      'macd': macd,
      'signal': signal,
      'histogram': histogram,
    };
  }
  
  /// ATR (Average True Range) 계산
  double calculateATR(List<CandleData> candles, int period) {
    if (candles.length < period + 1) return 0;
    
    final trueRanges = <double>[];
    
    for (int i = 1; i < candles.length; i++) {
      final high = candles[i].high;
      final low = candles[i].low;
      final prevClose = candles[i - 1].close;
      
      final tr = [
        high - low,
        (high - prevClose).abs(),
        (low - prevClose).abs(),
      ].reduce(max);
      
      trueRanges.add(tr);
    }
    
    // 최근 period 개의 TR 평균
    double sum = 0;
    for (int i = trueRanges.length - period; i < trueRanges.length; i++) {
      sum += trueRanges[i];
    }
    
    return sum / period;
  }
}

/// 제시 리버모어 전략 구현
/// 추세 추종 + 피라미딩 전략
class JesseLivermoreStrategy extends TradingStrategyAnalyzer {
  @override
  TradingSignal analyze({
    required List<CandleData> candles,
    required String symbol,
  }) {
    if (candles.length < 50) {
      return _createHoldSignal('데이터 부족');
    }
    
    final prices = candles.map((c) => c.close).toList();
    final currentPrice = prices.last;
    
    // 1. 추세 판단 (20일, 50일 이동평균)
    final sma20 = calculateSMA(prices, 20);
    final sma50 = calculateSMA(prices, 50);
    
    if (sma20.isEmpty || sma50.isEmpty) {
      return _createHoldSignal('이동평균 계산 불가');
    }
    
    final currentSMA20 = sma20.last;
    final currentSMA50 = sma50.last;
    
    // 2. 피벗 포인트 계산 (최근 20일 고가/저가)
    final recentCandles = candles.sublist(candles.length - 20);
    final highestHigh = recentCandles.map((c) => c.high).reduce(max);
    final lowestLow = recentCandles.map((c) => c.low).reduce(min);
    
    // 3. 거래량 분석
    final avgVolume = candles.sublist(candles.length - 20)
        .map((c) => c.volume)
        .reduce((a, b) => a + b) / 20;
    final currentVolume = candles.last.volume;
    final volumeRatio = currentVolume / avgVolume;
    
    // 4. RSI
    final rsi = calculateRSI(prices, 14);
    
    // 5. 신호 생성 로직
    final indicators = {
      'sma20': currentSMA20,
      'sma50': currentSMA50,
      'rsi': rsi,
      'volumeRatio': volumeRatio,
      'highestHigh': highestHigh,
      'lowestLow': lowestLow,
    };
    
    // 매수 조건
    if (currentPrice > currentSMA20 && 
        currentSMA20 > currentSMA50 &&
        currentPrice > highestHigh * 0.98 && // 최고가 근처
        volumeRatio > 1.5 && // 거래량 증가
        rsi < 70) { // 과매수 아님
      
      final stopLoss = lowestLow;
      final targetPrice = currentPrice * 1.15; // 15% 목표
      
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.buy,
        confidence: _calculateConfidence(true, volumeRatio, rsi),
        entryPrice: currentPrice,
        targetPrice: targetPrice,
        stopLoss: stopLoss,
        reasoning: '강한 상승 추세 + 신고가 돌파 + 거래량 증가',
        indicators: indicators,
      );
    }
    
    // 매도 조건
    if (currentPrice < currentSMA20 &&
        currentSMA20 < currentSMA50 &&
        currentPrice < lowestLow * 1.02 && // 최저가 근처
        rsi > 30) { // 과매도 아님
      
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.sell,
        confidence: _calculateConfidence(false, volumeRatio, rsi),
        entryPrice: currentPrice,
        reasoning: '하락 추세 전환 + 지지선 붕괴',
        indicators: indicators,
      );
    }
    
    // 보유
    return _createHoldSignal('명확한 추세 없음');
  }
  
  double _calculateConfidence(bool isBuy, double volumeRatio, double rsi) {
    double confidence = 0.5;
    
    // 거래량 기준
    if (volumeRatio > 2.0) confidence += 0.2;
    else if (volumeRatio > 1.5) confidence += 0.1;
    
    // RSI 기준
    if (isBuy && rsi < 50) confidence += 0.1;
    else if (!isBuy && rsi > 50) confidence += 0.1;
    
    if (isBuy && rsi < 30) confidence += 0.1; // 과매도에서 매수
    else if (!isBuy && rsi > 70) confidence += 0.1; // 과매수에서 매도
    
    return confidence.clamp(0.0, 1.0);
  }
  
  TradingSignal _createHoldSignal(String reason) {
    return TradingSignal(
      action: SignalAction.hold,
      confidence: 0.5,
      reasoning: reason,
      indicators: {},
    );
  }
}

/// 래리 윌리엄스 전략 구현
/// 단기 모멘텀 + 변동성 돌파 전략
class LarryWilliamsStrategy extends TradingStrategyAnalyzer {
  @override
  TradingSignal analyze({
    required List<CandleData> candles,
    required String symbol,
  }) {
    if (candles.length < 30) {
      return _createHoldSignal('데이터 부족');
    }
    
    final prices = candles.map((c) => c.close).toList();
    final currentCandle = candles.last;
    final currentPrice = currentCandle.close;
    
    // 1. Williams %R 계산
    final williamsR = _calculateWilliamsR(candles, 14);
    
    // 2. 변동성 계산 (ATR)
    final atr = calculateATR(candles, 14);
    
    // 3. 모멘텀 계산
    final momentum = _calculateMomentum(prices, 10);
    
    // 4. 변동성 돌파 계산
    final yesterdayCandle = candles[candles.length - 2];
    final range = yesterdayCandle.high - yesterdayCandle.low;
    final k = 0.5; // 변동성 돌파 계수
    final buyTarget = currentCandle.open + (range * k);
    final sellTarget = currentCandle.open - (range * k);
    
    // 5. MACD
    final macdData = calculateMACD(prices);
    final macdHistogram = macdData['histogram']!;
    
    final indicators = {
      'williamsR': williamsR,
      'atr': atr,
      'momentum': momentum,
      'buyTarget': buyTarget,
      'sellTarget': sellTarget,
      'macdHistogram': macdHistogram.isNotEmpty ? macdHistogram.last : 0,
    };
    
    // 매수 조건
    if (williamsR < -80 && // 과매도
        momentum > 0 && // 상승 모멘텀
        currentPrice > buyTarget && // 변동성 돌파
        macdHistogram.isNotEmpty && macdHistogram.last > 0) {
      
      final stopLoss = currentPrice - (atr * 2);
      final targetPrice = currentPrice + (atr * 3);
      
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.buy,
        confidence: _calculateConfidence(true, williamsR, momentum),
        entryPrice: currentPrice,
        targetPrice: targetPrice,
        stopLoss: stopLoss,
        reasoning: '과매도 + 변동성 돌파 + 상승 모멘텀',
        indicators: indicators,
      );
    }
    
    // 매도 조건
    if (williamsR > -20 && // 과매수
        momentum < 0 && // 하락 모멘텀
        currentPrice < sellTarget && // 변동성 하향 돌파
        macdHistogram.isNotEmpty && macdHistogram.last < 0) {
      
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.sell,
        confidence: _calculateConfidence(false, williamsR, momentum),
        entryPrice: currentPrice,
        reasoning: '과매수 + 하락 모멘텀 + 변동성 하향 돌파',
        indicators: indicators,
      );
    }
    
    return _createHoldSignal('단기 모멘텀 신호 없음');
  }
  
  double _calculateWilliamsR(List<CandleData> candles, int period) {
    if (candles.length < period) return -50;
    
    final recentCandles = candles.sublist(candles.length - period);
    final highestHigh = recentCandles.map((c) => c.high).reduce(max);
    final lowestLow = recentCandles.map((c) => c.low).reduce(min);
    final currentClose = candles.last.close;
    
    if (highestHigh == lowestLow) return -50;
    
    return ((highestHigh - currentClose) / (highestHigh - lowestLow)) * -100;
  }
  
  double _calculateMomentum(List<double> prices, int period) {
    if (prices.length < period + 1) return 0;
    
    final currentPrice = prices.last;
    final previousPrice = prices[prices.length - period - 1];
    
    return ((currentPrice - previousPrice) / previousPrice) * 100;
  }
  
  double _calculateConfidence(bool isBuy, double williamsR, double momentum) {
    double confidence = 0.5;
    
    // Williams %R 기준
    if (isBuy && williamsR < -90) confidence += 0.2;
    else if (isBuy && williamsR < -80) confidence += 0.1;
    else if (!isBuy && williamsR > -10) confidence += 0.2;
    else if (!isBuy && williamsR > -20) confidence += 0.1;
    
    // 모멘텀 기준
    if (momentum.abs() > 10) confidence += 0.2;
    else if (momentum.abs() > 5) confidence += 0.1;
    
    return confidence.clamp(0.0, 1.0);
  }
  
  TradingSignal _createHoldSignal(String reason) {
    return TradingSignal(
      action: SignalAction.hold,
      confidence: 0.5,
      reasoning: reason,
      indicators: {},
    );
  }
}

/// 스탠 와인스타인 전략 구현
/// 4단계 사이클 분석 전략
class StanWeinsteinStrategy extends TradingStrategyAnalyzer {
  @override
  TradingSignal analyze({
    required List<CandleData> candles,
    required String symbol,
  }) {
    if (candles.length < 150) {
      return _createHoldSignal('데이터 부족 (최소 150일 필요)');
    }
    
    final prices = candles.map((c) => c.close).toList();
    final currentPrice = prices.last;
    
    // 1. 30주(150일) 이동평균 계산
    final sma150 = calculateSMA(prices, 150);
    if (sma150.isEmpty) {
      return _createHoldSignal('장기 이동평균 계산 불가');
    }
    
    final currentSMA150 = sma150.last;
    
    // 2. 이동평균 기울기 계산
    final smaSlope = _calculateSlope(sma150, 10);
    
    // 3. 상대 강도 계산
    final relativeStrength = _calculateRelativeStrength(prices, 30);
    
    // 4. 거래량 분석
    final volumes = candles.map((c) => c.volume).toList();
    final avgVolume50 = volumes.sublist(volumes.length - 50)
        .reduce((a, b) => a + b) / 50;
    final currentVolume = candles.last.volume;
    final volumeRatio = currentVolume / avgVolume50;
    
    // 5. 스테이지 판단
    final stage = _determineStage(
      currentPrice: currentPrice,
      sma150: currentSMA150,
      smaSlope: smaSlope,
      relativeStrength: relativeStrength,
    );
    
    // 6. 저항선/지지선 계산
    final resistance = _findResistance(candles, 50);
    final support = _findSupport(candles, 50);
    
    final indicators = {
      'sma150': currentSMA150,
      'smaSlope': smaSlope,
      'relativeStrength': relativeStrength,
      'volumeRatio': volumeRatio,
      'stage': stage,
      'resistance': resistance,
      'support': support,
    };
    
    // 매수 조건 (Stage 2 진입)
    if (stage == 2 &&
        currentPrice > currentSMA150 &&
        smaSlope > 0 &&
        currentPrice > resistance * 0.98 && // 저항선 돌파
        volumeRatio > 1.3 &&
        relativeStrength > 1.0) {
      
      final stopLoss = currentSMA150 * 0.97; // 이동평균 아래 3%
      final targetPrice = currentPrice * 1.25; // 25% 목표
      
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.buy,
        confidence: _calculateConfidence(stage, volumeRatio, relativeStrength),
        entryPrice: currentPrice,
        targetPrice: targetPrice,
        stopLoss: stopLoss,
        reasoning: 'Stage 2 진입 - 상승 추세 시작',
        indicators: indicators,
      );
    }
    
    // 매도 조건 (Stage 3 진입 또는 Stage 4)
    if ((stage == 3 || stage == 4) &&
        currentPrice < currentSMA150 &&
        smaSlope < 0) {
      
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.sell,
        confidence: _calculateConfidence(stage, volumeRatio, relativeStrength),
        entryPrice: currentPrice,
        reasoning: 'Stage ${stage} - 하락 추세 시작/진행',
        indicators: indicators,
      );
    }
    
    return _createHoldSignal('Stage $stage - 관망');
  }
  
  double _calculateSlope(List<double> values, int period) {
    if (values.length < period) return 0;
    
    final recentValues = values.sublist(values.length - period);
    final firstValue = recentValues.first;
    final lastValue = recentValues.last;
    
    return ((lastValue - firstValue) / firstValue) * 100;
  }
  
  double _calculateRelativeStrength(List<double> prices, int period) {
    if (prices.length < period) return 1.0;
    
    final recentPrices = prices.sublist(prices.length - period);
    final priceChange = (recentPrices.last - recentPrices.first) / recentPrices.first;
    
    // 단순화된 상대강도 (실제로는 시장 대비 계산 필요)
    return 1.0 + priceChange;
  }
  
  int _determineStage({
    required double currentPrice,
    required double sma150,
    required double smaSlope,
    required double relativeStrength,
  }) {
    // Stage 1: 바닥 형성 (횡보)
    if (smaSlope.abs() < 2 && currentPrice < sma150 * 1.05) {
      return 1;
    }
    
    // Stage 2: 상승 추세
    if (currentPrice > sma150 && smaSlope > 0 && relativeStrength > 1.0) {
      return 2;
    }
    
    // Stage 3: 천장 형성 (횡보)
    if (smaSlope.abs() < 2 && currentPrice > sma150 * 0.95) {
      return 3;
    }
    
    // Stage 4: 하락 추세
    if (currentPrice < sma150 && smaSlope < 0) {
      return 4;
    }
    
    return 1; // 기본값
  }
  
  double _findResistance(List<CandleData> candles, int period) {
    final recentCandles = candles.sublist(candles.length - period);
    return recentCandles.map((c) => c.high).reduce(max);
  }
  
  double _findSupport(List<CandleData> candles, int period) {
    final recentCandles = candles.sublist(candles.length - period);
    return recentCandles.map((c) => c.low).reduce(min);
  }
  
  double _calculateConfidence(int stage, double volumeRatio, double relativeStrength) {
    double confidence = 0.5;
    
    // Stage 기준
    if (stage == 2) confidence += 0.2; // 최적의 매수 시점
    else if (stage == 4) confidence += 0.2; // 명확한 매도 시점
    
    // 거래량 기준
    if (volumeRatio > 1.5) confidence += 0.15;
    else if (volumeRatio > 1.3) confidence += 0.1;
    
    // 상대강도 기준
    if (relativeStrength > 1.2) confidence += 0.15;
    else if (relativeStrength > 1.1) confidence += 0.1;
    
    return confidence.clamp(0.0, 1.0);
  }
  
  TradingSignal _createHoldSignal(String reason) {
    return TradingSignal(
      action: SignalAction.hold,
      confidence: 0.5,
      reasoning: reason,
      indicators: {},
    );
  }
}

/// 전략 팩토리 클래스
class TradingStrategyFactory {
  static TradingStrategyAnalyzer create(TradingStrategy strategy) {
    switch (strategy) {
      case TradingStrategy.jesseLivermore:
        return JesseLivermoreStrategy();
      case TradingStrategy.larryWilliams:
        return LarryWilliamsStrategy();
      case TradingStrategy.stanWeinstein:
        return StanWeinsteinStrategy();
    }
  }
}