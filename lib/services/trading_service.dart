import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'finnhub_service.dart';
import 'trading_strategies.dart';
import '../models/candle_data.dart';

class TradingService {
  final SupabaseClient _client;
  final FinnhubService _finnhubService = FinnhubService();
  
  TradingService(this._client);
  
  /// 트레이딩 신호 조회 - 로컬 전략 분석 사용
  Future<TradingSignal> getSignal({
    required String symbol,
    required TradingStrategy strategy,
    String timeframe = 'D',
  }) async {
    try {
      // 1. 주식 캔들 데이터 가져오기
      final to = DateTime.now();
      final from = to.subtract(const Duration(days: 200)); // 전략 분석을 위해 충분한 데이터
      
      final candles = await _finnhubService.getStockCandles(
        symbol: symbol,
        from: from,
        to: to,
        resolution: timeframe,
      );
      
      // 2. 데이터가 부족한 경우 처리
      if (candles.isEmpty) {
        return TradingSignal(
          symbol: symbol,
          action: SignalAction.hold,
          confidence: 0.0,
          reasoning: '데이터를 가져올 수 없습니다',
          indicators: {},
        );
      }
      
      // 3. 전략 분석기 생성 및 분석
      final analyzer = TradingStrategyFactory.create(strategy);
      final signal = analyzer.analyze(
        candles: candles,
        symbol: symbol,
      );
      
      // 4. 심볼 설정 및 반환
      signal.symbol = symbol;
      return signal;
      
    } catch (e) {
      // 에러 발생 시 기본 신호 반환
      return TradingSignal(
        symbol: symbol,
        action: SignalAction.hold,
        confidence: 0.0,
        reasoning: '분석 중 오류 발생: $e',
        indicators: {},
      );
    }
  }
  
  /// 여러 종목의 신호 조회
  Future<List<TradingSignal>> getMultipleSignals({
    required List<String> symbols,
    required TradingStrategy strategy,
  }) async {
    final signals = <TradingSignal>[];
    
    await Future.wait(
      symbols.map((symbol) async {
        try {
          final signal = await getSignal(
            symbol: symbol,
            strategy: strategy,
          );
          signals.add(signal..symbol = symbol);
        } catch (e) {
          print('Error fetching signal for $symbol: $e');
        }
      }),
    );
    
    return signals;
  }
}

// 트레이딩 전략 enum
enum TradingStrategy {
  jesseLivermore('jesse_livermore', 'Jesse Livermore', '추세 추종 전략'),
  larryWilliams('larry_williams', 'Larry Williams', '단기 모멘텀 전략'),
  stanWeinstein('stan_weinstein', 'Stan Weinstein', '스테이지 분석 전략');
  
  final String value;
  final String displayName;
  final String description;
  
  const TradingStrategy(this.value, this.displayName, this.description);
}

// 트레이딩 신호 모델
class TradingSignal {
  String? symbol;
  final SignalAction action;
  final double confidence;
  final double? entryPrice;
  final double? targetPrice;
  final double? stopLoss;
  final String reasoning;
  final Map<String, dynamic> indicators;
  
  TradingSignal({
    this.symbol,
    required this.action,
    required this.confidence,
    this.entryPrice,
    this.targetPrice,
    this.stopLoss,
    required this.reasoning,
    required this.indicators,
  });
  
  factory TradingSignal.fromJson(Map<String, dynamic> json) {
    return TradingSignal(
      action: SignalAction.fromString(json['action']),
      confidence: (json['confidence'] ?? 0.5).toDouble(),
      entryPrice: json['entry_price']?.toDouble(),
      targetPrice: json['target_price']?.toDouble(),
      stopLoss: json['stop_loss']?.toDouble(),
      reasoning: json['reasoning'] ?? '',
      indicators: json['indicators'] ?? {},
    );
  }
  
  String get confidencePercent => '${(confidence * 100).toStringAsFixed(0)}%';
  
  double? get expectedReturn {
    if (entryPrice != null && targetPrice != null) {
      return ((targetPrice! - entryPrice!) / entryPrice!) * 100;
    }
    return null;
  }
  
  double? get riskPercent {
    if (entryPrice != null && stopLoss != null) {
      return ((entryPrice! - stopLoss!) / entryPrice!) * 100;
    }
    return null;
  }
}

enum SignalAction {
  buy('buy', '매수', Colors.green),
  sell('sell', '매도', Colors.red),
  hold('hold', '보유', Colors.grey);
  
  final String value;
  final String korean;
  final Color color;
  
  const SignalAction(this.value, this.korean, this.color);
  
  static SignalAction fromString(String value) {
    return SignalAction.values.firstWhere(
      (action) => action.value == value,
      orElse: () => SignalAction.hold,
    );
  }
}