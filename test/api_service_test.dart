import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant_response.dart';
import 'package:restaurant_app/data/models/restaurant_detail_response.dart';
import 'package:restaurant_app/data/models/restaurant_search_response.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ApiService apiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });

  const baseUrl = 'https://restaurant-api.dicoding.dev';

  group('ApiService Tests', () {
    test(
      'Unit Test 4: getRestaurantList returns RestaurantListResponse on success',
      () async {
        const responseJson = '''
        {
          "error": false,
          "message": "success",
          "count": 1,
          "restaurants": [
            {
              "id": "abc",
              "name": "Test Restaurant",
              "description": "Desc",
              "pictureId": "pic1",
              "city": "Bandung",
              "rating": 4.5
            }
          ]
        }
        ''';

        when(
          mockClient.get(Uri.parse('$baseUrl/list')),
        ).thenAnswer((_) async => http.Response(responseJson, 200));

        final result = await apiService.getRestaurantList();

        expect(result, isA<RestaurantListResponse>());
        expect(result.error, false);
        expect(result.restaurants.length, 1);
        expect(result.restaurants.first.name, 'Test Restaurant');
      },
    );

    test(
      'Unit Test 5: getRestaurantList throws Exception on HTTP error',
      () async {
        when(
          mockClient.get(Uri.parse('$baseUrl/list')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() => apiService.getRestaurantList(), throwsException);
      },
    );

    test(
      'Unit Test 6: getRestaurantDetail returns RestaurantDetailResponse on success',
      () async {
        const id = 'rqdv5juczeskfw1e867';
        final responseJson =
            '''
        {
          "error": false,
          "message": "success",
          "restaurant": {
            "id": "$id",
            "name": "Melting Pot",
            "description": "Lorem ipsum",
            "city": "Medan",
            "address": "Jl. Pandeglang no 19",
            "pictureId": "14",
            "categories": [],
            "menus": { "foods": [], "drinks": [] },
            "rating": 4.2,
            "customerReviews": []
          }
        }
        ''';

        when(
          mockClient.get(Uri.parse('$baseUrl/detail/$id')),
        ).thenAnswer((_) async => http.Response(responseJson, 200));

        final result = await apiService.getRestaurantDetail(id);

        expect(result, isA<RestaurantDetailResponse>());
        expect(result.restaurant.id, id);
        expect(result.restaurant.name, 'Melting Pot');
      },
    );

    test(
      'Unit Test 7: searchRestaurants returns matching results on success',
      () async {
        const query = 'Koki';
        final responseJson = '''
        {
          "error": false,
          "founded": 1,
          "restaurants": [
            {
              "id": "s1knt6za9kkfw1e867",
              "name": "Kafe Koki",
              "description": "Good food",
              "pictureId": "25",
              "city": "Gorontalo",
              "rating": 4.0
            }
          ]
        }
        ''';

        when(
          mockClient.get(Uri.parse('$baseUrl/search?q=$query')),
        ).thenAnswer((_) async => http.Response(responseJson, 200));

        final result = await apiService.searchRestaurants(query);

        expect(result, isA<RestaurantSearchResponse>());
        expect(result.restaurants.length, 1);
        expect(result.restaurants.first.city, 'Gorontalo');
      },
    );
  });
}
