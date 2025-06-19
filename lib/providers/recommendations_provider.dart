import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_recommendation.dart';
import '../services/mock_data_service.dart';
import '../services/tradingview_webhook_service.dart';
import 'mock_data_provider.dart';
import 'tradingview_provider.dart';

class RecommendationsNotifier extends StateNotifier<AsyncValue<List<StockRecommendation>>> {
  final MockDataService _mockDataService;
  final TradingViewWebhookService _tradingViewService;
  final bool useMockData;
  
  RecommendationsNotifier(
    this._mockDataService, 
    this._tradingViewService, 
    {this.useMockData = false}
  ) : super(const AsyncValue.loading()) {
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    try {
      state = const AsyncValue.loading();
      
      List<StockRecommendation> recommendations;
      
      if (useMockData) {
        // Mock 데이터 사용 (개발/테스트용)
        recommendations = await _mockDataService.getRecommendations();
      } else {
        // 실제 TradingView 웹훅 데이터 사용
        recommendations = await _tradingViewService.getRecommendations();
        
        // 데이터가 없으면 Mock 데이터로 폴백
        if (recommendations.isEmpty) {
          print('No TradingView webhook data found, falling back to mock data');
          recommendations = await _mockDataService.getRecommendations();
        }
      }
      
      state = AsyncValue.data(recommendations);
    } catch (e, stack) {
      print('Error loading recommendations: $e');
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
  final tradingViewService = ref.watch(tradingViewWebhookServiceProvider);
  
  // 환경 변수나 설정에 따라 Mock 데이터 사용 여부 결정
  const useMockData = false; // 실제 TradingView 데이터 사용
  
  return RecommendationsNotifier(
    mockDataService,
    tradingViewService,
    useMockData: useMockData,
  );
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