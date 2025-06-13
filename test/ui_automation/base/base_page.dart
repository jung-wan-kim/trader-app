import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

abstract class BasePage {
  final WidgetTester tester;
  
  BasePage(this.tester);
  
  Future<void> waitForPageToLoad() async {
    await tester.pumpAndSettle();
  }
  
  Future<void> tap(Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
  
  Future<void> enterText(Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }
  
  Future<void> scrollUntilVisible(Finder finder, {double delta = -100}) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
  }
  
  Future<void> swipe(Finder finder, Offset offset) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle();
  }
  
  Future<void> longPress(Finder finder) async {
    await tester.longPress(finder);
    await tester.pumpAndSettle();
  }
  
  bool isVisible(Finder finder) {
    try {
      tester.getRect(finder);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  void verifyTextExists(String text) {
    expect(find.text(text), findsOneWidget);
  }
  
  void verifyTextDoesNotExist(String text) {
    expect(find.text(text), findsNothing);
  }
  
  void verifyWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }
  
  void verifyWidgetDoesNotExist(Finder finder) {
    expect(finder, findsNothing);
  }
  
  Future<void> waitForWidget(Finder finder, {Duration timeout = const Duration(seconds: 5)}) async {
    final end = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    
    throw Exception('Widget not found within timeout: $finder');
  }
  
  Future<void> takeScreenshot(String name) async {
    // Implementation for screenshot capture
    // This would integrate with your CI/CD system
  }
}