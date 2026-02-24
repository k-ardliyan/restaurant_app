import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/database_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';
import '../../core/state/result_state.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state is ResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultSuccess) {
            final favorites = provider.favorites;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  heroTagPrefix: 'image_fav',
                  isFavorited: true,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RestaurantDetailPage.routeName,
                      arguments: {
                        'id': restaurant.id,
                        'heroTag': 'image_fav_${restaurant.id}',
                      },
                    );
                  },
                );
              },
            );
          } else if (state is ResultError) {
            return Center(child: Text(provider.message));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
