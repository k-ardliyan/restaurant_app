import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/result_state.dart';
import '../../provider/database_provider.dart';
import '../../provider/restaurant_search_provider.dart';
import '../../data/models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';

class RestaurantSearchPage extends StatefulWidget {
  static const routeName = '/restaurant_search';

  const RestaurantSearchPage({super.key});

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        Provider.of<RestaurantSearchProvider>(
          context,
          listen: false,
        ).search(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search restaurants...',
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: _onSearchChanged,
        ),
      ),
      body: Consumer2<RestaurantSearchProvider, DatabaseProvider>(
        builder: (context, provider, dbProvider, child) {
          final state = provider.state;
          if (state is ResultInitial) {
            return const Center(child: Text('Type to start searching...'));
          } else if (state is ResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultSuccess<List<Restaurant>>) {
            final restaurants = state.data;
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final isFav = dbProvider.favorites.any(
                  (fav) => fav.id == restaurant.id,
                );
                return RestaurantCard(
                  restaurant: restaurant,
                  heroTagPrefix: 'image_search',
                  isFavorited: isFav,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RestaurantDetailPage.routeName,
                      arguments: {
                        'id': restaurant.id,
                        'heroTag': 'image_search_${restaurant.id}',
                      },
                    );
                  },
                );
              },
            );
          } else if (state is ResultError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      provider.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
