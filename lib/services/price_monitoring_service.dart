import 'dart:async';
import 'package:flutter/foundation.dart';
import 'finnhub_service.dart';
import 'notification_service.dart';
import 'trading_service.dart';
import '../models/stock_recommendation.dart';

/// 가격 모니터링 서비스
/// 실시간으로 주식 가격을 모니터링하고 알림을 발송합니다
class PriceMonitoringService {
  static final PriceMonitoringService _instance = PriceMonitoringService._internal();
  factory PriceMonitoringService() => _instance;
  PriceMonitoringService._internal();

  final FinnhubService _finnhubService = FinnhubService();
  final NotificationService _notificationService = NotificationService();
  
  Timer? _monitoringTimer;
  final Map<String, MonitoredStock> _monitoredStocks = {};
  bool _isMonitoring = false;

  /// 모니터링 시작
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    
    // 5분마다 가격 체크 (API 제한 고려)
    _monitoringTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkPrices(),
    );
    
    // 즉시 한 번 체크
    await _checkPrices();
  }

  /// 모니터링 중지
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _isMonitoring = false;
  }

  /// 종목 추가
  void addStock({
    required String symbol,
    required double entryPrice,
    double? targetPrice,
    double? stopLoss,
    required SignalAction action,
  }) {
    _monitoredStocks[symbol] = MonitoredStock(
      symbol: symbol,
      entryPrice: entryPrice,
      targetPrice: targetPrice,
      stopLoss: stopLoss,
      action: action,
      addedAt: DateTime.now(),
    );
  }

  /// 종목 제거
  void removeStock(String symbol) {
    _monitoredStocks.remove(symbol);
  }

  /// 모니터링 중인 종목 목록
  List<MonitoredStock> get monitoredStocks => _monitoredStocks.values.toList();

  /// 가격 체크
  Future<void> _checkPrices() async {
    if (_monitoredStocks.isEmpty) return;
    
    for (final entry in _monitoredStocks.entries) {
      final symbol = entry.key;
      final stock = entry.value;
      
      try {
        final currentPrice = await _finnhubService.getCurrentPrice(symbol);
        if (currentPrice == null) continue;
        
        // 손절가 도달 체크
        if (stock.stopLoss != null) {
          if (stock.action == SignalAction.buy && currentPrice <= stock.stopLoss!) {
            await _notificationService.showPriceAlertNotification(
              symbol: symbol,
              currentPrice: currentPrice,
              targetPrice: stock.stopLoss!,
              isStopLoss: true,
            );
            
            // 모니터링에서 제거
            _monitoredStocks.remove(symbol);
            continue;
          } else if (stock.action == SignalAction.sell && currentPrice >= stock.stopLoss!) {
            await _notificationService.showPriceAlertNotification(
              symbol: symbol,
              currentPrice: currentPrice,
              targetPrice: stock.stopLoss!,
              isStopLoss: true,
            );
            
            // 모니터링에서 제거
            _monitoredStocks.remove(symbol);
            continue;
          }
        }
        
        // 목표가 도달 체크
        if (stock.targetPrice != null) {
          if (stock.action == SignalAction.buy && currentPrice >= stock.targetPrice!) {
            await _notificationService.showPriceAlertNotification(
              symbol: symbol,
              currentPrice: currentPrice,
              targetPrice: stock.targetPrice!,
              isStopLoss: false,
            );
            
            // 모니터링에서 제거
            _monitoredStocks.remove(symbol);
            continue;
          } else if (stock.action == SignalAction.sell && currentPrice <= stock.targetPrice!) {
            await _notificationService.showPriceAlertNotification(
              symbol: symbol,
              currentPrice: currentPrice,
              targetPrice: stock.targetPrice!,
              isStopLoss: false,
            );
            
            // 모니터링에서 제거
            _monitoredStocks.remove(symbol);
            continue;
          }
        }
        
        // 가격 업데이트
        stock.lastPrice = currentPrice;
        stock.lastChecked = DateTime.now();
        
      } catch (e) {
        debugPrint('Error checking price for $symbol: $e');
      }
    }
  }

  /// 일일 신호 체크 및 알림
  Future<void> checkDailySignals({
    required List<String> symbols,
    required TradingStrategy strategy,
  }) async {
    int totalSignals = 0;
    int buySignals = 0;
    int sellSignals = 0;
    
    final tradingService = TradingService(null!); // TODO: Supabase client 주입
    
    for (final symbol in symbols) {
      try {
        final signal = await tradingService.getSignal(
          symbol: symbol,
          strategy: strategy,
        );
        
        if (signal.action != SignalAction.hold && signal.confidence > 0.7) {
          totalSignals++;
          
          if (signal.action == SignalAction.buy) {
            buySignals++;
          } else if (signal.action == SignalAction.sell) {
            sellSignals++;
          }
          
          // 강한 신호일 경우 개별 알림
          if (signal.confidence > 0.8) {
            await _notificationService.showTradingSignalNotification(
              symbol: symbol,
              action: signal.action,
              price: signal.entryPrice ?? 0,
              reasoning: signal.reasoning,
            );
          }
        }
      } catch (e) {
        debugPrint('Error checking signal for $symbol: $e');
      }
    }
    
    // 일일 요약 알림
    if (totalSignals > 0) {
      await _notificationService.showDailyMarketSummary(
        totalSignals: totalSignals,
        buySignals: buySignals,
        sellSignals: sellSignals,
      );
    }
  }

  /// 포트폴리오 성과 체크
  Future<void> checkPortfolioPerformance({
    required double totalReturn,
    required double dayReturn,
  }) async {
    // 일간 수익률이 ±5% 이상일 때 알림
    if (dayReturn.abs() >= 5.0) {
      await _notificationService.showPortfolioAlertNotification(
        totalReturn: totalReturn,
        dayReturn: dayReturn,
      );
    }
  }
}

/// 모니터링 중인 종목 정보
class MonitoredStock {
  final String symbol;
  final double entryPrice;
  final double? targetPrice;
  final double? stopLoss;
  final SignalAction action;
  final DateTime addedAt;
  double? lastPrice;
  DateTime? lastChecked;

  MonitoredStock({
    required this.symbol,
    required this.entryPrice,
    this.targetPrice,
    this.stopLoss,
    required this.action,
    required this.addedAt,
    this.lastPrice,
    this.lastChecked,
  });

  double get currentReturn {
    if (lastPrice == null) return 0;
    
    if (action == SignalAction.buy) {
      return ((lastPrice! - entryPrice) / entryPrice) * 100;
    } else {
      return ((entryPrice - lastPrice!) / entryPrice) * 100;
    }
  }

  bool get isTargetReached {
    if (targetPrice == null || lastPrice == null) return false;
    
    if (action == SignalAction.buy) {
      return lastPrice! >= targetPrice!;
    } else {
      return lastPrice! <= targetPrice!;
    }
  }

  bool get isStopLossHit {
    if (stopLoss == null || lastPrice == null) return false;
    
    if (action == SignalAction.buy) {
      return lastPrice! <= stopLoss!;
    } else {
      return lastPrice! >= stopLoss!;
    }
  }
}