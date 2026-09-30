import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurant_grid_card.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class SubscriptionRestaurantsGrid extends StatelessWidget {
  const SubscriptionRestaurantsGrid({
    super.key,
    required this.restaurants,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.86,
  });

  final List<MonthlyRestaurantPlanEntity> restaurants;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const ValueKey('restaurants-grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return SubscriptionRestaurantGridCard(restaurant: restaurants[index]);
      },
    );
  }
}
