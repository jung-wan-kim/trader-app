import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/models/user_subscription.dart';
import 'package:trader_app/models/video_model.dart';

/// 테스트 유틸리티 클래스
class TestHelper {
  /// ProviderScope로 감싸진 테스트 위젯 생성
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  /// Mock 주식 추천 데이터 생성
  static StockRecommendation createMockStockRecommendation({
    String? id,
    String? stockCode,
    String? action,
    double? targetPrice,
    double? currentPrice,
    double? stopLoss,
  }) {
    return StockRecommendation(
      id: id ?? 'test-id-1',
      stockCode: stockCode ?? 'AAPL',
      stockName: 'Apple Inc.',
      traderName: 'Jesse Livermore',
      traderId: 'trader-1',
      action: action ?? 'BUY',
      targetPrice: targetPrice ?? 200.0,
      currentPrice: currentPrice ?? 150.0,
      stopLoss: stopLoss ?? 140.0,
      takeProfit: 180.0,
      reasoning: 'Strong technical breakout with volume',
      recommendedAt: DateTime(2024, 1, 1),
      timeframe: 'MEDIUM',
      confidence: 85.0,
      riskLevel: 'MEDIUM',
      technicalIndicators: {'rsi': 65.0, 'macd': 'bullish'},
      expectedReturn: 33.33,
      likes: 100,
      followers: 5000,
    );
  }

  /// Mock 트레이더 전략 데이터 생성
  static TraderStrategy createMockTraderStrategy({
    String? id,
    String? tradingStyle,
    double? winRate,
    bool? isActive,
  }) {
    return TraderStrategy(
      id: id ?? 'strategy-1',
      traderId: 'trader-1',
      traderName: 'Jesse Livermore',
      strategyName: 'Trend Following Strategy',
      description: 'Follows major market trends with pyramiding',
      tradingStyle: tradingStyle ?? 'SWING_TRADING',
      winRate: winRate ?? 75.0,
      averageReturn: 15.5,
      maxDrawdown: -8.2,
      sharpeRatio: 1.85,
      totalTrades: 100,
      winningTrades: 75,
      losingTrades: 25,
      createdAt: DateTime(2023, 1, 1),
      lastUpdated: DateTime(2024, 1, 1),
      preferredAssets: ['stocks', 'futures'],
      performanceMetrics: {'monthly_return': 12.5, 'volatility': 18.2},
      riskManagement: 'Stop-loss at 2% below entry',
      minimumCapital: 10000.0,
      followers: 15000,
      rating: 4.8,
      isActive: isActive ?? true,
      profileImageUrl: 'https://example.com/avatar.jpg',
    );
  }

