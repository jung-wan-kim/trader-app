import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watchlist_item.dart';
import '../services/watchlist_service.dart';
import './supabase_auth_provider.dart';

final watchlistServiceProvider = Provider((ref) => WatchlistService());

final watchlistProvider = FutureProvider<List<WatchlistItem>>((ref) async {
  final watchlistService = ref.watch(watchlistServiceProvider);
  final auth = ref.watch(supabaseAuthProvider);
  
  final user = auth.currentUser;
  if (user == null) {
    return [];
  }
  
  return await watchlistService.getUserWatchlist(user.id);
});

final marketIndicesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final watchlistService = ref.watch(watchlistServiceProvider);
  return await watchlistService.getMarketIndices();
});

final watchlistNotifierProvider = StateNotifierProvider<WatchlistNotifier, AsyncValue<List<WatchlistItem>>>((ref) {
  return WatchlistNotifier(ref);
});

class WatchlistNotifier extends StateNotifier<AsyncValue<List<WatchlistItem>>> {
  final Ref ref;
  
  WatchlistNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    try {
      state = const AsyncValue.loading();
      
      final watchlistService = ref.read(watchlistServiceProvider);
      final auth = ref.read(supabaseAuthProvider);
      
      final user = auth.currentUser;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }
      
      final items = await watchlistService.getUserWatchlist(user.id);
      state = AsyncValue.data(items);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> addToWatchlist(String symbol, String name) async {
    try {
      final watchlistService = ref.read(watchlistServiceProvider);
      final auth = ref.read(supabaseAuthProvider);
      
      final user = auth.currentUser;
      if (user == null) return false;
      
      final success = await watchlistService.addToWatchlist(user.id, symbol, name);
      
      if (success) {
        await _loadWatchlist(); // 리스트 새로고침
      }
      
      return success;
    } catch (e) {
      print('Error adding to watchlist: $e');
      return false;
    }
  }

  Future<bool> removeFromWatchlist(String symbol) async {
    try {
      final watchlistService = ref.read(watchlistServiceProvider);
      final auth = ref.read(supabaseAuthProvider);
      
      final user = auth.currentUser;
      if (user == null) return false;
      
      final success = await watchlistService.removeFromWatchlist(user.id, symbol);
      
      if (success) {
        await _loadWatchlist(); // 리스트 새로고침
      }
      
      return success;
    } catch (e) {
      print('Error removing from watchlist: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchStocks(String query) async {
    try {
      final watchlistService = ref.read(watchlistServiceProvider);
      return await watchlistService.searchStocks(query);
    } catch (e) {
      print('Error searching stocks: $e');
      return [];
    }
  }

  void refresh() {
    _loadWatchlist();
  }
}