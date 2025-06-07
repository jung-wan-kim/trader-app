import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../generated/l10n/app_localizations.dart';

class InvestmentPerformanceScreen extends ConsumerWidget {
  const InvestmentPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 전체 수익률 카드
            _buildPerformanceCard(
              title: l10n?.totalPortfolioValue ?? 'Total Portfolio Value',
              value: '\$12,450.30',
              change: '+\$1,245.30',
              changePercent: '+11.14%',
              isPositive: true,
            ),
            const SizedBox(height: 16),
            
            // 수익률 차트
            _buildPerformanceChart(l10n),
            const SizedBox(height: 24),
            
            // 성과 통계
            _buildPerformanceStats(l10n),
            const SizedBox(height: 24),
            
            // 거래 히스토리
            _buildTradingHistory(l10n),
            const SizedBox(height: 24),
            
            // 월별 수익률
            _buildMonthlyReturns(l10n),
          ],
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

  Widget _buildPerformanceChart(AppLocalizations? l10n) {
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
                maxX: 30,
                minY: 0,
                maxY: 15000,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 10000),
                      const FlSpot(5, 10500),
                      const FlSpot(10, 11200),
                      const FlSpot(15, 10800),
                      const FlSpot(20, 11800),
                      const FlSpot(25, 12100),
                      const FlSpot(30, 12450),
                    ],
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

  Widget _buildPerformanceStats(AppLocalizations? l10n) {
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
              child: _buildStatCard(l10n?.winRate ?? 'Win Rate', '68.5%', const Color(0xFF00D632)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(l10n?.avgReturn ?? 'Avg. Return', '+8.2%', const Color(0xFF00D632)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(l10n?.totalTrades ?? 'Total Trades', '47', Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(l10n?.bestTrade ?? 'Best Trade', '+24.8%', const Color(0xFF00D632)),
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

  Widget _buildTradingHistory(AppLocalizations? l10n) {
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            final trades = [
              {'symbol': 'AAPL', 'action': 'SELL', 'return': '+12.3%', 'date': '2025-06-07'},
              {'symbol': 'GOOGL', 'action': 'BUY', 'return': '+8.7%', 'date': '2025-06-06'},
              {'symbol': 'MSFT', 'action': 'SELL', 'return': '+15.2%', 'date': '2025-06-05'},
              {'symbol': 'TSLA', 'action': 'BUY', 'return': '-3.1%', 'date': '2025-06-04'},
              {'symbol': 'NVDA', 'action': 'SELL', 'return': '+22.8%', 'date': '2025-06-03'},
            ];
            
            final trade = trades[index];
            final isPositive = trade['return']!.startsWith('+');
            
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
                      color: trade['action'] == 'BUY' 
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trade['action']!,
                      style: TextStyle(
                        color: trade['action'] == 'BUY' ? Colors.blue : Colors.orange,
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
                          trade['symbol']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          trade['date']!,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    trade['return']!,
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
      ],
    );
  }

  Widget _buildMonthlyReturns(AppLocalizations? l10n) {
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
                      final months = [
                        l10n?.jan ?? 'Jan',
                        l10n?.feb ?? 'Feb',
                        l10n?.mar ?? 'Mar',
                        l10n?.apr ?? 'Apr',
                        l10n?.may ?? 'May',
                        l10n?.jun ?? 'Jun'
                      ];
                      if (value.toInt() < months.length) {
                        return Text(
                          months[value.toInt()],
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
              barGroups: [
                BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8.5, color: const Color(0xFF00D632))]),
                BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12.3, color: const Color(0xFF00D632))]),
                BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: -2.1, color: Colors.red)]),
                BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15.7, color: const Color(0xFF00D632))]),
                BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 9.2, color: const Color(0xFF00D632))]),
                BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 11.4, color: const Color(0xFF00D632))]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}