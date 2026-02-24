import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/result_state.dart';
import '../../provider/database_provider.dart';
import '../../provider/restaurant_list_provider.dart';
import '../../provider/preferences_provider.dart';
import '../../data/models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';
import 'restaurant_search_page.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, RestaurantSearchPage.routeName);
            },
          ),
          Consumer<PreferencesProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  provider.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  provider.enableDarkTheme(!provider.isDarkTheme);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer2<RestaurantListProvider, DatabaseProvider>(
        builder: (context, provider, dbProvider, child) {
          final state = provider.state;
          if (state is ResultLoading) {
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
                  heroTagPrefix: 'image_list',
                  isFavorited: isFav,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RestaurantDetailPage.routeName,
                      arguments: {
                        'id': restaurant.id,
                        'heroTag': 'image_list_${restaurant.id}',
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
                    const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      provider.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchRestaurantList(),
                      child: const Text('Retry'),
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
