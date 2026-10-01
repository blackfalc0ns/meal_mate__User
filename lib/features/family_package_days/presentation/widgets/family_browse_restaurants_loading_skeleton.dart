import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_loading_skeleton.dart';

class FamilyBrowseRestaurantsLoadingSkeleton extends StatelessWidget {
  const FamilyBrowseRestaurantsLoadingSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SubscriptionRestaurantsLoadingSkeleton(
      itemCount: itemCount,
      crossAxisCount: 3,
      childAspectRatio: 0.76,
    );
  }
}
