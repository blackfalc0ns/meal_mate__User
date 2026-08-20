import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_loading_skeleton.dart';

class MonthlyPlanRestaurantsLoadingSkeleton extends StatelessWidget {
  const MonthlyPlanRestaurantsLoadingSkeleton({
    super.key,
    this.itemCount = 9,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SubscriptionRestaurantsLoadingSkeleton(
      itemCount: itemCount,
    );
  }
}
