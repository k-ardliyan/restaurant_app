import 'package:flutter/foundation.dart';
import '../core/state/result_state.dart';
import '../data/models/restaurant.dart';
import '../data/db/database_helper.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  ResultState<List<Restaurant>> _state = const ResultInitial();
  ResultState<List<Restaurant>> get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      _favorites = await databaseHelper.getFavorites();
      if (_favorites.isNotEmpty) {
        _state = ResultSuccess(_favorites);
      } else {
        _state = const ResultInitial();
        _message = 'Empty Data';
      }
    } catch (e) {
      _state = ResultError('Error: $e');
      _message = 'Error: $e';
    } finally {
      notifyListeners();
    }
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultError('Error: $e');
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant != null;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ResultError('Error: $e');
      notifyListeners();
    }
  }
}
