import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_provider.dart';

class PositionScreen extends ConsumerWidget {
  const PositionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionsAsync = ref.watch(portfolioProvider);
    final portfolioStats = ref.watch(portfolioStatsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(portfolioStats),
            _buildStatsCards(portfolioStats),
            Expanded(
              child: positionsAsync.when(
                data: (positions) => _buildPositionsList(positions, ref),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00D632),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading positions',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PortfolioStats stats) {
    final isProfit = stats.totalPnL >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isProfit 
                      ? const Color(0xFF00D632).withOpacity(0.2)
                      : const Color(0xFFFF3B30).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isProfit ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: isProfit 
                          ? const Color(0xFF00D632)
                          : const Color(0xFFFF3B30),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isProfit ? '+' : ''}${stats.totalPnLPercent.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isProfit 
                            ? const Color(0xFF00D632)
                            : const Color(0xFFFF3B30),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                '\$${stats.totalValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${isProfit ? '+' : ''}\$${stats.totalPnL.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isProfit 
                          ? const Color(0xFF00D632)
                          : const Color(0xFFFF3B30),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' today',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(PortfolioStats stats) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Win Rate',
              value: '${stats.winRate.toStringAsFixed(1)}%',
              icon: Icons.check_circle_outline,
              color: const Color(0xFF00D632),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'Positions',
              value: stats.openPositions.toString(),
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'Day P&L',
              value: '\$${stats.dayPnL.toStringAsFixed(0)}',
              icon: stats.dayPnL >= 0 
                  ? Icons.trending_up 
                  : Icons.trending_down,
              color: stats.dayPnL >= 0 
                  ? const Color(0xFF00D632)
                  : const Color(0xFFFF3B30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsList(List<Position> positions, WidgetRef ref) {
    final openPositions = positions.where((p) => p.status == 'OPEN').toList();

    if (openPositions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              'No open positions',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start trading to see your positions',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: openPositions.length,
      itemBuilder: (context, index) {
        final position = openPositions[index];
        return _buildPositionCard(position, ref, context);
      },
    );
  }

  Widget _buildPositionCard(Position position, WidgetRef ref, BuildContext context) {
    final isProfit = position.isProfit;
    final pnlColor = isProfit ? const Color(0xFF00D632) : const Color(0xFFFF3B30);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[800]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position.stockCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    position.stockName,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${position.marketValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: pnlColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${isProfit ? '+' : ''}${position.unrealizedPnLPercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: pnlColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPositionDetail(
                  label: 'Quantity',
                  value: position.quantity.toString(),
                ),
              ),
              Expanded(
                child: _buildPositionDetail(
                  label: 'Avg Cost',
                  value: '\$${position.entryPrice.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _buildPositionDetail(
                  label: 'Current',
                  value: '\$${position.currentPrice.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _buildPositionDetail(
                  label: 'P&L',
                  value: '\$${position.unrealizedPnL.toStringAsFixed(2)}',
                  valueColor: pnlColor,
                ),
              ),
            ],
          ),
          if (position.stopLoss != null || position.takeProfit != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.grey),
            const SizedBox(height: 12),
            Row(
              children: [
                if (position.stopLoss != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: Colors.red[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'SL: \$${position.stopLoss!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (position.takeProfit != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 14,
                          color: Colors.green[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'TP: \$${position.takeProfit!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.green[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _showClosePositionDialog(context, ref, position);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement edit position
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00D632),
                    side: const BorderSide(color: Color(0xFF00D632)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionDetail({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showClosePositionDialog(BuildContext context, WidgetRef ref, Position position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Close Position',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Close ${position.quantity} shares of ${position.stockCode}?',
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: position.isProfit 
                    ? const Color(0xFF00D632).withOpacity(0.1)
                    : const Color(0xFFFF3B30).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'P&L',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    '${position.isProfit ? '+' : ''}\$${position.unrealizedPnL.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: position.isProfit 
                          ? const Color(0xFF00D632)
                          : const Color(0xFFFF3B30),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(portfolioProvider.notifier).closePosition(position.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Position closed successfully'),
                  backgroundColor: Color(0xFF00D632),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D632),
            ),
            child: const Text('Close Position'),
          ),
        ],
      ),
    );
  }
}