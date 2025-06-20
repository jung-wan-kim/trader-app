import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/watchlist_provider.dart';
import '../models/watchlist_item.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final watchlistAsync = ref.watch(watchlistNotifierProvider);
    final marketIndicesAsync = ref.watch(marketIndicesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          l10n?.watchlist ?? 'Watchlist',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddStockDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(watchlistNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 시장 요약 정보
          marketIndicesAsync.when(
            data: (indices) => _buildMarketSummary(indices),
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => _buildMarketSummary(null),
          ),
          
          // 관심 종목 리스트
          Expanded(
            child: watchlistAsync.when(
              data: (items) => items.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.read(watchlistNotifierProvider.notifier).refresh();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _buildStockCard(item);
                        },
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load watchlist',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.read(watchlistNotifierProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketSummary(Map<String, dynamic>? indices) {
    final l10n = AppLocalizations.of(context);
    
    // 기본값 설정
    final sp500 = indices?['sp500'] ?? {'value': 4567.23, 'changePercent': 0.85};
    final nasdaq = indices?['nasdaq'] ?? {'value': 14234.56, 'changePercent': 1.23};
    final dow = indices?['dow'] ?? {'value': 33987.45, 'changePercent': -0.34};
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.marketSummary ?? 'Market Summary',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMarketIndexCard(
                  'S&P 500', 
                  sp500['value'].toStringAsFixed(2), 
                  '${sp500['changePercent'] > 0 ? '+' : ''}${sp500['changePercent'].toStringAsFixed(2)}%', 
                  sp500['changePercent'] > 0
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMarketIndexCard(
                  'NASDAQ', 
                  nasdaq['value'].toStringAsFixed(2), 
                  '${nasdaq['changePercent'] > 0 ? '+' : ''}${nasdaq['changePercent'].toStringAsFixed(2)}%', 
                  nasdaq['changePercent'] > 0
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMarketIndexCard(
                  'DOW', 
                  dow['value'].toStringAsFixed(2), 
                  '${dow['changePercent'] > 0 ? '+' : ''}${dow['changePercent'].toStringAsFixed(2)}%', 
                  dow['changePercent'] > 0
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketIndexCard(String name, String value, String change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: isPositive ? const Color(0xFF00D632) : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(WatchlistItem item) {
    final isPositive = item.priceChange > 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[800],
          child: Text(
            item.symbol[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.symbol,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              item.name,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Vol: ${item.volume}',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${item.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? const Color(0xFF00D632) : Colors.red,
                  size: 14,
                ),
                const SizedBox(width: 2),
                Text(
                  '${isPositive ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF00D632) : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showStockDetails(item),
        onLongPress: () => _showRemoveStockDialog(item),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            l10n?.nothingInWatchlist ?? 'Nothing in your watchlist yet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.addStocksToWatchlist ?? 'Add stocks to track their performance',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddStockDialog(),
            icon: const Icon(Icons.add, color: Colors.black),
            label: Text(
              l10n?.addStock ?? 'Add Stock',
              style: const TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D632),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context);
    List<Map<String, dynamic>> searchResults = [];
    bool isSearching = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            l10n?.addToWatchlist ?? 'Add to Watchlist',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n?.searchStocks ?? 'Search stocks...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00D632)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.grey[400]),
                    onPressed: () async {
                      if (controller.text.isNotEmpty) {
                        setState(() => isSearching = true);
                        final results = await ref.read(watchlistNotifierProvider.notifier)
                            .searchStocks(controller.text);
                        setState(() {
                          searchResults = results;
                          isSearching = false;
                        });
                      }
                    },
                  ),
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    setState(() => isSearching = true);
                    final results = await ref.read(watchlistNotifierProvider.notifier)
                        .searchStocks(value);
                    setState(() {
                      searchResults = results;
                      isSearching = false;
                    });
                  }
                },
              ),
              if (isSearching)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
              if (searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  height: 200,
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return ListTile(
                        title: Text(
                          result['symbol'] ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          result['description'] ?? '',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        onTap: () async {
                          final success = await ref.read(watchlistNotifierProvider.notifier)
                              .addToWatchlist(
                            result['symbol'] ?? '',
                            result['description'] ?? '',
                          );
                          
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success 
                                      ? (l10n?.stockAddedToWatchlist ?? 'Stock added to watchlist')
                                      : 'Stock already in watchlist',
                                ),
                                backgroundColor: success ? const Color(0xFF00D632) : Colors.orange,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n?.cancel ?? 'Cancel',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStockDetails(WatchlistItem item) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.symbol} - ${item.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Price: \$${item.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Change: ${item.priceChange > 0 ? '+' : ''}${item.priceChange.toStringAsFixed(2)} (${item.priceChange > 0 ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%)',
              style: TextStyle(
                color: item.priceChange > 0 ? const Color(0xFF00D632) : Colors.red,
              ),
            ),
            Text(
              'Volume: ${item.volume}',
              style: const TextStyle(color: Colors.white70),
            ),
            if (item.lastUpdated != null)
              Text(
                'Last Updated: ${item.lastUpdated!.toLocal().toString().split('.')[0]}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Buy action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D632),
                    ),
                    child: Text(
                      l10n?.buy ?? 'Buy',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Sell action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      l10n?.sell ?? 'Sell',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveStockDialog(WatchlistItem item) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n?.remove ?? 'Remove',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Remove ${item.symbol} from your watchlist?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n?.cancel ?? 'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref.read(watchlistNotifierProvider.notifier)
                  .removeFromWatchlist(item.symbol);
              
              if (mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n?.stockRemovedFromWatchlist ?? 'Stock removed from watchlist'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              l10n?.remove ?? 'Remove',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}