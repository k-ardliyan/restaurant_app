import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/restaurant_response.dart';
import '../models/restaurant_search_response.dart';
import '../models/restaurant_detail_response.dart';
import '../models/review_response.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  static const Duration _timeout = Duration(seconds: 15);

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await client
        .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listEndpoint}'))
        .timeout(_timeout);
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await client
        .get(
          Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.detailEndpoint(id)}',
          ),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    final response = await client
        .get(
          Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint(query)}',
          ),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<ReviewResponse> postReview(
    String id,
    String name,
    String review,
  ) async {
    final response = await client
        .post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reviewEndpoint}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'id': id, 'name': name, 'review': review}),
        )
        .timeout(_timeout);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post review');
    }
  }
}
