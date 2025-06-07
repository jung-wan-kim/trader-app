import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TradingService {
  final SupabaseClient _client;
  
  TradingService(this._client);
  
  /// 트레이딩 신호 조회
  Future<TradingSignal> getSignal({
    required String symbol,
    required TradingStrategy strategy,
    String timeframe = 'D',
  }) async {
    try {
      final response = await _client.functions.invoke(
        'trading-signals',
        body: {
          'symbol': symbol.toUpperCase(),
          'strategy': strategy.value,
          'timeframe': timeframe,
        },
      );
      
      if (response.data == null) {
        throw Exception('No signal received');
      }
      
      final signalData = response.data['signal'];
      return TradingSignal.fromJson(signalData);
    } catch (e) {
      throw Exception('Failed to fetch signal: $e');
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