import 'dart:math';
import 'package:faker/faker.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:trader_app/models/position.dart';
import 'package:trader_app/models/stock_info.dart';

class TestDataFactory {
  static final faker = Faker();
  static final random = Random();
  
  // Stock Recommendation Factory
  static StockRecommendation createRecommendation({
    String? id,
    String? symbol,
    double? currentPrice,
    double? targetPrice,
    TraderStrategy? strategy,
    RecommendationType? type,
    DateTime? createdAt,
  }) {
    final basePrice = currentPrice ?? random.nextDouble() * 1000 + 10;
    final isLong = type ?? (random.nextBool() ? RecommendationType.buy : RecommendationType.sell);
    
    return StockRecommendation(
      id: id ?? faker.guid.guid(),
      symbol: symbol ?? _generateStockSymbol(),
      companyName: faker.company.name(),
      currentPrice: basePrice,
      targetPrice: targetPrice ?? (isLong == RecommendationType.buy 
          ? basePrice * (1 + random.nextDouble() * 0.3)
          : basePrice * (1 - random.nextDouble() * 0.3)),
      stopLossPrice: isLong == RecommendationType.buy
          ? basePrice * (1 - random.nextDouble() * 0.1)
          : basePrice * (1 + random.nextDouble() * 0.1),
      recommendationType: isLong,
      confidence: random.nextDouble() * 0.3 + 0.7, // 70-100%
      strategy: strategy ?? createTraderStrategy(),
      analysis: _generateAnalysis(),
      createdAt: createdAt ?? DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: random.nextInt(30) + 1)),
    );
  }
  
  static List<StockRecommendation> createRecommendationList({
    required int count,
    TraderStrategy? strategy,
  }) {
    return List.generate(
      count,
      (index) => createRecommendation(strategy: strategy),
    );
  }
  
  // Trader Strategy Factory
  static TraderStrategy createTraderStrategy({
    String? id,
    String? name,
    StrategyType? type,
    double? performance,
  }) {
    return TraderStrategy(
      id: id ?? faker.guid.guid(),
      name: name ?? '${faker.person.firstName()} ${faker.lorem.word()}',
      type: type ?? StrategyType.values[random.nextInt(StrategyType.values.length)],
      description: faker.lorem.sentences(3).join(' '),
      performance: performance ?? (random.nextDouble() * 100 - 20), // -20% to 80%
      winRate: random.nextDouble() * 0.4 + 0.5, // 50-90%
      averageReturn: random.nextDouble() * 0.3 - 0.05, // -5% to 25%
      totalTrades: random.nextInt(1000) + 100,
      followers: random.nextInt(10000) + 100,
      rating: random.nextDouble() * 2 + 3, // 3-5 stars
      riskLevel: RiskLevel.values[random.nextInt(RiskLevel.values.length)],
    );
  }
  
  static List<TraderStrategy> createTraderList({required int count}) {
    return List.generate(count, (index) => createTraderStrategy());
  }
  
  // Position Factory
  static Position createPosition({
    String? id,
    String? symbol,
    PositionType? type,
    double? entryPrice,
    int? quantity,
    PositionStatus? status,
  }) {
    final basePrice = entryPrice ?? random.nextDouble() * 1000 + 10;
    final currentPrice = basePrice * (1 + (random.nextDouble() - 0.5) * 0.2);
    final qty = quantity ?? random.nextInt(100) + 1;
    
    return Position(
      id: id ?? faker.guid.guid(),
      symbol: symbol ?? _generateStockSymbol(),
      companyName: faker.company.name(),
      type: type ?? (random.nextBool() ? PositionType.long : PositionType.short),
      entryPrice: basePrice,
      currentPrice: currentPrice,
      quantity: qty,
      profitLoss: (currentPrice - basePrice) * qty,
      profitLossPercent: ((currentPrice - basePrice) / basePrice) * 100,
      status: status ?? PositionStatus.open,
      openedAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      closedAt: status == PositionStatus.closed 
          ? DateTime.now().subtract(Duration(hours: random.nextInt(24)))
          : null,
      recommendationId: faker.guid.guid(),
      traderId: faker.guid.guid(),
    );
  }
  
  static List<Position> createPositionList({
    required int count,
    PositionStatus? status,
  }) {
    return List.generate(
      count,
      (index) => createPosition(status: status),
    );
  }
  
  // Edge Case Data Generators
  static StockRecommendation createEdgeCaseRecommendation(EdgeCaseType type) {
    switch (type) {
      case EdgeCaseType.veryHighPrice:
        return createRecommendation(
          currentPrice: 999999.99,
          targetPrice: 1099999.99,
        );
      case EdgeCaseType.veryLowPrice:
        return createRecommendation(
          currentPrice: 0.01,
          targetPrice: 0.02,
        );
      case EdgeCaseType.longSymbol:
        return createRecommendation(
          symbol: 'VERYLONGSTOCKSYMBOL',
        );
      case EdgeCaseType.longCompanyName:
        return createRecommendation()
          ..companyName = 'Very Long Company Name That Should Be Truncated In The UI Display';
      case EdgeCaseType.highVolatility:
        final price = 100.0;
        return createRecommendation(
          currentPrice: price,
          targetPrice: price * 2,
          stopLossPrice: price * 0.5,
        );
    }
  }
  
  // Helper Methods
  static String _generateStockSymbol() {
    final symbols = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA', 'NVDA', 'META', 
                    'BRK.B', 'JPM', 'JNJ', 'V', 'WMT', 'PG', 'MA', 'HD'];
    return symbols[random.nextInt(symbols.length)];
  }
  
  static String _generateAnalysis() {
    final templates = [
      '기술적 지표가 강한 상승 신호를 보이고 있습니다. RSI ${random.nextInt(30) + 40}, MACD 골든크로스 확인.',
      '최근 실적 발표 후 긍정적인 반응. 목표주가 상향 조정 가능성 높음.',
      '섹터 전반적인 상승세와 함께 모멘텀 강화. 거래량 증가 추세.',
      '단기 조정 후 재상승 가능성. 주요 지지선에서 반등 신호 포착.',
    ];
    return templates[random.nextInt(templates.length)];
  }
}

// Test Scenarios
enum TestScenario {
  empty,
  single,
  normal,
  bulk,
  mixed,
}

enum EdgeCaseType {
  veryHighPrice,
  veryLowPrice,
  longSymbol,
  longCompanyName,
  highVolatility,
}

// Scenario Data Generators
class ScenarioDataFactory {
  static List<StockRecommendation> getRecommendationsByScenario(TestScenario scenario) {
    switch (scenario) {
      case TestScenario.empty:
        return [];
      case TestScenario.single:
        return [TestDataFactory.createRecommendation()];
      case TestScenario.normal:
        return TestDataFactory.createRecommendationList(count: 10);
      case TestScenario.bulk:
        return TestDataFactory.createRecommendationList(count: 1000);
      case TestScenario.mixed:
        return [
          ...TestDataFactory.createRecommendationList(count: 5),
          TestDataFactory.createEdgeCaseRecommendation(EdgeCaseType.veryHighPrice),
          TestDataFactory.createEdgeCaseRecommendation(EdgeCaseType.longCompanyName),
        ];
    }
  }
}