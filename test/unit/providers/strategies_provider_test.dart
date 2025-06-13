import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/providers/strategies_provider.dart';
import 'package:trader_app/providers/mock_data_provider.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:trader_app/models/trader_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('StrategiesProvider Tests', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer(
        overrides: [
          mockDataServiceProvider.overrideWithValue(MockDataService()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with loading state', () {
      final state = container.read(strategiesProvider);
      expect(state, isA<AsyncLoading>());
    });

    test('should load strategies successfully', () async {
      // Wait for strategies to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      expect(state.value, isNotNull);
      expect(state.value!.isNotEmpty, isTrue);
      
      // Check first strategy structure
      final firstStrategy = state.value!.first;
      expect(firstStrategy, isA<TraderStrategy>());
      expect(firstStrategy.id, isNotEmpty);
      expect(firstStrategy.traderId, isNotEmpty);
      expect(firstStrategy.traderName, isNotEmpty);
      expect(firstStrategy.strategyName, isNotEmpty);
      expect(firstStrategy.winRate, greaterThanOrEqualTo(0));
      expect(firstStrategy.winRate, lessThanOrEqualTo(100));
      expect(firstStrategy.rating, greaterThanOrEqualTo(1));
      expect(firstStrategy.rating, lessThanOrEqualTo(5));
    });

    test('should sort strategies by rating', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      notifier.sortByRating();
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      
      final strategies = state.value!;
      for (int i = 0; i < strategies.length - 1; i++) {
        expect(strategies[i].rating, greaterThanOrEqualTo(strategies[i + 1].rating));
      }
    });

    test('should sort strategies by win rate', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      notifier.sortByWinRate();
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      
      final strategies = state.value!;
      for (int i = 0; i < strategies.length - 1; i++) {
        expect(strategies[i].winRate, greaterThanOrEqualTo(strategies[i + 1].winRate));
      }
    });

    test('should sort strategies by followers', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      notifier.sortByFollowers();
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      
      final strategies = state.value!;
      for (int i = 0; i < strategies.length - 1; i++) {
        expect(strategies[i].followers, greaterThanOrEqualTo(strategies[i + 1].followers));
      }
    });

    test('should filter strategies by trading style', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      notifier.filterByTradingStyle('DAY_TRADING');
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      
      final strategies = state.value!;
      for (final strategy in strategies) {
        expect(strategy.tradingStyle, equals('DAY_TRADING'));
      }
    });

    test('should filter active strategies', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      notifier.filterByActive(true);
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      
      final strategies = state.value!;
      for (final strategy in strategies) {
        expect(strategy.isActive, isTrue);
      }
    });

    test('should clear filter when null trading style provided', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      
      // First filter by style
      notifier.filterByTradingStyle('SCALPING');
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Then clear filter
      notifier.filterByTradingStyle(null);
      await Future.delayed(const Duration(milliseconds: 50));
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      
      // Should have all strategies again
      final allStyles = state.value!.map((s) => s.tradingStyle).toSet();
      expect(allStyles.length, greaterThan(1));
    });

    test('should refresh strategies', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final notifier = container.read(strategiesProvider.notifier);
      await notifier.refresh();
      
      final state = container.read(strategiesProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.isNotEmpty, isTrue);
    });

    test('filteredStrategiesProvider should return all strategies', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final strategies = container.read(filteredStrategiesProvider);
      expect(strategies.isNotEmpty, isTrue);
    });

    test('topStrategiesProvider should return top 5 strategies by rating', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final topStrategies = container.read(topStrategiesProvider);
      expect(topStrategies.length, lessThanOrEqualTo(5));
      
      // Check they are sorted by rating
      for (int i = 0; i < topStrategies.length - 1; i++) {
        expect(topStrategies[i].rating, greaterThanOrEqualTo(topStrategies[i + 1].rating));
      }
    });

    test('activeStrategiesProvider should return only active strategies', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      final activeStrategies = container.read(activeStrategiesProvider);
      for (final strategy in activeStrategies) {
        expect(strategy.isActive, isTrue);
      }
    });

    test('trading style specific providers should filter correctly', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Test scalping strategies
      final scalpingStrategies = container.read(scalpingStrategiesProvider);
      for (final strategy in scalpingStrategies) {
        expect(strategy.tradingStyle, equals('SCALPING'));
      }
      
      // Test day trading strategies
      final dayTradingStrategies = container.read(dayTradingStrategiesProvider);
      for (final strategy in dayTradingStrategies) {
        expect(strategy.tradingStyle, equals('DAY_TRADING'));
      }
      
      // Test swing trading strategies
      final swingTradingStrategies = container.read(swingTradingStrategiesProvider);
      for (final strategy in swingTradingStrategies) {
        expect(strategy.tradingStyle, equals('SWING_TRADING'));
      }
      
      // Test position trading strategies
      final positionTradingStrategies = container.read(positionTradingStrategiesProvider);
      for (final strategy in positionTradingStrategies) {
        expect(strategy.tradingStyle, equals('POSITION_TRADING'));
      }
    });

    test('should handle error state gracefully', () async {
      // Override with a service that throws an error
      final errorContainer = ProviderContainer(
        overrides: [
          mockDataServiceProvider.overrideWithValue(
            _ErrorMockDataService(),
          ),
        ],
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      final state = errorContainer.read(strategiesProvider);
      expect(state, isA<AsyncError>());
      
      errorContainer.dispose();
    });

    test('TraderStrategy model calculations should be correct', () {
      final strategy = TraderStrategy(
        id: 'test-1',
        traderId: 'trader-1',
        traderName: 'Test Trader',
        strategyName: 'Test Strategy',
        description: 'Test description',
        tradingStyle: 'DAY_TRADING',
        winRate: 65.0,
        averageReturn: 2.5,
        maxDrawdown: 10.0,
        sharpeRatio: 1.8,
        totalTrades: 100,
        winningTrades: 65,
        losingTrades: 35,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        preferredAssets: ['AAPL', 'GOOGL'],
        performanceMetrics: {},
        riskManagement: 'Conservative',
        minimumCapital: 10000,
        followers: 1500,
        rating: 4.5,
        isActive: true,
      );
      
      expect(strategy.lossRate, equals(35.0));
      expect(strategy.profitFactor, greaterThan(0));
    });
  });
}

// Mock service that throws errors for testing
class _ErrorMockDataService extends MockDataService {
  @override
  Future<List<TraderStrategy>> getTraderStrategies() async {
    throw Exception('Test error');
  }
}