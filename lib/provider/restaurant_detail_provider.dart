import 'package:flutter/material.dart';
import '../../core/state/result_state.dart';
import '../../data/api/api_service.dart';
import '../../data/models/restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  ResultState<RestaurantDetail> _state = const ResultInitial();
  ResultState<RestaurantDetail> get state => _state;

  String _message = '';
  String get message => _message;

  // Review form state
  bool _isSubmittingReview = false;
  bool get isSubmittingReview => _isSubmittingReview;

  String? _nameError;
  String? get nameError => _nameError;

  String? _reviewError;
  String? get reviewError => _reviewError;

  set nameError(String? error) {
    _nameError = error;
    notifyListeners();
  }

  set reviewError(String? error) {
    _reviewError = error;
    notifyListeners();
  }

  void resetFormState() {
    _isSubmittingReview = false;
    _nameError = null;
    _reviewError = null;
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final result = await apiService.getRestaurantDetail(id);
      _state = ResultSuccess(result.restaurant);
    } catch (e) {
      _state = const ResultError('Check your internet connection');
      _message = 'Failed to load restaurant details. Please try again.';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> postReview(String id, String name, String review) async {
    _isSubmittingReview = true;
    notifyListeners();
    try {
      final result = await apiService.postReview(id, name, review);
      if (!result.error) {
        // If success, directly update the current state with the new list of reviews without a full refetch.
        if (_state is ResultSuccess<RestaurantDetail>) {
          final currentData = (_state as ResultSuccess<RestaurantDetail>).data;
          final updatedRestaurant = RestaurantDetail(
            id: currentData.id,
            name: currentData.name,
            description: currentData.description,
            city: currentData.city,
            address: currentData.address,
            pictureId: currentData.pictureId,
            categories: currentData.categories,
            menus: currentData.menus,
            rating: currentData.rating,
            customerReviews: result.customerReviews,
          );
          _state = ResultSuccess(updatedRestaurant);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isSubmittingReview = false;
      notifyListeners();
    }
  }
}
