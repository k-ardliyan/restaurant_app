import 'category.dart';

class Menu {
  final List<Category> foods;
  final List<Category> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    foods: List<Category>.from(
      (json['foods'] as List).map((x) => Category.fromJson(x)),
    ),
    drinks: List<Category>.from(
      (json['drinks'] as List).map((x) => Category.fromJson(x)),
    ),
  );
}
