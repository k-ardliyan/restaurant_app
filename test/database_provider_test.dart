import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/core/state/result_state.dart';

import 'database_provider_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late MockDatabaseHelper mockDatabaseHelper;

  final testRestaurant = Restaurant(
    id: 'test-id',
    name: 'Test Resto',
    description: 'A great place',
    pictureId: 'pic1',
    city: 'Jakarta',
    rating: 4.5,
  );

  group('DatabaseProvider Tests', () {
    setUp(() {
      mockDatabaseHelper = MockDatabaseHelper();
    });

    test(
      'Unit Test 8: state is ResultInitial when favorites list is empty',
      () async {
        when(mockDatabaseHelper.getFavorites()).thenAnswer((_) async => []);

        final provider = DatabaseProvider(databaseHelper: mockDatabaseHelper);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(provider.state, isA<ResultInitial<List<Restaurant>>>());
        expect(provider.favorites, isEmpty);
      },
    );

    test(
      'Unit Test 9: state is ResultSuccess when favorites list is not empty',
      () async {
        when(
          mockDatabaseHelper.getFavorites(),
        ).thenAnswer((_) async => [testRestaurant]);

        final provider = DatabaseProvider(databaseHelper: mockDatabaseHelper);
        await Future.delayed(const Duration(milliseconds: 50));

        expect(provider.state, isA<ResultSuccess<List<Restaurant>>>());
        expect(provider.favorites.length, 1);
        expect(provider.favorites.first.name, 'Test Resto');
      },
    );

    test(
      'Unit Test 10: addFavorite calls insertFavorite on databaseHelper',
      () async {
        when(
          mockDatabaseHelper.getFavorites(),
        ).thenAnswer((_) async => [testRestaurant]);
        when(
          mockDatabaseHelper.insertFavorite(testRestaurant),
        ).thenAnswer((_) async {});

        final provider = DatabaseProvider(databaseHelper: mockDatabaseHelper);
        await Future.delayed(const Duration(milliseconds: 50));

        provider.addFavorite(testRestaurant);
        await Future.delayed(const Duration(milliseconds: 50));

        verify(mockDatabaseHelper.insertFavorite(testRestaurant)).called(1);
      },
    );

    test(
      'Unit Test 11: removeFavorite calls removeFavorite on databaseHelper',
      () async {
        when(mockDatabaseHelper.getFavorites()).thenAnswer((_) async => []);
        when(
          mockDatabaseHelper.removeFavorite('test-id'),
        ).thenAnswer((_) async {});

        final provider = DatabaseProvider(databaseHelper: mockDatabaseHelper);
        await Future.delayed(const Duration(milliseconds: 50));

        provider.removeFavorite('test-id');
        await Future.delayed(const Duration(milliseconds: 50));

        verify(mockDatabaseHelper.removeFavorite('test-id')).called(1);
      },
    );

    test(
      'Unit Test 12: isFavorited returns true when restaurant exists in db',
      () async {
        when(mockDatabaseHelper.getFavorites()).thenAnswer((_) async => []);
        when(
          mockDatabaseHelper.getFavoriteById('test-id'),
        ).thenAnswer((_) async => {'id': 'test-id'});

        final provider = DatabaseProvider(databaseHelper: mockDatabaseHelper);

        final result = await provider.isFavorited('test-id');

        expect(result, true);
      },
    );

    test(
      'Unit Test 13: isFavorited returns false when restaurant does not exist in db',
      () async {
        when(mockDatabaseHelper.getFavorites()).thenAnswer((_) async => []);
        when(
          mockDatabaseHelper.getFavoriteById('unknown-id'),
        ).thenAnswer((_) async => null);

        final provider = DatabaseProvider(databaseHelper: mockDatabaseHelper);

        final result = await provider.isFavorited('unknown-id');

        expect(result, false);
      },
    );
  });
}
