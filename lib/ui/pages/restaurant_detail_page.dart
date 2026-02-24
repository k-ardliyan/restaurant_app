import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/api_constants.dart';
import '../../core/state/result_state.dart';
import '../../data/models/restaurant_detail.dart';
import '../../provider/restaurant_detail_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<RestaurantDetailProvider>(
        context,
        listen: false,
      ).fetchRestaurantDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          if (state is ResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResultSuccess<RestaurantDetail>) {
            final restaurant = state.data;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      restaurant.name,
                      style: const TextStyle(
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                      ),
                    ),
                    background: Hero(
                      tag: 'image_${restaurant.id}',
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) => Scaffold(
                                backgroundColor: Colors.black,
                                appBar: AppBar(
                                  backgroundColor: Colors.transparent,
                                  iconTheme: const IconThemeData(
                                    color: Colors.white,
                                  ),
                                ),
                                body: Center(
                                  child: InteractiveViewer(
                                    child: Hero(
                                      tag: 'image_${restaurant.id}',
                                      child: CachedNetworkImage(
                                        imageUrl: ApiConstants.largeImage(
                                          restaurant.pictureId,
                                        ),
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: ApiConstants.largeImage(
                            restaurant.pictureId,
                          ),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[300]),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildBody(context, restaurant)),
              ],
            );
          } else if (state is ResultError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(provider.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          provider.fetchRestaurantDetail(widget.id),
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

  Widget _buildBody(BuildContext context, RestaurantDetail restaurant) {
    final reviews = restaurant.customerReviews.reversed.toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${restaurant.address}, ${restaurant.city}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                restaurant.rating.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Description',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            restaurant.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),
          Text(
            'Foods',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 60,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: restaurant.menus.foods.length,
            itemBuilder: (context, index) {
              return _buildMenuItem(
                restaurant.menus.foods[index],
                Icons.restaurant_menu,
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Drinks',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 60,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: restaurant.menus.drinks.length,
            itemBuilder: (context, index) {
              return _buildMenuItem(
                restaurant.menus.drinks[index],
                Icons.local_cafe,
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => _showReviewBottomSheet(context, restaurant.id),
                icon: const Icon(Icons.add_comment),
                label: const Text('Add Review'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withAlpha(50)),
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        review.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      review.review,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Category item, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withAlpha(50)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewBottomSheet(BuildContext context, String restaurantId) {
    final nameController = TextEditingController();
    final reviewController = TextEditingController();

    final provider = Provider.of<RestaurantDetailProvider>(
      context,
      listen: false,
    );
    provider.resetFormState();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Consumer<RestaurantDetailProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add a Review',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name...',
                      errorText: provider.nameError,
                    ),
                    onChanged: (_) {
                      if (provider.nameError != null) {
                        provider.setNameError(null);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      labelText: 'Review',
                      hintText: 'Share your experience...',
                      errorText: provider.reviewError,
                    ),
                    maxLines: 4,
                    onChanged: (_) {
                      if (provider.reviewError != null) {
                        provider.setReviewError(null);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: provider.isSubmittingReview
                        ? null
                        : () async {
                            final nameText = nameController.text.trim();
                            final reviewText = reviewController.text.trim();

                            provider.setNameError(
                              nameText.isEmpty ? 'Name cannot be empty' : null,
                            );
                            provider.setReviewError(
                              reviewText.isEmpty
                                  ? 'Review cannot be empty'
                                  : null,
                            );

                            if (provider.nameError != null ||
                                provider.reviewError != null) {
                              return;
                            }

                            final nav = Navigator.of(bottomSheetContext);
                            final scaffoldMessenger = ScaffoldMessenger.of(
                              this.context,
                            );

                            final success = await provider.postReview(
                              restaurantId,
                              nameText,
                              reviewText,
                            );

                            if (success) {
                              nav.pop();
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Review Added successfully!'),
                                ),
                              );
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to add review'),
                                ),
                              );
                            }
                          },
                    child: provider.isSubmittingReview
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
