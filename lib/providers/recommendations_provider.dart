import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_recommendation.dart';
import '../services/mock_data_service.dart';
import 'mock_data_provider.dart';

class RecommendationsNotifier extends StateNotifier<AsyncValue<List<StockRecommendation>>> {
  final MockDataService _mockDataService;
  
  RecommendationsNotifier(this._mockDataService) : super(const AsyncValue.loading()) {
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    try {
      state = const AsyncValue.loading();
      final recommendations = await _mockDataService.getRecommendations();
      state = AsyncValue.data(recommendations);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadRecommendations();
  }

  void filterByAction(String? action) {
    state.whenData((recommendations) {
      if (action == null) {
        loadRecommendations();
      } else {
        final filtered = recommendations.where((r) => r.action == action).toList();
        state = AsyncValue.data(filtered);
      }
    });
  }

  void filterByRiskLevel(String? riskLevel) {
    state.whenData((recommendations) {
      if (riskLevel == null) {
        loadRecommendations();
      } else {
        final filtered = recommendations.where((r) => r.riskLevel == riskLevel).toList();
        state = AsyncValue.data(filtered);
      }
    });
  }

  void filterByTimeframe(String? timeframe) {
    state.whenData((recommendations) {
      if (timeframe == null) {
        loadRecommendations();
      } else {
        final filtered = recommendations.where((r) => r.timeframe == timeframe).toList();
        state = AsyncValue.data(filtered);
      }
    });
  }

  void sortByConfidence() {
    state.whenData((recommendations) {
      final sorted = List<StockRecommendation>.from(recommendations)
        ..sort((a, b) => b.confidence.compareTo(a.confidence));
      state = AsyncValue.data(sorted);
    });
  }

  void sortByPotentialProfit() {
    state.whenData((recommendations) {
      final sorted = List<StockRecommendation>.from(recommendations)
        ..sort((a, b) => b.potentialProfit.compareTo(a.potentialProfit));
      state = AsyncValue.data(sorted);
    });
  }

  void sortByDate() {
    state.whenData((recommendations) {
      final sorted = List<StockRecommendation>.from(recommendations)
        ..sort((a, b) => b.recommendedAt.compareTo(a.recommendedAt));
      state = AsyncValue.data(sorted);
    });
  }
}

// Provider definitions
final recommendationsProvider = 
    StateNotifierProvider<RecommendationsNotifier, AsyncValue<List<StockRecommendation>>>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return RecommendationsNotifier(mockDataService);
});

// Filtered providers
final filteredRecommendationsProvider = Provider<List<StockRecommendation>>((ref) {
  final recommendationsAsync = ref.watch(recommendationsProvider);
  return recommendationsAsync.maybeWhen(
    data: (recommendations) => recommendations,
    orElse: () => [],
  );
});

// Action specific providers
final buyRecommendationsProvider = Provider<List<StockRecommendation>>((ref) {
  final recommendations = ref.watch(filteredRecommendationsProvider);
  return recommendations.where((r) => r.action == 'BUY').toList();
});

final sellRecommendationsProvider = Provider<List<StockRecommendation>>((ref) {
  final recommendations = ref.watch(filteredRecommendationsProvider);
  return recommendations.where((r) => r.action == 'SELL').toList();
});

// Top recommendations provider
final topRecommendationsProvider = Provider<List<StockRecommendation>>((ref) {
  final recommendations = ref.watch(filteredRecommendationsProvider);
  final sorted = List<StockRecommendation>.from(recommendations)
    ..sort((a, b) => b.confidence.compareTo(a.confidence));
  return sorted.take(5).toList();
});