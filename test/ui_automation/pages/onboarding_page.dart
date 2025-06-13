import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../base/base_page.dart';

class OnboardingPage extends BasePage {
  OnboardingPage(WidgetTester tester) : super(tester);
  
  // Locators
  final pageView = find.byType(PageView);
  final nextButton = find.byKey(const Key('next_button'));
  final skipButton = find.byKey(const Key('skip_button'));
  final getStartedButton = find.byKey(const Key('get_started_button'));
  final pageIndicator = find.byKey(const Key('page_indicator'));
  
  // Page content locators
  Finder pageTitle(int pageIndex) => find.byKey(Key('onboarding_title_$pageIndex'));
  Finder pageDescription(int pageIndex) => find.byKey(Key('onboarding_description_$pageIndex'));
  Finder pageImage(int pageIndex) => find.byKey(Key('onboarding_image_$pageIndex'));
  
  // Actions
  Future<void> swipeToNextPage() async {
    await swipe(pageView, const Offset(-300, 0));
  }
  
  Future<void> swipeToPreviousPage() async {
    await swipe(pageView, const Offset(300, 0));
  }
  
  Future<void> tapNext() async {
    await tap(nextButton);
  }
  
  Future<void> tapSkip() async {
    await tap(skipButton);
  }
  
  Future<void> tapGetStarted() async {
    await tap(getStartedButton);
  }
  
  Future<void> navigateToPage(int pageIndex) async {
    int currentPage = getCurrentPageIndex();
    
    while (currentPage < pageIndex) {
      await swipeToNextPage();
      currentPage++;
    }
    
    while (currentPage > pageIndex) {
      await swipeToPreviousPage();
      currentPage--;
    }
  }
  
  Future<void> completeOnboarding() async {
    // Navigate through all pages
    while (!isVisible(getStartedButton)) {
      if (isVisible(nextButton)) {
        await tapNext();
      } else {
        await swipeToNextPage();
      }
    }
    await tapGetStarted();
  }
  
  // Helpers
  int getCurrentPageIndex() {
    // Get current page from page indicator
    final indicators = find.descendant(
      of: pageIndicator,
      matching: find.byType(Container),
    );
    
    int currentIndex = 0;
    for (int i = 0; i < indicators.evaluate().length; i++) {
      final container = tester.widget<Container>(indicators.at(i));
      if (container.decoration != null) {
        // Check if this indicator is active (usually has different color/size)
        currentIndex = i;
        break;
      }
    }
    
    return currentIndex;
  }
  
  // Assertions
  void verifyOnPage(int pageIndex) {
    expect(pageTitle(pageIndex), findsOneWidget);
  }
  
  void verifyPageContent({
    required int pageIndex,
    required String title,
    required String description,
  }) {
    expect(find.text(title), findsOneWidget);
    expect(find.text(description), findsOneWidget);
    expect(pageImage(pageIndex), findsOneWidget);
  }
  
  void verifySkipButtonVisible() {
    expect(skipButton, findsOneWidget);
  }
  
  void verifySkipButtonNotVisible() {
    expect(skipButton, findsNothing);
  }
  
  void verifyNextButtonVisible() {
    expect(nextButton, findsOneWidget);
  }
  
  void verifyGetStartedButtonVisible() {
    expect(getStartedButton, findsOneWidget);
  }
  
  void verifyTotalPages(int count) {
    final indicators = find.descendant(
      of: pageIndicator,
      matching: find.byType(Container),
    );
    expect(indicators, findsNWidgets(count));
  }
  
  void verifyCanSwipe() {
    final PageView pageView = tester.widget(this.pageView);
    expect(pageView.physics, isNot(const NeverScrollableScrollPhysics()));
  }
}