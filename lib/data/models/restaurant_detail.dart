class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Menus menus;
  final double rating;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        city: json['city'] ?? '',
        address: json['address'] ?? '',
        pictureId: json['pictureId'] ?? '',
        categories: List<Category>.from(
          (json['categories'] as List).map((x) => Category.fromJson(x)),
        ),
        menus: Menus.fromJson(json['menus']),
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        customerReviews: List<CustomerReview>.from(
          (json['customerReviews'] as List).map(
            (x) => CustomerReview.fromJson(x),
          ),
        ),
      );
}

class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'name': name};
}

class Menus {
  final List<Category> foods;
  final List<Category> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Category>.from(
      (json['foods'] as List).map((x) => Category.fromJson(x)),
    ),
    drinks: List<Category>.from(
      (json['drinks'] as List).map((x) => Category.fromJson(x)),
    ),
  );
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json['name'] ?? '',
    review: json['review'] ?? '',
    date: json['date'] ?? '',
  );
}

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResponse(
        error: json['error'] ?? true,
        message: json['message'] ?? '',
        restaurant: RestaurantDetail.fromJson(json['restaurant']),
      );
}

class ReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  ReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
    error: json['error'] ?? true,
    message: json['message'] ?? '',
    customerReviews: List<CustomerReview>.from(
      (json['customerReviews'] as List).map((x) => CustomerReview.fromJson(x)),
    ),
  );
}
