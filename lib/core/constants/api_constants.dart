class ApiConstants {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String listEndpoint = '/list';
  static String detailEndpoint(String id) => '/detail/$id';
  static String searchEndpoint(String query) => '/search?q=$query';
  static const String reviewEndpoint = '/review';
  static String largeImage(String pictureId) =>
      '$baseUrl/images/large/$pictureId';
  static String smallImage(String pictureId) =>
      '$baseUrl/images/small/$pictureId';
}