  /// Mock 사용자 구독 데이터 생성
  static UserSubscription createMockUserSubscription({
    String? id,
    SubscriptionTier? tier,
    bool? isActive,
    DateTime? endDate,
  }) {
    return UserSubscription(
      id: id ?? 'sub-1',
      userId: 'user-1',
      planId: 'plan-pro',
      planName: 'Pro Plan',
      tier: tier ?? SubscriptionTier.pro,
      price: 29.99,
      currency: 'USD',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 335)),
      nextBillingDate: DateTime.now().add(const Duration(days: 30)),
      isActive: isActive ?? true,
      autoRenew: true,
      features: ['daily_recommendations', 'real_time_alerts', 'portfolio_tracking'],
      limits: {'recommendations_per_day': 20, 'alerts_per_month': 100},
      paymentMethod: PaymentMethod(
        id: 'pm-1',
        type: 'CARD',
        last4: '1234',
        brand: 'VISA',
        expiryDate: DateTime(2027, 12, 31),
      ),
      discountCode: null,
      discountAmount: null,
      history: [
        SubscriptionHistory(
          id: 'hist-1',
          action: 'CREATED',
          timestamp: DateTime.now().subtract(const Duration(days: 30)),
          description: 'Subscription created',
          amount: 29.99,
        ),
      ],
    );
  }

  /// Mock 비디오 모델 데이터 생성
  static VideoModel createMockVideoModel({
    String? id,
    String? username,
    int? likes,
    bool? isLiked,
  }) {
    return VideoModel(
      id: id ?? 'video-1',
      videoUrl: 'https://example.com/video.mp4',
      thumbnailUrl: 'https://example.com/thumbnail.jpg',
      username: username ?? 'test_user',
      userAvatar: 'https://example.com/avatar.jpg',
      description: 'Test video description',
      musicName: 'Test Music - Artist',
      likes: likes ?? 1000,
      comments: 50,
      shares: 25,
      isLiked: isLiked ?? false,
    );
  }

  /// JSON 데이터 샘플
  static Map<String, dynamic> get mockStockRecommendationJson => {
    'id': 'test-id-1',
    'stockCode': 'AAPL',
    'stockName': 'Apple Inc.',
    'traderName': 'Jesse Livermore',
    'traderId': 'trader-1',
    'action': 'BUY',
    'targetPrice': 200.0,
    'currentPrice': 150.0,
    'stopLoss': 140.0,
    'takeProfit': 180.0,
    'reasoning': 'Strong technical breakout',
    'recommendedAt': '2024-01-01T00:00:00.000Z',
    'timeframe': 'MEDIUM',
    'confidence': 85.0,
    'riskLevel': 'MEDIUM',
    'technicalIndicators': {'rsi': 65.0},
    'expectedReturn': 33.33,
    'likes': 100,
    'followers': 5000,
  };

  static Map<String, dynamic> get mockTraderStrategyJson => {
    'id': 'strategy-1',
    'traderId': 'trader-1',
    'traderName': 'Jesse Livermore',
    'strategyName': 'Trend Following',
    'description': 'Follows trends',
    'tradingStyle': 'SWING_TRADING',
    'winRate': 75.0,
    'averageReturn': 15.5,
    'maxDrawdown': -8.2,
    'sharpeRatio': 1.85,
    'totalTrades': 100,
    'winningTrades': 75,
    'losingTrades': 25,
    'createdAt': '2023-01-01T00:00:00.000Z',
    'lastUpdated': '2024-01-01T00:00:00.000Z',
    'preferredAssets': ['stocks'],
    'performanceMetrics': {'monthly_return': 12.5},
    'riskManagement': 'Stop-loss at 2%',
    'minimumCapital': 10000.0,
    'followers': 15000,
    'rating': 4.8,
    'isActive': true,
    'profileImageUrl': null,
  };

  static Map<String, dynamic> get mockUserSubscriptionJson => {
    'id': 'sub-1',
    'userId': 'user-1',
    'planId': 'plan-pro',
    'planName': 'Pro Plan',
    'tier': 'pro',
    'price': 29.99,
    'currency': 'USD',
    'startDate': '2024-01-01T00:00:00.000Z',
    'endDate': '2024-12-31T23:59:59.000Z',
    'nextBillingDate': '2024-02-01T00:00:00.000Z',
    'isActive': true,
    'autoRenew': true,
    'features': ['daily_recommendations'],
    'limits': {'recommendations_per_day': 20},
    'paymentMethod': {
      'id': 'pm-1',
      'type': 'CARD',
      'last4': '1234',
      'brand': 'VISA',
      'expiryDate': '2027-12-31T23:59:59.000Z',
    },
    'discountCode': null,
    'discountAmount': null,
    'history': [
      {
        'id': 'hist-1',
        'action': 'CREATED',
        'timestamp': '2024-01-01T00:00:00.000Z',
        'description': 'Created',
        'amount': 29.99,
      }
    ],
  };

  /// 테스트용 날짜 생성
  static DateTime get testDate => DateTime(2024, 1, 1);
  static DateTime get futureDate => DateTime(2024, 12, 31);
  static DateTime get pastDate => DateTime(2023, 1, 1);
}