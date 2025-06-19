import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tradingview_webhook_service.dart';

// TradingView Webhook 서비스 프로바이더
final tradingViewWebhookServiceProvider = Provider<TradingViewWebhookService>((ref) {
  return TradingViewWebhookService();
});