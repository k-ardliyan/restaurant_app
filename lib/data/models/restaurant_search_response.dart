import 'restaurant.dart';

class RestaurantSearchResponse {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  RestaurantSearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantSearchResponse(
        error: json['error'] ?? true,
        founded: json['founded'] ?? 0,
        restaurants: List<Restaurant>.from(
          (json['restaurants'] as List).map((x) => Restaurant.fromJson(x)),
        ),
      );
}
