import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';

/// Repeatedly pumps until [RestaurantCard] widgets appear or [maxSeconds] is
/// reached. This prevents hard failures when network latency varies.
Future<void> _waitForRestaurantList(
  WidgetTester tester, {
  int maxSeconds = 10,
}) async {
  for (var i = 0; i < maxSeconds; i++) {
    await tester.pump(const Duration(seconds: 1));
    if (tester.any(find.byType(RestaurantCard))) return;
  }
}

/// Taps a bottom navigation tab by its icon.
Future<void> _tapBottomNav(WidgetTester tester, IconData icon) async {
  final tab = find.descendant(
    of: find.byType(BottomNavigationBar),
    matching: find.byIcon(icon),
  );
  await tester.tap(tab);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('E2E 1: Restaurant list loads and shows cards', (tester) async {
      app.main();
      await _waitForRestaurantList(tester);

      expect(find.byType(RestaurantCard), findsWidgets);
      expect(find.text('Restaurant List'), findsOneWidget);
    });

    testWidgets('E2E 2: Tap on first restaurant, verify detail page', (
      tester,
    ) async {
      app.main();
      await _waitForRestaurantList(tester);

      expect(find.byType(RestaurantCard), findsWidgets);

      await tester.tap(find.byType(RestaurantCard).first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Detail page has a FAB for favorite
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
      'E2E 3: Favorite a restaurant and verify it appears in Favorites tab',
      (tester) async {
        app.main();
        await _waitForRestaurantList(tester);

        expect(find.byType(RestaurantCard), findsWidgets);

        // Open first restaurant detail
        await tester.tap(find.byType(RestaurantCard).first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Tap FAB to favorite
        final favoriteButton = find.byType(FloatingActionButton);
        expect(favoriteButton, findsOneWidget);
        await tester.tap(favoriteButton);
        await tester.pumpAndSettle();

        // Go back to list
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();

        // Navigate to Favorites tab
        await _tapBottomNav(tester, Icons.favorite);

        // Favorites page should show at least one card
        expect(find.byType(RestaurantCard), findsWidgets);

        // Cleanup: open the favorited restaurant and unfavorite it
        await tester.tap(find.byType(RestaurantCard).first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        final unfavoriteButton = find.byType(FloatingActionButton);
        expect(unfavoriteButton, findsOneWidget);
        await tester.tap(unfavoriteButton);
        await tester.pumpAndSettle();
      },
    );

    testWidgets('E2E 4: Search for a restaurant and verify results appear', (
      tester,
    ) async {
      app.main();
      await _waitForRestaurantList(tester);

      // Open search page
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Type a query (debounce is 500ms + network time)
      await tester.enterText(find.byType(TextField), 'mel');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Results should appear
      expect(find.byType(RestaurantCard), findsWidgets);
    });

    testWidgets(
      'E2E 5: Toggle dark theme in settings and verify theme changes',
      (tester) async {
        app.main();
        await _waitForRestaurantList(tester);

        // Navigate to Settings tab
        await _tapBottomNav(tester, Icons.settings);

        expect(find.text('Dark Theme'), findsOneWidget);

        // Find the Dark Theme switch
        final darkThemeSwitch = find.byWidgetPredicate(
          (widget) =>
              widget is SwitchListTile &&
              (widget.title as Text).data == 'Dark Theme',
        );

        final SwitchListTile initialTile = tester.widget<SwitchListTile>(
          darkThemeSwitch,
        );
        final bool wasEnabled = initialTile.value;

        // Toggle it
        await tester.tap(darkThemeSwitch);
        await tester.pumpAndSettle();

        final SwitchListTile updatedTile = tester.widget<SwitchListTile>(
          darkThemeSwitch,
        );
        expect(updatedTile.value, !wasEnabled);

        // Restore original state
        await tester.tap(darkThemeSwitch);
        await tester.pumpAndSettle();
      },
    );
  });
}
