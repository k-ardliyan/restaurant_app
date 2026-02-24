import 'restaurant.dart';

class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'] ?? true,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      restaurants: List<Restaurant>.from(
        (json['restaurants'] as List).map((x) => Restaurant.fromJson(x)),
      ),
    );
  }
}
