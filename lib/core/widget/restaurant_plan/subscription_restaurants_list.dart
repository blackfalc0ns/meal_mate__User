import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurant_list_tile.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class SubscriptionRestaurantsList extends StatelessWidget {
  const SubscriptionRestaurantsList({
    super.key,
    required this.restaurants,
  });

  final List<MonthlyRestaurantPlanEntity> restaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('restaurants-list'),
      children: [
        for (int index = 0; index < restaurants.length; index++) ...[
          SubscriptionRestaurantListTile(
            restaurant: restaurants[index],
            index: index,
          ),
          if (index != restaurants.length - 1)
            const SizedBox(height: Spacing.sm),
        ],
      ],
    );
  }
}
