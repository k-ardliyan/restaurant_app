import 'package:flutter/material.dart';
import '../../core/state/result_state.dart';
import '../../data/api/api_service.dart';
import '../../data/models/restaurant.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  ResultState<List<Restaurant>> _state = const ResultInitial();
  ResultState<List<Restaurant>> get state => _state;

  String _message = '';
  String get message => _message;

  String _query = '';
  String get query => _query;

  Future<void> search(String newQuery) async {
    _query = newQuery;
    if (_query.trim().isEmpty) {
      _state = const ResultInitial();
      notifyListeners();
      return;
    }

    _state = const ResultLoading();
    notifyListeners();

    try {
      final result = await apiService.searchRestaurants(_query);
      if (result.restaurants.isEmpty) {
        _state = const ResultError('No Data');
        _message = 'No restaurants found matching "$_query"';
      } else {
        _state = ResultSuccess(result.restaurants);
      }
    } catch (e) {
      _state = const ResultError('Check your internet connection');
      _message =
          'Failed to search data. Please check your internet connection.';
    } finally {
      notifyListeners();
    }
  }
}
