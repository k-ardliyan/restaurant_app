import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets(
      'Tap on first restaurant, favorite it, verify in favorites page',
      (tester) async {
        app.main();
        // Wait for app to finish loading main network request
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Wait for the ListView to render
        final Finder firstRestaurant = find.byType(Card).first;
        expect(firstRestaurant, findsWidgets);

        // Tap on first restaurant card
        await tester.tap(firstRestaurant);
        await tester.pumpAndSettle();

        // Verify we are on details page by finding the Favorite FAB
        final Finder favoriteButton = find.byType(FloatingActionButton);
        expect(favoriteButton, findsOneWidget);

        // Tap to favorite
        await tester.tap(favoriteButton);
        await tester.pumpAndSettle();

        // Navigate back to the home page
        final Finder backButton = find.byTooltip(
          'Back',
        ); // Default tooltip for AppBar back button
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Navigate to Favorites tab
        final Finder favoriteTab = find.byIcon(Icons.favorite);
        await tester.tap(favoriteTab);
        await tester.pumpAndSettle();

        // Verify favorite restaurant appears as a card in the favorites page
        expect(find.byType(Card), findsWidgets);

        // Cleanup: Unfavorite for subsequent tests
        final Finder favoritedRestaurant = find.byType(Card).first;
        await tester.tap(favoritedRestaurant);
        await tester.pumpAndSettle();

        final Finder unfavoriteButton = find.byType(FloatingActionButton);
        await tester.tap(unfavoriteButton);
        await tester.pumpAndSettle();
      },
    );
  });
}
