import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurant_card_skeleton.dart';

class SubscriptionRestaurantsLoadingSkeleton extends StatelessWidget {
  const SubscriptionRestaurantsLoadingSkeleton({
    super.key,
    this.itemCount = 9,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.78,
  });

  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const SubscriptionRestaurantCardSkeleton();
      },
    );
  }
}
