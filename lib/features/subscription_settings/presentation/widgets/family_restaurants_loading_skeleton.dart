import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class FamilyRestaurantsLoadingSkeleton extends StatelessWidget {
  const FamilyRestaurantsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerCard(
      key: ValueKey('family-restaurants-loading-skeleton'),
      itemCount: 4,
    );
  }
}
