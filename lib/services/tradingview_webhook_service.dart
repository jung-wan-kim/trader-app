import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/stock_recommendation.dart';
import '../config/env_config.dart';

class TradingViewWebhookService {
  late final SupabaseClient _supabase;
  
  TradingViewWebhookService() {
    // 환경 변수에서 Supabase 설정 가져오기
    if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
      throw Exception('Supabase configuration not found. Please check your environment variables.');
    }
    
    _supabase = SupabaseClient(EnvConfig.supabaseUrl, EnvConfig.supabaseAnonKey);
  }

  Future<List<StockRecommendation>> getRecommendations() async {
    try {
      // 최근 24시간 이내의 웹훅 데이터 가져오기
      final response = await _supabase
          .from('tradingview_webhooks')
          .select()
          .gte('created_at', DateTime.now().subtract(const Duration(hours: 24)).toIso8601String())
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      final List<StockRecommendation> recommendations = [];
      
      for (final webhook in response as List<dynamic>) {
        try {
          // Null 체크 및 안전한 타입 변환
          if (webhook == null || webhook['payload'] == null || webhook['event_type'] == null) {
            continue;
          }
          
          final payload = webhook['payload'] as Map<String, dynamic>? ?? {};
          final eventType = webhook['event_type']?.toString() ?? '';
          
          // event_type이 buy 또는 sell인 경우만 처리
          if (eventType == 'buy' || eventType == 'sell') {
            // 가격 안전한 변환
            final price = _parseDouble(payload['price']) ?? 0.0;
            
            // 필수 필드 검증
            if (price <= 0 || payload['ticker'] == null) {
              print('Invalid webhook data: missing price or ticker');
              continue;
            }
            
            recommendations.add(
              StockRecommendation(
                id: webhook['id'].toString(),
                stockCode: payload['ticker'].toString(),
                stockName: payload['ticker'].toString(), // 실제로는 별도 API로 회사명 조회 필요
                traderName: payload['strategy']?.toString() ?? 'WR Signal',
                traderId: 'tradingview_webhook',
                action: eventType.toUpperCase(),
                currentPrice: price,
                targetPrice: _calculateTargetPrice(price, eventType),
                stopLoss: _calculateStopLoss(price, eventType),
                takeProfit: _calculateTargetPrice(price, eventType),
                reasoning: _generateReasoning(
                  eventType,
                  payload['ticker'].toString(),
                  payload['indicators'] as Map<String, dynamic>? ?? {},
                ),
                recommendedAt: _parseDateTime(webhook['created_at']) ?? DateTime.now(),
                timeframe: _mapTimeframe(payload['timeframe']?.toString() ?? '1D'),
                confidence: _calculateConfidence(payload['indicators'] as Map<String, dynamic>? ?? {}),
                riskLevel: _calculateRiskLevel(eventType),
                technicalIndicators: _mapIndicators(payload['indicators'] as Map<String, dynamic>? ?? {}),
                expectedReturn: _calculateExpectedReturn(price, eventType),
                likes: 0,
                followers: 0,
              ),
            );
          }
        } catch (e) {
          print('Error processing webhook item: $e');
          continue;
        }
      }
      
      return recommendations;
    } catch (e) {
      print('Error fetching TradingView webhooks: $e');
      return [];
    }
  }

  double _calculateTargetPrice(double currentPrice, String action) {
    // Buy: 5% 상승 목표, Sell: 5% 하락 목표
    return action == 'buy' 
        ? currentPrice * 1.05 
        : currentPrice * 0.95;
  }

  double _calculateStopLoss(double currentPrice, String action) {
    // Buy: 2% 손절, Sell: 2% 손절
    return action == 'buy' 
        ? currentPrice * 0.98 
        : currentPrice * 1.02;
  }

  String _generateReasoning(String action, String ticker, Map<String, dynamic> indicators) {
    final wrSignal = indicators['wr'] ?? indicators['wr_signal'];
    final macd = indicators['macd'];
    
    if (action == 'buy') {
      return 'W%R 지표가 매수 신호($wrSignal)를 나타내고 있습니다. '
             '${macd != null ? "MACD: $macd" : ""} '
             '$ticker 종목에 대한 상승 모멘텀이 감지되었습니다.';
    } else {
      return 'W%R 지표가 매도 신호($wrSignal)를 나타내고 있습니다. '
             '${macd != null ? "MACD: $macd" : ""} '
             '$ticker 종목에 대한 하락 위험이 감지되었습니다.';
    }
  }

  String _mapTimeframe(String timeframe) {
    switch (timeframe.toUpperCase()) {
      case '1M':
      case '5M':
      case '15M':
      case '30M':
      case '1H':
        return 'SHORT';
      case '4H':
      case '1D':
        return 'MEDIUM';
      case '1W':
      case '1M':
        return 'LONG';
      default:
        return 'MEDIUM';
    }
  }

  double _calculateConfidence(Map<String, dynamic> indicators) {
    // W%R 신호가 명확하면 높은 신뢰도
    final wrSignal = indicators['wr'] ?? indicators['wr_signal'];
    if (wrSignal == 1 || wrSignal == 0) {
      return 75.0; // 기본 75% 신뢰도
    }
    return 60.0;
  }

  String _calculateRiskLevel(String action) {
    // 실제로는 변동성 등을 고려해야 하지만, 간단히 구현
    return 'MEDIUM';
  }

  Map<String, dynamic> _mapIndicators(Map<String, dynamic> indicators) {
    return {
      'W%R': indicators['wr'] ?? indicators['wr_signal'] ?? 0,
      'MACD': indicators['macd'] ?? 0,
      if (indicators.containsKey('rsi')) 'RSI': indicators['rsi'],
      if (indicators.containsKey('volume')) 'Volume': indicators['volume'],
    };
  }

  double _calculateExpectedReturn(double currentPrice, String action) {
    // 목표가 기준 수익률 계산
    final targetPrice = _calculateTargetPrice(currentPrice, action);
    return ((targetPrice - currentPrice) / currentPrice * 100).abs();
  }

  // 실시간 업데이트를 위한 스트림
  Stream<List<StockRecommendation>> getRecommendationsStream() {
    return _supabase
        .from('tradingview_webhooks')
        .stream(primaryKey: ['id'])
        .eq('status', 'pending')
        .map((List<Map<String, dynamic>> data) {
          final recommendations = <StockRecommendation>[];
          
          for (final webhook in data) {
            final payload = webhook['payload'] as Map<String, dynamic>;
            final eventType = webhook['event_type'] as String;
            
            if (eventType == 'buy' || eventType == 'sell') {
              recommendations.add(
                StockRecommendation(
                  id: webhook['id'].toString(),
                  stockCode: payload['ticker'] ?? '',
                  stockName: payload['ticker'] ?? '',
                  traderName: payload['strategy'] ?? 'WR Signal',
                  traderId: 'tradingview_webhook',
                  action: eventType.toUpperCase(),
                  currentPrice: (payload['price'] ?? 0).toDouble(),
                  targetPrice: _calculateTargetPrice(
                    (payload['price'] ?? 0).toDouble(), 
                    eventType
                  ),
                  stopLoss: _calculateStopLoss(
                    (payload['price'] ?? 0).toDouble(), 
                    eventType
                  ),
                  takeProfit: _calculateTargetPrice(
                    (payload['price'] ?? 0).toDouble(), 
                    eventType
                  ),
                  reasoning: _generateReasoning(
                    eventType,
                    payload['ticker'] ?? '',
                    payload['indicators'] ?? {},
                  ),
                  recommendedAt: DateTime.parse(webhook['created_at']),
                  timeframe: _mapTimeframe(payload['timeframe'] ?? '1D'),
                  confidence: _calculateConfidence(payload['indicators'] ?? {}),
                  riskLevel: _calculateRiskLevel(eventType),
                  technicalIndicators: _mapIndicators(payload['indicators'] ?? {}),
                  expectedReturn: _calculateExpectedReturn(
                    (payload['price'] ?? 0).toDouble(),
                    eventType
                  ),
                  likes: 0,
                  followers: 0,
                ),
              );
            }
          }
          
          return recommendations;
        });
  }

  // 안전한 double 파싱
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // 안전한 DateTime 파싱
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}