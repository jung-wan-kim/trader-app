import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class PositionPage extends BasePage {
  PositionPage(WidgetTester tester) : super(tester);
  
  // Locators
  final positionList = find.byKey(const Key('position_list'));
  final openPositionsTab = find.text('진행중');
  final closedPositionsTab = find.text('종료됨');
  final totalProfitLoss = find.byKey(const Key('total_profit_loss'));
  final filterButton = find.byIcon(Icons.filter_list);
  final sortButton = find.byIcon(Icons.sort);
  
  // Position card locators
  Finder positionCard(String symbol) => find.byKey(Key('position_$symbol'));
  Finder positionSymbol(String symbol) => find.text(symbol);
  Finder positionQuantity(String symbol) => find.byKey(Key('quantity_$symbol'));
  Finder positionProfitLoss(String symbol) => find.byKey(Key('pnl_$symbol'));
  Finder positionStatus(String symbol) => find.byKey(Key('status_$symbol'));
  Finder closePositionButton(String symbol) => find.byKey(Key('close_$symbol'));
  Finder positionDetails(String symbol) => find.byKey(Key('details_$symbol'));
  
  // Actions
  Future<void> selectPosition(String symbol) async {
    await scrollUntilVisible(positionCard(symbol));
    await tap(positionCard(symbol));
  }
  
  Future<void> closePosition(String symbol) async {
    await scrollUntilVisible(closePositionButton(symbol));
    await tap(closePositionButton(symbol));
    
    // Confirm dialog
    await tap(find.text('확인'));
    await waitForPageToLoad();
  }
  
  Future<void> switchToOpenPositions() async {
    await tap(openPositionsTab);
  }
  
  Future<void> switchToClosedPositions() async {
    await tap(closedPositionsTab);
  }
  
  Future<void> openFilters() async {
    await tap(filterButton);
  }
  
  Future<void> applyFilter(String filterType, String value) async {
    await openFilters();
    await tap(find.text(filterType));
    await tap(find.text(value));
    await tap(find.text('적용'));
  }
  
  Future<void> sortPositions(String sortBy) async {
    await tap(sortButton);
    await tap(find.text(sortBy));
  }
  
  Future<void> viewPositionDetails(String symbol) async {
    await scrollUntilVisible(positionDetails(symbol));
    await tap(positionDetails(symbol));
  }
  
  Future<void> modifyStopLoss(String symbol, String newPrice) async {
    await selectPosition(symbol);
    await tap(find.text('손절가 수정'));
    await enterText(find.byKey(const Key('stop_loss_input')), newPrice);
    await tap(find.text('저장'));
  }
  
  Future<void> modifyTakeProfit(String symbol, String newPrice) async {
    await selectPosition(symbol);
    await tap(find.text('목표가 수정'));
    await enterText(find.byKey(const Key('take_profit_input')), newPrice);
    await tap(find.text('저장'));
  }
  
  // Assertions
  void verifyPositionExists(String symbol) {
    expect(positionCard(symbol), findsOneWidget);
  }
  
  void verifyPositionDoesNotExist(String symbol) {
    expect(positionCard(symbol), findsNothing);
  }
  
  void verifyPositionCount(int count) {
    final cards = find.byWidgetPredicate(
      (widget) => widget.key?.toString().contains('position_') ?? false,
    );
    expect(cards, findsNWidgets(count));
  }
  
  void verifyPositionProfit(String symbol) {
    final profitWidget = tester.widget<Text>(
      find.descendant(
        of: positionProfitLoss(symbol),
        matching: find.byType(Text),
      ),
    );
    expect(profitWidget.data!.contains('+'), true);
  }
  
  void verifyPositionLoss(String symbol) {
    final lossWidget = tester.widget<Text>(
      find.descendant(
        of: positionProfitLoss(symbol),
        matching: find.byType(Text),
      ),
    );
    expect(lossWidget.data!.contains('-'), true);
  }
  
  void verifyTotalProfit(String amount) {
    expect(
      find.descendant(
        of: totalProfitLoss,
        matching: find.text(amount),
      ),
      findsOneWidget,
    );
  }
  
  void verifyPositionQuantity(String symbol, int quantity) {
    expect(
      find.descendant(
        of: positionCard(symbol),
        matching: find.text('$quantity주'),
      ),
      findsOneWidget,
    );
  }
  
  void verifyPositionStatus(String symbol, String status) {
    expect(
      find.descendant(
        of: positionCard(symbol),
        matching: find.text(status),
      ),
      findsOneWidget,
    );
  }
  
  void verifyNoOpenPositions() {
    expect(find.text('진행중인 포지션이 없습니다'), findsOneWidget);
  }
  
  void verifyNoClosedPositions() {
    expect(find.text('종료된 포지션이 없습니다'), findsOneWidget);
  }
  
  void verifyStopLossSet(String symbol, String price) {
    expect(
      find.descendant(
        of: positionCard(symbol),
        matching: find.text('손절가: $price'),
      ),
      findsOneWidget,
    );
  }
  
  void verifyTakeProfitSet(String symbol, String price) {
    expect(
      find.descendant(
        of: positionCard(symbol),
        matching: find.text('목표가: $price'),
      ),
      findsOneWidget,
    );
  }
}