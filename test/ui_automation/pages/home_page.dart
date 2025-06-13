import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class HomePage extends BasePage {
  HomePage(WidgetTester tester) : super(tester);
  
  // Locators
  final recommendationList = find.byKey(const Key('recommendation_list'));
  final filterButton = find.byIcon(Icons.filter_list);
  final sortButton = find.byIcon(Icons.sort);
  final searchBar = find.byKey(const Key('search_bar'));
  final refreshIndicator = find.byType(RefreshIndicator);
  final bottomNavBar = find.byType(BottomNavigationBar);
  
  // Recommendation card locators
  Finder recommendationCard(int index) => find.byKey(Key('recommendation_$index'));
  Finder recommendationSymbol(String symbol) => find.text(symbol);
  Finder recommendationPrice(int index) => find.byKey(Key('price_$index'));
  Finder recommendationChange(int index) => find.byKey(Key('change_$index'));
  Finder recommendationType(int index) => find.byKey(Key('type_$index'));
  Finder confidenceIndicator(int index) => find.byKey(Key('confidence_$index'));
  
  // Actions
  Future<void> selectRecommendation(int index) async {
    await scrollUntilVisible(recommendationCard(index));
    await tap(recommendationCard(index));
  }
  
  Future<void> searchStock(String query) async {
    await tap(searchBar);
    await enterText(searchBar, query);
  }
  
  Future<void> openFilters() async {
    await tap(filterButton);
  }
  
  Future<void> openSort() async {
    await tap(sortButton);
  }
  
  Future<void> pullToRefresh() async {
    await tester.drag(refreshIndicator, const Offset(0, 300));
    await tester.pumpAndSettle();
  }
  
  Future<void> scrollToBottom() async {
    await tester.scrollUntilVisible(
      find.text('더 이상 추천이 없습니다'),
      500,
      scrollable: recommendationList,
      maxScrolls: 50,
    );
  }
  
  Future<void> navigateToTab(int tabIndex) async {
    final BottomNavigationBar navBar = tester.widget(bottomNavBar);
    await tap(find.text(navBar.items[tabIndex].label!));
  }
  
  // Assertions
  void verifyRecommendationCount(int expected) {
    final cards = find.byWidgetPredicate(
      (widget) => widget.key?.toString().contains('recommendation_') ?? false,
    );
    expect(cards, findsNWidgets(expected));
  }
  
  void verifyRecommendationVisible(String symbol) {
    expect(recommendationSymbol(symbol), findsOneWidget);
  }
  
  void verifyNoRecommendations() {
    expect(find.text('추천 종목이 없습니다'), findsOneWidget);
  }
  
  void verifyLoadingState() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }
  
  void verifyErrorState(String errorMessage) {
    expect(find.text(errorMessage), findsOneWidget);
  }
  
  void verifyFilterApplied(String filterName) {
    expect(find.text(filterName), findsOneWidget);
  }
  
  void verifySortApplied(String sortOption) {
    expect(find.text(sortOption), findsOneWidget);
  }
  
  void verifyPriceDisplay(int index, String price) {
    expect(
      find.descendant(
        of: recommendationCard(index),
        matching: find.text(price),
      ),
      findsOneWidget,
    );
  }
  
  void verifyRecommendationType(int index, String type) {
    expect(
      find.descendant(
        of: recommendationCard(index),
        matching: find.text(type),
      ),
      findsOneWidget,
    );
  }
  
  void verifyConfidenceLevel(int index, double confidence) {
    final confidenceWidget = tester.widget<LinearProgressIndicator>(
      find.descendant(
        of: recommendationCard(index),
        matching: find.byType(LinearProgressIndicator),
      ),
    );
    expect(confidenceWidget.value, confidence);
  }
  
  void verifyTabSelected(int tabIndex) {
    final BottomNavigationBar navBar = tester.widget(bottomNavBar);
    expect(navBar.currentIndex, tabIndex);
  }
}