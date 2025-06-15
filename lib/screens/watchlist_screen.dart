import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../generated/l10n/app_localizations.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  final List<Map<String, dynamic>> _watchlistStocks = [
    {
      'symbol': 'AAPL',
      'name': 'Apple Inc.',
      'price': 182.55,
      'change': 2.35,
      'changePercent': 1.31,
      'volume': '45.2M',
    },
    {
      'symbol': 'GOOGL',
      'name': 'Alphabet Inc.',
      'price': 138.72,
      'change': -1.28,
      'changePercent': -0.91,
      'volume': '28.7M',
    },
    {
      'symbol': 'MSFT',
      'name': 'Microsoft Corporation',
      'price': 418.23,
      'change': 5.67,
      'changePercent': 1.37,
      'volume': '32.1M',
    },
    {
      'symbol': 'TSLA',
      'name': 'Tesla, Inc.',
      'price': 248.50,
      'change': -8.32,
      'changePercent': -3.24,
      'volume': '89.3M',
    },
    {
      'symbol': 'NVDA',
      'name': 'NVIDIA Corporation',
      'price': 875.28,
      'change': 12.45,
      'changePercent': 1.44,
      'volume': '51.8M',
    },
    {
      'symbol': 'AMZN',
      'name': 'Amazon.com Inc.',
      'price': 186.43,
      'change': 0.87,
      'changePercent': 0.47,
      'volume': '41.2M',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 시장 요약 정보
          _buildMarketSummary(),
          
          // 관심 종목 리스트
          Expanded(
            child: _watchlistStocks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _watchlistStocks.length,
                    itemBuilder: (context, index) {
                      final stock = _watchlistStocks[index];
                      return _buildStockCard(stock, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStockDialog(),
        backgroundColor: const Color(0xFF00D632),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildMarketSummary() {
    final l10n = AppLocalizations.of(context);
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMarketIndexCard('S&P 500', '4,567.23', '+0.85%', true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMarketIndexCard('NASDAQ', '14,234.56', '+1.23%', true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMarketIndexCard('DOW', '33,987.45', '-0.34%', false),
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

  Widget _buildStockCard(Map<String, dynamic> stock, int index) {
    final isPositive = stock['change'] > 0;
    
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
            stock['symbol'][0],
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
              stock['symbol'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              stock['name'],
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
            'Vol: ${stock['volume']}',
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
              '\$${stock['price'].toStringAsFixed(2)}',
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
                  '${isPositive ? '+' : ''}${stock['changePercent'].toStringAsFixed(2)}%',
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
        onTap: () => _showStockDetails(stock),
        onLongPress: () => _showRemoveStockDialog(stock, index),
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
              style: TextStyle(color: Colors.black),
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
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n?.addToWatchlist ?? 'Add to Watchlist',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
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
          ),
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
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addStock(controller.text.toUpperCase());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D632),
            ),
            child: Text(
              l10n?.addStock ?? 'Add',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final l10n = AppLocalizations.of(context);
    // 검색 기능 구현
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n?.searchStocks ?? 'Search Stocks',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Search functionality will be implemented with real stock data API.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Color(0xFF00D632)),
            ),
          ),
        ],
      ),
    );
  }

  void _showStockDetails(Map<String, dynamic> stock) {
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
              '${stock['symbol']} - ${stock['name']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Price: \$${stock['price'].toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Change: ${stock['change'] > 0 ? '+' : ''}${stock['change'].toStringAsFixed(2)} (${stock['change'] > 0 ? '+' : ''}${stock['changePercent'].toStringAsFixed(2)}%)',
              style: TextStyle(
                color: stock['change'] > 0 ? const Color(0xFF00D632) : Colors.red,
              ),
            ),
            Text(
              'Volume: ${stock['volume']}',
              style: const TextStyle(color: Colors.white70),
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
                      style: TextStyle(color: Colors.black),
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
                      style: TextStyle(color: Colors.white),
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

  void _showRemoveStockDialog(Map<String, dynamic> stock, int index) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n?.remove ?? 'Remove',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Remove ${stock['symbol']} from your watchlist?',
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
            onPressed: () {
              setState(() {
                _watchlistStocks.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n?.stockRemovedFromWatchlist ?? 'Stock removed from watchlist'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              l10n?.remove ?? 'Remove',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _addStock(String symbol) {
    final l10n = AppLocalizations.of(context);
    // 실제로는 API에서 주식 정보를 가져옴
    final newStock = {
      'symbol': symbol,
      'name': '$symbol Inc.',
      'price': 100.0 + (DateTime.now().millisecond % 100),
      'change': (DateTime.now().millisecond % 10) - 5.0,
      'changePercent': ((DateTime.now().millisecond % 10) - 5.0) / 100 * 100,
      'volume': '${(DateTime.now().millisecond % 100)}M',
    };
    
    setState(() {
      _watchlistStocks.add(newStock);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.stockAddedToWatchlist ?? 'Stock added to watchlist'),
        backgroundColor: const Color(0xFF00D632),
      ),
    );
  }
}