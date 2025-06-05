// Mock Data Service
// 백엔드 개발 전 사용할 목업 데이터 서비스

import 'dart:math';

class MockDataService {
  static final Random _random = Random();
  
  // 전략별 추천 종목 목업 데이터
  static List<Map<String, dynamic>> getRecommendations(String strategy) {
    final stocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA', 'NVDA', 'META', 'NFLX'];
    final recommendations = <Map<String, dynamic>>[];
    
    for (int i = 0; i < 5; i++) {
      final stock = stocks[_random.nextInt(stocks.length)];
      final currentPrice = 100 + _random.nextDouble() * 400;
      
      recommendations.add({
        'id': 'rec_${strategy}_$i',
        'symbol': stock,
        'name': _getCompanyName(stock),
        'currentPrice': currentPrice,
        'recommendation': _random.nextBool() ? 'BUY' : 'SELL',
        'stopLoss': currentPrice * 0.95,
        'takeProfit': currentPrice * 1.10,
        'positionSize': 2 + _random.nextInt(3),
        'riskRatio': 1.5 + _random.nextDouble(),
        'confidence': 0.7 + _random.nextDouble() * 0.3,
        'reason': _getRecommendationReason(strategy),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
    
    return recommendations;
  }
  
  static String _getCompanyName(String symbol) {
    final companies = {
      'AAPL': 'Apple Inc.',
      'GOOGL': 'Alphabet Inc.',
      'MSFT': 'Microsoft Corporation',
      'AMZN': 'Amazon.com Inc.',
      'TSLA': 'Tesla Inc.',
      'NVDA': 'NVIDIA Corporation',
      'META': 'Meta Platforms Inc.',
      'NFLX': 'Netflix Inc.',
    };
    return companies[symbol] ?? symbol;
  }
  
  static String _getRecommendationReason(String strategy) {
    switch (strategy) {
      case 'livermore':
        return '주요 저항선 돌파, 거래량 급증, 상승 추세 확인';
      case 'williams':
        return '변동성 돌파, Williams %R 과매도 탈출, 단기 모멘텀 강세';
      case 'weinstein':
        return 'Stage 2 진입, 30주 이동평균선 상향 돌파, 거래량 증가';
      default:
        return '기술적 지표 긍정적';
    }
  }
  
  // 사용자 포트폴리오 목업 데이터
  static List<Map<String, dynamic>> getUserPortfolio() {
    return [
      {
        'id': 'port_1',
        'symbol': 'AAPL',
        'shares': 10,
        'entryPrice': 180.50,
        'currentPrice': 195.89,
        'profitLoss': 153.90,
        'profitLossPercent': 8.53,
        'status': 'open',
      },
      {
        'id': 'port_2',
        'symbol': 'GOOGL',
        'shares': 5,
        'entryPrice': 140.25,
        'currentPrice': 138.50,
        'profitLoss': -8.75,
        'profitLossPercent': -1.25,
        'status': 'open',
      },
    ];
  }
  
  // 구독 플랜 목업 데이터
  static List<Map<String, dynamic>> getSubscriptionPlans() {
    return [
      {
        'id': 'basic',
        'name': 'Basic',
        'price': 9900,
        'features': [
          '주간 추천 5개',
          '기본 분석 리포트',
          '이메일 알림',
        ],
      },
      {
        'id': 'premium',
        'name': 'Premium',
        'price': 29900,
        'features': [
          '일일 추천',
          '실시간 알림',
          '심화 분석 리포트',
          '리스크 계산기',
        ],
      },
      {
        'id': 'professional',
        'name': 'Professional',
        'price': 99900,
        'features': [
          '모든 Premium 기능',
          'API 액세스',
          '백테스트 도구',
          '1:1 컨설팅',
        ],
      },
    ];
  }
}