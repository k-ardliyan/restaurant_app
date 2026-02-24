import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/core/state/result_state.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

import 'provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('RestaurantListProvider Test', () {
    late RestaurantListProvider provider;
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);

      provider = RestaurantListProvider(apiService: apiService);
    });

    test(
      'Unit Test 1: Provider initial state should be ResultLoading (due to constructor call)',
      () async {
        // Create a new provider specifically for this test to check initial loading state
        when(
          mockClient.get(Uri.parse('https://restaurant-api.dicoding.dev/list')),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100)); // Add delay
          return http.Response('{}', 200);
        });

        final newProvider = RestaurantListProvider(apiService: apiService);

        // Immediately after creation, it should be in loading state
        expect(newProvider.state, isA<ResultLoading<List<Restaurant>>>());
      },
    );

    test(
      'Unit Test 2: Provider state should be ResultSuccess when API call is successful',
      () async {
        final responseJson = '''
      {
        "error": false,
        "message": "success",
        "count": 2,
        "restaurants": [
          {
            "id": "1",
            "name": "Restaurant A",
            "description": "Desc A",
            "pictureId": "PicA",
            "city": "City A",
            "rating": 4.5
          },
          {
            "id": "2",
            "name": "Restaurant B",
            "description": "Desc B",
            "pictureId": "PicB",
            "city": "City B",
            "rating": 4.0
          }
        ]
      }
      ''';

        when(
          mockClient.get(Uri.parse('https://restaurant-api.dicoding.dev/list')),
        ).thenAnswer((_) async => http.Response(responseJson, 200));

        await provider.fetchRestaurantList();

        expect(provider.state, isA<ResultSuccess<List<Restaurant>>>());
        expect(
          (provider.state as ResultSuccess<List<Restaurant>>).data.length,
          2,
        );
      },
    );

    test(
      'Unit Test 3: Provider state should be ResultError when API network call fails',
      () async {
        when(
          mockClient.get(Uri.parse('https://restaurant-api.dicoding.dev/list')),
        ).thenThrow(Exception('Failed to load'));

        await provider.fetchRestaurantList();

        expect(provider.state, isA<ResultError<List<Restaurant>>>());
        expect(provider.message, contains('Failed to load'));
      },
    );
  });
}
