import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/performance_service.dart';
import 'supabase_auth_provider.dart';

// Performance service provider
final performanceServiceProvider = Provider((ref) => PerformanceService());

// Portfolio performance provider
final portfolioPerformanceProvider = FutureProvider<PortfolioPerformance>((ref) async {
  final performanceService = ref.watch(performanceServiceProvider);
  final auth = ref.watch(supabaseAuthProvider);
  final user = auth.currentUser;
  
  if (user == null) {
    return PortfolioPerformance.empty();
  }
  
  return await performanceService.getPortfolioPerformance(user.id);
});

// Recent trades provider
final recentTradesProvider = FutureProvider<List<TradeHistory>>((ref) async {
  final performanceService = ref.watch(performanceServiceProvider);
  final auth = ref.watch(supabaseAuthProvider);
  final user = auth.currentUser;
  
  if (user == null) {
    return [];
  }
  
  return await performanceService.getRecentTrades(user.id, limit: 5);
});

// Auto-refresh performance data every 30 seconds
final performanceRefreshProvider = StreamProvider.autoDispose<void>((ref) async* {
  while (true) {
    yield null;
    ref.invalidate(portfolioPerformanceProvider);
    ref.invalidate(recentTradesProvider);
    await Future.delayed(const Duration(seconds: 30));
  }
});