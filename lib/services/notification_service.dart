import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/stock_recommendation.dart';
import '../services/trading_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// 알림 서비스 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android 초기화 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS 초기화 설정
    final iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // 초기화 설정 통합
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 알림 초기화
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  /// 알림 권한 요청
  Future<bool> requestPermissions() async {
    // Android 13 이상에서 알림 권한 요청
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  /// 매매 신호 알림 표시
  Future<void> showTradingSignalNotification({
    required String symbol,
    required SignalAction action,
    required double price,
    required String reasoning,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    final androidDetails = AndroidNotificationDetails(
      'trading_signals',
      '매매 신호',
      channelDescription: 'AI 트레이딩 매매 신호 알림',
      importance: Importance.high,
      priority: Priority.high,
      ticker: '새로운 매매 신호',
      styleInformation: BigTextStyleInformation(
        reasoning,
        contentTitle: '${action.korean} 신호: $symbol',
        summaryText: '\$${price.toStringAsFixed(2)}',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '${action.korean} 신호: $symbol',
      reasoning,
      details,
      payload: 'symbol:$symbol,action:${action.value}',
    );
  }

  /// 가격 도달 알림 (손절가/목표가)
  Future<void> showPriceAlertNotification({
    required String symbol,
    required double currentPrice,
    required double targetPrice,
    required bool isStopLoss,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final priceType = isStopLoss ? '손절가' : '목표가';
    final emoji = isStopLoss ? '⚠️' : '🎯';
    
    final androidDetails = AndroidNotificationDetails(
      'price_alerts',
      '가격 알림',
      channelDescription: '손절가 및 목표가 도달 알림',
      importance: Importance.max,
      priority: Priority.max,
      ticker: '$priceType 도달',
      color: isStopLoss ? const Color(0xFFE91E63) : const Color(0xFF4CAF50),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '$emoji $symbol $priceType 도달',
      '현재가: \$${currentPrice.toStringAsFixed(2)} → ${priceType}: \$${targetPrice.toStringAsFixed(2)}',
      details,
      payload: 'symbol:$symbol,type:price_alert',
    );
  }

  /// 포트폴리오 성과 알림
  Future<void> showPortfolioAlertNotification({
    required double totalReturn,
    required double dayReturn,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final isPositive = dayReturn >= 0;
    final emoji = isPositive ? '📈' : '📉';
    final sign = isPositive ? '+' : '';
    
    final androidDetails = AndroidNotificationDetails(
      'portfolio_alerts',
      '포트폴리오 알림',
      channelDescription: '포트폴리오 성과 및 변동 알림',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE91E63),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '$emoji 오늘의 포트폴리오 성과',
      '일간 수익률: $sign${dayReturn.toStringAsFixed(2)}%\n전체 수익률: $sign${totalReturn.toStringAsFixed(2)}%',
      details,
      payload: 'type:portfolio',
    );
  }

  /// 전략 교육 알림
  Future<void> showEducationNotification({
    required String title,
    required String content,
    required String strategyName,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    final androidDetails = AndroidNotificationDetails(
      'education',
      '전략 교육',
      channelDescription: '트레이딩 전략 교육 콘텐츠',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      styleInformation: BigTextStyleInformation(content),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '💡 $title',
      content,
      details,
      payload: 'type:education,strategy:$strategyName',
    );
  }

  /// 일일 시장 요약 알림
  Future<void> showDailyMarketSummary({
    required int totalSignals,
    required int buySignals,
    required int sellSignals,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    final androidDetails = AndroidNotificationDetails(
      'daily_summary',
      '일일 요약',
      channelDescription: '매일 시장 요약 및 신호 현황',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: '오늘의 시장 요약',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      '📊 오늘의 AI 트레이딩 신호',
      '총 $totalSignals개 신호 (매수: $buySignals, 매도: $sellSignals)\n확인 시간: $timeString',
      details,
      payload: 'type:daily_summary',
    );
  }

  /// 예약 알림 설정 (매일 특정 시간)
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'scheduled',
      '예약 알림',
      channelDescription: '정기적으로 발송되는 예약 알림',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 매일 반복 알림 설정
    await _notifications.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 특정 알림 취소
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  // iOS 로컬 알림 수신 처리
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    // iOS에서 앱이 포그라운드일 때 알림 처리
    print('iOS notification received: $title');
  }

  // 알림 탭 처리
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // payload 파싱하여 적절한 화면으로 이동
      final parts = payload.split(',');
      for (final part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          final key = keyValue[0];
          final value = keyValue[1];
          
          // 심볼 기반 네비게이션
          if (key == 'symbol') {
            // TODO: Navigate to stock detail screen
            print('Navigate to stock: $value');
          }
        }
      }
    }
  }
}