import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';

void main() {
  testWidgets('Widget Test 1: Verify RestaurantCard displays correct data', (
    WidgetTester tester,
  ) async {
    // A sample restaurant for testing
    final testRestaurant = Restaurant(
      id: '1',
      name: 'Test Restaurant',
      description: 'Test Describe',
      pictureId: 'pic1',
      city: 'Test City',
      rating: 5.0,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RestaurantCard(restaurant: testRestaurant, onTap: () {}),
        ),
      ),
    );

    // Verify restaurant name and city are rendered based on the mock data
    expect(find.text('Test Restaurant'), findsOneWidget);
    expect(find.text('Test City'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
  });
}
