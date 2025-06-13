import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class TraderSelectionPage extends BasePage {
  TraderSelectionPage(WidgetTester tester) : super(tester);
  
  // Locators
  final traderList = find.byKey(const Key('trader_list'));
  final selectedCountText = find.byKey(const Key('selected_count'));
  final continueButton = find.byKey(const Key('continue_button'));
  final searchBar = find.byKey(const Key('trader_search'));
  final filterButton = find.byIcon(Icons.filter_list);
  
  // Trader card locators
  Finder traderCard(int index) => find.byKey(Key('trader_$index'));
  Finder traderName(String name) => find.text(name);
  Finder traderPerformance(int index) => find.byKey(Key('performance_$index'));
  Finder traderFollowers(int index) => find.byKey(Key('followers_$index'));
  Finder traderCheckbox(int index) => find.byKey(Key('trader_checkbox_$index'));
  Finder traderStrategy(int index) => find.byKey(Key('strategy_$index'));
  
  // Actions
  Future<void> selectTrader(int index) async {
    await scrollUntilVisible(traderCard(index));
    await tap(traderCheckbox(index));
  }
  
  Future<void> deselectTrader(int index) async {
    await scrollUntilVisible(traderCard(index));
    await tap(traderCheckbox(index));
  }
  
  Future<void> selectTraderByName(String name) async {
    await scrollUntilVisible(traderName(name));
    final card = find.ancestor(
      of: traderName(name),
      matching: find.byType(Card),
    );
    final checkbox = find.descendant(
      of: card,
      matching: find.byType(Checkbox),
    );
    await tap(checkbox);
  }
  
  Future<void> searchTrader(String query) async {
    await tap(searchBar);
    await enterText(searchBar, query);
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
  
  Future<void> continueToNext() async {
    await tap(continueButton);
  }
  
  Future<void> viewTraderDetails(int index) async {
    await scrollUntilVisible(traderCard(index));
    await tap(find.descendant(
      of: traderCard(index),
      matching: find.byIcon(Icons.info_outline),
    ));
  }
  
  // Assertions
  void verifySelectedCount(int count) {
    expect(
      find.descendant(
        of: selectedCountText,
        matching: find.text('$count명 선택됨'),
      ),
      findsOneWidget,
    );
  }
  
  void verifyTraderSelected(int index) {
    final Checkbox checkbox = tester.widget(traderCheckbox(index));
    expect(checkbox.value, true);
  }
  
  void verifyTraderNotSelected(int index) {
    final Checkbox checkbox = tester.widget(traderCheckbox(index));
    expect(checkbox.value, false);
  }
  
  void verifyContinueButtonEnabled() {
    final button = tester.widget<ElevatedButton>(continueButton);
    expect(button.enabled, true);
  }
  
  void verifyContinueButtonDisabled() {
    final button = tester.widget<ElevatedButton>(continueButton);
    expect(button.enabled, false);
  }
  
  void verifyMinimumSelectionWarning() {
    expect(find.text('최소 1명의 트레이더를 선택해주세요'), findsOneWidget);
  }
  
  void verifyMaximumSelectionWarning() {
    expect(find.text('최대 선택 가능한 트레이더 수를 초과했습니다'), findsOneWidget);
  }
  
  void verifyTraderCount(int count) {
    final cards = find.byWidgetPredicate(
      (widget) => widget.key?.toString().contains('trader_') ?? false,
    );
    expect(cards, findsNWidgets(count));
  }
  
  void verifyFilterApplied(String filterName) {
    expect(find.text(filterName), findsOneWidget);
  }
  
  void verifyTraderPerformance(int index, String performance) {
    expect(
      find.descendant(
        of: traderCard(index),
        matching: find.text(performance),
      ),
      findsOneWidget,
    );
  }
}