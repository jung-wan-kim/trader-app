import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trader_strategy.dart';
import '../services/mock_data_service.dart';
import 'mock_data_provider.dart';

class StrategiesNotifier extends StateNotifier<AsyncValue<List<TraderStrategy>>> {
  final MockDataService _mockDataService;
  
  StrategiesNotifier(this._mockDataService) : super(const AsyncValue.loading()) {
    loadStrategies();
  }

  Future<void> loadStrategies() async {
    try {
      state = const AsyncValue.loading();
      final strategies = await _mockDataService.getTraderStrategies();
      state = AsyncValue.data(strategies);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadStrategies();
  }

  void sortByRating() {
    state.whenData((strategies) {
      final sorted = List<TraderStrategy>.from(strategies)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      state = AsyncValue.data(sorted);
    });
  }

  void sortByWinRate() {
    state.whenData((strategies) {
      final sorted = List<TraderStrategy>.from(strategies)
        ..sort((a, b) => b.winRate.compareTo(a.winRate));
      state = AsyncValue.data(sorted);
    });
  }

  void sortByFollowers() {
    state.whenData((strategies) {
      final sorted = List<TraderStrategy>.from(strategies)
        ..sort((a, b) => b.followers.compareTo(a.followers));
      state = AsyncValue.data(sorted);
    });
  }

  void filterByTradingStyle(String? style) {
    state.whenData((strategies) {
      if (style == null) {
        loadStrategies();
      } else {
        final filtered = strategies.where((s) => s.tradingStyle == style).toList();
        state = AsyncValue.data(filtered);
      }
    });
  }

  void filterByActive(bool isActive) {
    state.whenData((strategies) {
      final filtered = strategies.where((s) => s.isActive == isActive).toList();
      state = AsyncValue.data(filtered);
    });
  }
}

// Provider definitions
final strategiesProvider = 
    StateNotifierProvider<StrategiesNotifier, AsyncValue<List<TraderStrategy>>>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return StrategiesNotifier(mockDataService);
});

// Filtered providers
final filteredStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategiesAsync = ref.watch(strategiesProvider);
  return strategiesAsync.maybeWhen(
    data: (strategies) => strategies,
    orElse: () => [],
  );
});

// Top strategies provider
final topStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategies = ref.watch(filteredStrategiesProvider);
  final sorted = List<TraderStrategy>.from(strategies)
    ..sort((a, b) => b.rating.compareTo(a.rating));
  return sorted.take(5).toList();
});

// Active strategies provider
final activeStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategies = ref.watch(filteredStrategiesProvider);
  return strategies.where((s) => s.isActive).toList();
});

// Trading style specific providers
final scalpingStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategies = ref.watch(filteredStrategiesProvider);
  return strategies.where((s) => s.tradingStyle == 'SCALPING').toList();
});

final dayTradingStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategies = ref.watch(filteredStrategiesProvider);
  return strategies.where((s) => s.tradingStyle == 'DAY_TRADING').toList();
});

final swingTradingStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategies = ref.watch(filteredStrategiesProvider);
  return strategies.where((s) => s.tradingStyle == 'SWING_TRADING').toList();
});

final positionTradingStrategiesProvider = Provider<List<TraderStrategy>>((ref) {
  final strategies = ref.watch(filteredStrategiesProvider);
  return strategies.where((s) => s.tradingStyle == 'POSITION_TRADING').toList();
});