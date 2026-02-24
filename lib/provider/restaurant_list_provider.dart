import 'package:flutter/material.dart';
import '../../core/state/result_state.dart';
import '../../data/api/api_service.dart';
import '../../data/models/restaurant.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService}) {
    fetchRestaurantList();
  }

  ResultState<List<Restaurant>> _state = const ResultInitial();
  ResultState<List<Restaurant>> get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchRestaurantList() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final result = await apiService.getRestaurantList();
      if (result.restaurants.isEmpty) {
        _state = const ResultError('No Data');
        _message = 'Empty Data';
      } else {
        _state = ResultSuccess(result.restaurants);
      }
    } catch (e) {
      _state = const ResultError('Check your internet connection');
      _message = 'Failed to load data. Please check your internet connection.';
    }
    notifyListeners();
  }
}
