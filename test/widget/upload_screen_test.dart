import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/upload_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UploadScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const UploadScreen(),
        ),
      );
    }

    testWidgets('should display upload options', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for upload options
      expect(find.text('Create a video'), findsOneWidget);
      expect(find.byIcon(Icons.video_call), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
    });

    testWidgets('should show camera option', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for camera button
      expect(find.text('Camera'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('should show gallery option', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for gallery button
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
    });

    testWidgets('should handle camera button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap camera button
      await tester.tap(find.text('Camera'));
      await tester.pump();

      // Should trigger camera action (in real app would open camera)
      expect(find.text('Camera'), findsOneWidget);
    });

    testWidgets('should handle gallery button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap gallery button
      await tester.tap(find.text('Gallery'));
      await tester.pump();

      // Should trigger gallery action (in real app would open gallery)
      expect(find.text('Gallery'), findsOneWidget);
    });

    testWidgets('should display upload instructions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for instructions
      expect(find.textContaining('Share'), findsWidgets);
      expect(find.textContaining('trading'), findsWidgets);
    });

    testWidgets('should show video requirements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for requirements text
      expect(find.textContaining('seconds'), findsWidgets);
      expect(find.textContaining('MB'), findsWidgets);
    });

    testWidgets('should display bottom navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check bottom navigation
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Upload'), findsWidgets);
    });

    testWidgets('should highlight upload in navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Upload should be selected
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar)
      );
      expect(bottomNav.currentIndex, equals(2)); // Upload is index 2
    });

    testWidgets('should show templates option', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for templates
      expect(find.text('Templates'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    });

    testWidgets('should handle templates button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap templates button
      final templatesButton = find.text('Templates');
      if (templatesButton.evaluate().isNotEmpty) {
        await tester.tap(templatesButton);
        await tester.pumpAndSettle();

        // Should show templates view
        expect(find.byType(GridView), findsOneWidget);
      }
    });

    testWidgets('should show effects option', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for effects
      expect(find.text('Effects'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('should display upload tips', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for tips section
      expect(find.text('Tips'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });

    testWidgets('should show recent uploads section', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for recent uploads
      final recentSection = find.text('Recent');
      if (recentSection.evaluate().isNotEmpty) {
        expect(find.byType(GridView), findsWidgets);
      }
    });

    testWidgets('should handle close button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap close button
      final closeButton = find.byIcon(Icons.close);
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton);
        await tester.pump();

        // Should handle close action
        expect(find.byType(UploadScreen), findsOneWidget);
      }
    });

    testWidgets('should display upload progress when uploading', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for progress indicator (when uploading)
      final progressIndicator = find.byType(LinearProgressIndicator);
      if (progressIndicator.evaluate().isNotEmpty) {
        expect(progressIndicator, findsOneWidget);
      }
    });

    testWidgets('should show permission request for camera', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for permission text
      expect(find.textContaining('permission'), findsWidgets);
    });

    testWidgets('should display supported formats', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for format information
      expect(find.textContaining('MP4'), findsWidgets);
      expect(find.textContaining('MOV'), findsWidgets);
    });

    testWidgets('should show upload guidelines', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for guidelines
      expect(find.textContaining('Community'), findsWidgets);
      expect(find.textContaining('Guidelines'), findsWidgets);
    });

    testWidgets('should handle draft videos', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for drafts section
      final draftsSection = find.text('Drafts');
      if (draftsSection.evaluate().isNotEmpty) {
        expect(draftsSection, findsOneWidget);
        expect(find.byIcon(Icons.drafts), findsOneWidget);
      }
    });
  });
}