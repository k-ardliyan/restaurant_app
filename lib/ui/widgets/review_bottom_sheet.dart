import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_detail_provider.dart';

class ReviewBottomSheet extends StatefulWidget {
  final String restaurantId;

  const ReviewBottomSheet({super.key, required this.restaurantId});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<RestaurantDetailProvider>(
          context,
          listen: false,
        ).resetFormState();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name...',
                  errorText: provider.nameError,
                ),
                onChanged: (_) {
                  if (provider.nameError != null) {
                    provider.nameError = null;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: 'Review',
                  hintText: 'Share your experience...',
                  errorText: provider.reviewError,
                ),
                maxLines: 4,
                onChanged: (_) {
                  if (provider.reviewError != null) {
                    provider.reviewError = null;
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
                        final nameText = _nameController.text.trim();
                        final reviewText = _reviewController.text.trim();

                        provider.nameError = nameText.isEmpty
                            ? 'Name cannot be empty'
                            : null;
                        provider.reviewError = reviewText.isEmpty
                            ? 'Review cannot be empty'
                            : null;

                        if (provider.nameError != null ||
                            provider.reviewError != null) {
                          return;
                        }

                        final nav = Navigator.of(context);
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        final success = await provider.postReview(
                          widget.restaurantId,
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
  }
}
