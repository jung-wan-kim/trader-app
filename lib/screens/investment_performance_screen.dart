import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../generated/l10n/app_localizations.dart';
import '../providers/performance_provider.dart';
import '../services/performance_service.dart';
import 'package:intl/intl.dart';

class InvestmentPerformanceScreen extends ConsumerWidget {
  const InvestmentPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final performanceAsync = ref.watch(portfolioPerformanceProvider);
    final recentTradesAsync = ref.watch(recentTradesProvider);
    
    // Auto-refresh 활성화
    ref.watch(performanceRefreshProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          l10n?.investmentPerformance ?? 'Investment Performance',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: performanceAsync.when(
        data: (performance) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 전체 수익률 카드
              _buildPerformanceCard(
                title: l10n?.totalPortfolioValue ?? 'Total Portfolio Value',
                value: '\$${performance.totalValue.toStringAsFixed(2)}',
                change: '${performance.totalGainLoss >= 0 ? '+' : ''}\$${performance.totalGainLoss.toStringAsFixed(2)}',
                changePercent: '${performance.gainLossPercent >= 0 ? '+' : ''}${performance.gainLossPercent.toStringAsFixed(2)}%',
                isPositive: performance.totalGainLoss >= 0,
              ),
              const SizedBox(height: 16),
              
              // 수익률 차트
              _buildPerformanceChart(l10n, performance.chartData),
              const SizedBox(height: 24),
              
              // 성과 통계
              _buildPerformanceStats(l10n, performance),
              const SizedBox(height: 24),
              
              // 거래 히스토리
              _buildTradingHistory(l10n, recentTradesAsync),
              const SizedBox(height: 24),
              
              // 월별 수익률
              _buildMonthlyReturns(l10n, performance.monthlyReturns),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00D632),
          ),
        ),
        error: (error, stack) => Center(
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
                l10n?.errorLoadingData ?? 'Error loading data',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.invalidate(portfolioPerformanceProvider);
                },
                child: Text(
                  l10n?.retry ?? 'Retry',
                  style: const TextStyle(
                    color: Color(0xFF00D632),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required String value,
    required String change,
    required String changePercent,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? const Color(0xFF00D632) : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$change ($changePercent)',
                style: TextStyle(
                  color: isPositive ? const Color(0xFF00D632) : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(AppLocalizations? l10n, List<ChartDataPoint> chartData) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.portfolioPerformance30Days ?? 'Portfolio Performance (30 Days)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: chartData.length.toDouble() - 1,
                minY: chartData.isNotEmpty 
                    ? chartData.map((p) => p.value).reduce((a, b) => a < b ? a : b) * 0.95
                    : 0,
                maxY: chartData.isNotEmpty
                    ? chartData.map((p) => p.value).reduce((a, b) => a > b ? a : b) * 1.05
                    : 15000,
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.value);
                    }).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D632), Color(0xFF00A028)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF00D632).withOpacity(0.3),
                          const Color(0xFF00D632).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStats(AppLocalizations? l10n, PortfolioPerformance performance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.performanceStatistics ?? 'Performance Statistics',
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
              child: _buildStatCard(
                l10n?.winRate ?? 'Win Rate', 
                '${performance.winRate.toStringAsFixed(1)}%', 
                const Color(0xFF00D632)
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                l10n?.avgReturn ?? 'Avg. Return', 
                '${performance.avgReturn >= 0 ? '+' : ''}${performance.avgReturn.toStringAsFixed(1)}%', 
                performance.avgReturn >= 0 ? const Color(0xFF00D632) : Colors.red
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                l10n?.totalTrades ?? 'Total Trades', 
                '${performance.totalTrades}', 
                Colors.blue
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                l10n?.bestTrade ?? 'Best Trade', 
                '+${performance.bestTradeReturn.toStringAsFixed(1)}%', 
                const Color(0xFF00D632)
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingHistory(AppLocalizations? l10n, AsyncValue<List<TradeHistory>> recentTradesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.recentTrades ?? 'Recent Trades',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        recentTradesAsync.when(
          data: (trades) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trades.length,
            itemBuilder: (context, index) {
              final trade = trades[index];
              final isPositive = trade.returnPercent >= 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trade.action == 'BUY' 
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trade.action,
                      style: TextStyle(
                        color: trade.action == 'BUY' ? Colors.blue : Colors.orange,
                        fontSize: 12,
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
                          trade.symbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(trade.executedAt),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isPositive ? '+' : ''}${trade.returnPercent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isPositive ? const Color(0xFF00D632) : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00D632),
            ),
          ),
          error: (_, __) => Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n?.noRecentTrades ?? 'No recent trades',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyReturns(AppLocalizations? l10n, List<MonthlyReturn> monthlyReturns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.monthlyReturns ?? 'Monthly Returns',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 20,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < monthlyReturns.length) {
                        final month = monthlyReturns[value.toInt()].month;
                        return Text(
                          DateFormat('MMM').format(month),
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: monthlyReturns.asMap().entries.map((entry) {
                final index = entry.key;
                final returnPercent = entry.value.returnPercent;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: returnPercent,
                      color: returnPercent >= 0 ? const Color(0xFF00D632) : Colors.red,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}