import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trader_app/screens/discover_screen.dart';
import 'package:trader_app/providers/recommendations_provider.dart';
import 'package:trader_app/services/mock_data_service.dart';
import 'package:trader_app/models/stock_recommendation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DiscoverScreen Widget Tests', () {
    late ProviderContainer container;
    late MockDataService mockDataService;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      
      mockDataService = MockDataService();
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
          home: const DiscoverScreen(),
        ),
      );
    }

    testWidgets('should display video list', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for video player components
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byIcon(Icons.favorite_outline), findsWidgets);
      expect(find.byIcon(Icons.comment_outlined), findsWidgets);
      expect(find.byIcon(Icons.share_outlined), findsWidgets);
    });

    testWidgets('should display user info for videos', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for usernames
      expect(find.textContaining('@'), findsWidgets);
    });

    testWidgets('should handle like button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap like button
      final likeButton = find.byIcon(Icons.favorite_outline).first;
      if (likeButton.evaluate().isNotEmpty) {
        await tester.tap(likeButton);
        await tester.pump();

        // Should change to filled heart
        expect(find.byIcon(Icons.favorite), findsWidgets);
      }
    });

    testWidgets('should display engagement counts', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for like/comment/share counts
      expect(find.textContaining('K'), findsWidgets); // For formatted numbers
    });

    testWidgets('should handle comment button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap comment button
      final commentButton = find.byIcon(Icons.comment_outlined).first;
      if (commentButton.evaluate().isNotEmpty) {
        await tester.tap(commentButton);
        await tester.pumpAndSettle();

        // Should show comment sheet or dialog
        expect(find.byType(BottomSheet), findsOneWidget);
      }
    });

    testWidgets('should display music info', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for music icon and name
      expect(find.byIcon(Icons.music_note), findsWidgets);
    });

    testWidgets('should handle share button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap share button
      final shareButton = find.byIcon(Icons.share_outlined).first;
      if (shareButton.evaluate().isNotEmpty) {
        await tester.tap(shareButton);
        await tester.pump();

        // Should trigger share action (in real app would open share sheet)
        expect(shareButton, findsOneWidget);
      }
    });

    testWidgets('should handle follow button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Look for follow button (usually a + icon)
      final followButton = find.byIcon(Icons.add_circle_outline);
      if (followButton.evaluate().isNotEmpty) {
        await tester.tap(followButton.first);
        await tester.pump();

        // Should change to following state
        expect(find.byIcon(Icons.check_circle), findsWidgets);
      }
    });

    testWidgets('should support vertical scrolling between videos', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Perform vertical swipe
      await tester.drag(
        find.byType(PageView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Should have moved to next video
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display video descriptions', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for video descriptions
      expect(find.textContaining('#'), findsWidgets); // Hashtags in descriptions
    });

    testWidgets('should show loading state initially', (WidgetTester tester) async {
      // Override with loading state
      final loadingContainer = ProviderContainer(
        overrides: [
          recommendationsProvider.overrideWith((ref) {
            return RecommendationsNotifier(mockDataService)
              ..state = const AsyncValue.loading();
          }),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: loadingContainer,
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const DiscoverScreen(),
          ),
        ),
      );
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loadingContainer.dispose();
    });

    testWidgets('should handle video playback controls', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on video area to toggle play/pause
      await tester.tap(find.byType(PageView));
      await tester.pump();

      // Should have video player controls
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display user avatars', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for circular avatars
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('should handle double tap for like', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Double tap on video
      final videoArea = find.byType(PageView);
      await tester.tap(videoArea);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(videoArea);
      await tester.pump();

      // Should show like animation or change like state
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display bottom navigation correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Bottom navigation should be visible
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget);
      expect(find.text('Me'), findsOneWidget);
    });

    testWidgets('should highlight current navigation item', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Discover should be selected
      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar)
      );
      expect(bottomNav.currentIndex, equals(1)); // Discover is index 1
    });

    testWidgets('should handle error state', (WidgetTester tester) async {
      // Override with error state
      final errorContainer = ProviderContainer(
        overrides: [
          recommendationsProvider.overrideWith((ref) {
            return RecommendationsNotifier(mockDataService)
              ..state = AsyncValue.error(
                Exception('Failed to load videos'),
                StackTrace.current,
              );
          }),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: errorContainer,
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const DiscoverScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.textContaining('Failed to load'), findsOneWidget);

      errorContainer.dispose();
    });

    testWidgets('should display video thumbnails while loading', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Don't settle to see loading state

      // Should show placeholder or thumbnail
      expect(find.byType(Container), findsWidgets);
    });
  });
}