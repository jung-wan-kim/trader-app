import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock_recommendation.dart';
import '../models/candle_data.dart';
import '../providers/portfolio_provider.dart';
import '../providers/mock_data_provider.dart';
import '../providers/stock_data_provider.dart';
import '../widgets/risk_calculator.dart';
import '../widgets/position_size_calculator.dart';
import '../widgets/candle_chart.dart';

class StrategyDetailScreen extends ConsumerStatefulWidget {
  final StockRecommendation recommendation;

  const StrategyDetailScreen({
    super.key,
    required this.recommendation,
  });

  @override
  ConsumerState<StrategyDetailScreen> createState() => _StrategyDetailScreenState();
}

class _StrategyDetailScreenState extends ConsumerState<StrategyDetailScreen> {
  bool showRiskCalculator = false;
  bool showPositionCalculator = false;

  @override
  Widget build(BuildContext context) {
    final recommendation = widget.recommendation;
    final isProfit = recommendation.potentialProfit > 0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          recommendation.stockCode,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStockHeader(),
            _buildActionSection(),
            _buildCandleChart(),
            _buildPriceTargets(),
            _buildReasoningSection(),
            _buildTechnicalIndicators(),
            _buildTraderInfo(),
            _buildToolsSection(),
            if (showRiskCalculator) _buildRiskCalculatorSection(),
            if (showPositionCalculator) _buildPositionCalculatorSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildStockHeader() {
    final recommendation = widget.recommendation;
    final priceChange = recommendation.currentPrice - (recommendation.currentPrice * 0.98);
    final priceChangePercent = (priceChange / (recommendation.currentPrice * 0.98)) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recommendation.stockName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${recommendation.currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priceChange >= 0 
                      ? const Color(0xFF00D632).withOpacity(0.2)
                      : const Color(0xFFFF3B30).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      priceChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                      color: priceChange >= 0 
                          ? const Color(0xFF00D632)
                          : const Color(0xFFFF3B30),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${priceChangePercent.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: priceChange >= 0 
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
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    final recommendation = widget.recommendation;
    final actionColor = recommendation.action == 'BUY' 
        ? const Color(0xFF00D632)
        : recommendation.action == 'SELL'
            ? const Color(0xFFFF3B30)
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: actionColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: actionColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: actionColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              recommendation.action == 'BUY' 
                  ? Icons.trending_up
                  : recommendation.action == 'SELL'
                      ? Icons.trending_down
                      : Icons.pause,
              color: actionColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.action,
                  style: TextStyle(
                    color: actionColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence: ${recommendation.confidence.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Risk Level',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRiskColor(recommendation.riskLevel).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendation.riskLevel,
                  style: TextStyle(
                    color: _getRiskColor(recommendation.riskLevel),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCandleChart() {
    final candleDataAsync = ref.watch(
      stockCandleDataProvider(widget.recommendation.stockCode),
    );
    
    return Container(
      margin: const EdgeInsets.all(20),
      child: candleDataAsync.when(
        data: (candles) => CandleChart(
          candles: candles,
          currentPrice: widget.recommendation.currentPrice,
          stopLoss: widget.recommendation.stopLoss,
          takeProfit: widget.recommendation.targetPrice,
        ),
        loading: () => Container(
          height: 400,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00D632),
            ),
          ),
        ),
        error: (error, stack) => Container(
          height: 400,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.grey[600],
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load chart data',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Using simulated data',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceTargets() {
    final recommendation = widget.recommendation;

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Targets',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPriceCard(
                  title: 'Stop Loss',
                  price: recommendation.stopLoss,
                  percentage: ((recommendation.stopLoss - recommendation.currentPrice) / 
                      recommendation.currentPrice * 100),
                  color: const Color(0xFFFF3B30),
                  icon: Icons.shield_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceCard(
                  title: 'Target Price',
                  price: recommendation.targetPrice,
                  percentage: recommendation.potentialProfit,
                  color: const Color(0xFF00D632),
                  icon: Icons.flag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Risk/Reward Ratio',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  '1:${recommendation.riskRewardRatio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard({
    required String title,
    required double price,
    required double percentage,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
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
          const SizedBox(height: 8),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage > 0 ? '+' : ''}${percentage.toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasoningSection() {
    final recommendation = widget.recommendation;

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis & Reasoning',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              recommendation.reasoning,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalIndicators() {
    final indicators = widget.recommendation.technicalIndicators;
    if (indicators == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technical Indicators',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildIndicatorRow('RSI', indicators['RSI'].toString()),
                const Divider(color: Colors.grey),
                _buildIndicatorRow('MACD', indicators['MACD'].toString()),
                const Divider(color: Colors.grey),
                _buildIndicatorRow('SMA 50', '\$${indicators['SMA50'].toStringAsFixed(2)}'),
                const Divider(color: Colors.grey),
                _buildIndicatorRow('SMA 200', '\$${indicators['SMA200'].toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraderInfo() {
    final recommendation = widget.recommendation;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF00D632),
            child: Text(
              recommendation.traderName.substring(0, 2).toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.traderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${recommendation.followers} followers',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00D632).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Follow',
              style: TextStyle(
                color: Color(0xFF00D632),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trading Tools',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  icon: Icons.calculate_outlined,
                  label: 'Risk Calculator',
                  onTap: () {
                    setState(() {
                      showRiskCalculator = !showRiskCalculator;
                      showPositionCalculator = false;
                    });
                  },
                  isActive: showRiskCalculator,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildToolButton(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Position Size',
                  onTap: () {
                    setState(() {
                      showPositionCalculator = !showPositionCalculator;
                      showRiskCalculator = false;
                    });
                  },
                  isActive: showPositionCalculator,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive 
              ? const Color(0xFF00D632).withOpacity(0.2)
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive 
                ? const Color(0xFF00D632)
                : Colors.grey[800]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive 
                  ? const Color(0xFF00D632)
                  : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive 
                    ? const Color(0xFF00D632)
                    : Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCalculatorSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: RiskCalculator(
        currentPrice: widget.recommendation.currentPrice,
        stopLoss: widget.recommendation.stopLoss,
        takeProfit: widget.recommendation.targetPrice,
      ),
    );
  }

  Widget _buildPositionCalculatorSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: PositionSizeCalculator(
        currentPrice: widget.recommendation.currentPrice,
        stopLoss: widget.recommendation.stopLoss,
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement paper trade
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Paper Trade',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showExecuteTradeDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D632),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Execute Trade',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExecuteTradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Execute Trade',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Open a ${widget.recommendation.action} position for ${widget.recommendation.stockCode}?',
          style: TextStyle(color: Colors.grey[300]),
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
              ref.read(portfolioProvider.notifier).openPosition(
                widget.recommendation,
                100, // Default quantity
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Position opened successfully'),
                  backgroundColor: Color(0xFF00D632),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D632),
            ),
            child: const Text('Execute'),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'LOW':
        return const Color(0xFF00D632);
      case 'MEDIUM':
        return Colors.orange;
      case 'HIGH':
        return const Color(0xFFFF3B30);
      default:
        return Colors.grey;
    }
  }
}