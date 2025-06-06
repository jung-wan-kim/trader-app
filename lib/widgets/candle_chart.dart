import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/candle_data.dart';
import '../theme/colors.dart';

class CandleChart extends StatefulWidget {
  final List<CandleData> candles;
  final double currentPrice;
  final double stopLoss;
  final double takeProfit;

  const CandleChart({
    super.key,
    required this.candles,
    required this.currentPrice,
    required this.stopLoss,
    required this.takeProfit,
  });

  @override
  State<CandleChart> createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  late double minPrice;
  late double maxPrice;
  
  @override
  void initState() {
    super.initState();
    _calculatePriceRange();
  }
  
  @override
  void didUpdateWidget(CandleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.candles != widget.candles) {
      _calculatePriceRange();
    }
  }
  
  void _calculatePriceRange() {
    if (widget.candles.isEmpty) {
      minPrice = 0;
      maxPrice = 100;
      return;
    }
    
    // 캔들 데이터의 최고/최저가 찾기
    double dataMin = widget.candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    double dataMax = widget.candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    
    // stopLoss와 takeProfit도 범위에 포함
    dataMin = [dataMin, widget.stopLoss].reduce((a, b) => a < b ? a : b);
    dataMax = [dataMax, widget.takeProfit].reduce((a, b) => a > b ? a : b);
    
    // 여유 공간 추가 (10%)
    final range = dataMax - dataMin;
    minPrice = dataMin - range * 0.1;
    maxPrice = dataMax + range * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Chart (60 Days)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildPriceLegend(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _legendItem('Current', widget.currentPrice, Colors.white),
          const SizedBox(width: 16),
          _legendItem('Target', widget.takeProfit, AppColors.bullish),
          const SizedBox(width: 16),
          _legendItem('Stop Loss', widget.stopLoss, AppColors.bearish),
        ],
      ),
    );
  }

  Widget _legendItem(String label, double price, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 2,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '$label: \$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    if (widget.candles.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxPrice - minPrice) / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: widget.candles.length / 4,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= widget.candles.length) return const SizedBox();
                final date = widget.candles[value.toInt()].date;
                return Text(
                  DateFormat('MM/dd').format(date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        minX: 0,
        maxX: widget.candles.length.toDouble() - 1,
        minY: minPrice,
        maxY: maxPrice,
        lineBarsData: [
          // 캔들 차트 (간단히 종가 라인으로 표현)
          LineChartBarData(
            spots: widget.candles.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.close);
            }).toList(),
            isCurved: false,
            color: Colors.white,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          // 현재가 라인
          LineChartBarData(
            spots: [
              FlSpot(0, widget.currentPrice),
              FlSpot(widget.candles.length.toDouble() - 1, widget.currentPrice),
            ],
            isCurved: false,
            color: Colors.white,
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [5, 5],
          ),
          // 목표가 라인
          LineChartBarData(
            spots: [
              FlSpot(0, widget.takeProfit),
              FlSpot(widget.candles.length.toDouble() - 1, widget.takeProfit),
            ],
            isCurved: false,
            color: AppColors.bullish,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [8, 4],
          ),
          // 손절가 라인
          LineChartBarData(
            spots: [
              FlSpot(0, widget.stopLoss),
              FlSpot(widget.candles.length.toDouble() - 1, widget.stopLoss),
            ],
            isCurved: false,
            color: AppColors.bearish,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [8, 4],
          ),
        ],
        // 터치 시 툴팁 표시
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final candle = widget.candles[barSpot.x.toInt()];
                if (barSpot.barIndex == 0) {
                  return LineTooltipItem(
                    'Date: ${DateFormat('MM/dd').format(candle.date)}\n'
                    'O: \$${candle.open.toStringAsFixed(2)}\n'
                    'H: \$${candle.high.toStringAsFixed(2)}\n'
                    'L: \$${candle.low.toStringAsFixed(2)}\n'
                    'C: \$${candle.close.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}