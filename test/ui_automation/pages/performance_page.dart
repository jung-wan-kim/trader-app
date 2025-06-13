import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class PerformancePage extends BasePage {
  PerformancePage(WidgetTester tester) : super(tester);
  
  // Locators
  final performanceChart = find.byKey(const Key('performance_chart'));
  final totalReturnCard = find.byKey(const Key('total_return_card'));
  final winRateCard = find.byKey(const Key('win_rate_card'));
  final averageReturnCard = find.byKey(const Key('average_return_card'));
  final bestTradeCard = find.byKey(const Key('best_trade_card'));
  final periodSelector = find.byKey(const Key('period_selector'));
  final exportButton = find.byIcon(Icons.download);
  
  // Chart period locators
  final dayButton = find.text('1일');
  final weekButton = find.text('1주');
  final monthButton = find.text('1개월');
  final month3Button = find.text('3개월');
  final month6Button = find.text('6개월');
  final yearButton = find.text('1년');
  final allButton = find.text('전체');
  
  // Statistics locators
  final totalTrades = find.byKey(const Key('total_trades'));
  final winningTrades = find.byKey(const Key('winning_trades'));
  final losingTrades = find.byKey(const Key('losing_trades'));
  final largestWin = find.byKey(const Key('largest_win'));
  final largestLoss = find.byKey(const Key('largest_loss'));
  final sharpeRatio = find.byKey(const Key('sharpe_ratio'));
  
  // Actions
  Future<void> selectPeriod(String period) async {
    switch (period) {
      case '1일':
        await tap(dayButton);
        break;
      case '1주':
        await tap(weekButton);
        break;
      case '1개월':
        await tap(monthButton);
        break;
      case '3개월':
        await tap(month3Button);
        break;
      case '6개월':
        await tap(month6Button);
        break;
      case '1년':
        await tap(yearButton);
        break;
      case '전체':
        await tap(allButton);
        break;
    }
    await waitForPageToLoad();
  }
  
  Future<void> exportReport() async {
    await tap(exportButton);
    await tap(find.text('PDF로 내보내기'));
  }
  
  Future<void> viewTradeHistory() async {
    await scrollUntilVisible(find.text('거래 내역'));
    await tap(find.text('거래 내역'));
  }
  
  Future<void> viewTraderPerformance() async {
    await scrollUntilVisible(find.text('트레이더별 성과'));
    await tap(find.text('트레이더별 성과'));
  }
  
  Future<void> viewMonthlyBreakdown() async {
    await scrollUntilVisible(find.text('월별 분석'));
    await tap(find.text('월별 분석'));
  }
  
  Future<void> compareWithBenchmark() async {
    await tap(find.text('벤치마크 비교'));
    await tap(find.text('KOSPI'));
  }
  
  // Assertions
  void verifyTotalReturn(String returnValue) {
    expect(
      find.descendant(
        of: totalReturnCard,
        matching: find.text(returnValue),
      ),
      findsOneWidget,
    );
  }
  
  void verifyPositiveReturn() {
    final returnText = tester.widget<Text>(
      find.descendant(
        of: totalReturnCard,
        matching: find.byType(Text).last,
      ),
    );
    expect(returnText.data!.contains('+'), true);
  }
  
  void verifyNegativeReturn() {
    final returnText = tester.widget<Text>(
      find.descendant(
        of: totalReturnCard,
        matching: find.byType(Text).last,
      ),
    );
    expect(returnText.data!.contains('-'), true);
  }
  
  void verifyWinRate(String rate) {
    expect(
      find.descendant(
        of: winRateCard,
        matching: find.text(rate),
      ),
      findsOneWidget,
    );
  }
  
  void verifyAverageReturn(String avgReturn) {
    expect(
      find.descendant(
        of: averageReturnCard,
        matching: find.text(avgReturn),
      ),
      findsOneWidget,
    );
  }
  
  void verifyBestTrade(String symbol, String profit) {
    expect(
      find.descendant(
        of: bestTradeCard,
        matching: find.text(symbol),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: bestTradeCard,
        matching: find.text(profit),
      ),
      findsOneWidget,
    );
  }
  
  void verifyTotalTradeCount(int count) {
    expect(
      find.descendant(
        of: totalTrades,
        matching: find.text('$count'),
      ),
      findsOneWidget,
    );
  }
  
  void verifyChartDisplayed() {
    expect(performanceChart, findsOneWidget);
  }
  
  void verifyPeriodSelected(String period) {
    final button = find.text(period);
    final container = tester.widget<Container>(
      find.ancestor(of: button, matching: find.byType(Container)).first,
    );
    expect(container.decoration, isNotNull);
  }
  
  void verifySharpeRatio(String ratio) {
    expect(
      find.descendant(
        of: sharpeRatio,
        matching: find.text(ratio),
      ),
      findsOneWidget,
    );
  }
  
  void verifyNoDataForPeriod() {
    expect(find.text('선택한 기간에 거래 내역이 없습니다'), findsOneWidget);
  }
  
  void verifyExportSuccess() {
    expect(find.text('리포트가 다운로드되었습니다'), findsOneWidget);
  }
}