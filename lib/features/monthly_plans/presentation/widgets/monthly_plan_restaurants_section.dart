import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_plan_restaurants_section.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanRestaurantsSection extends StatelessWidget {
  const MonthlyPlanRestaurantsSection({
    super.key,
    required this.mode,
    required this.restaurants,
  });

  final SubscriptionPlanViewMode mode;
  final List<MonthlyRestaurantPlanEntity> restaurants;

  @override
  Widget build(BuildContext context) {
    return SubscriptionPlanRestaurantsSection(
      mode: mode,
      restaurants: restaurants,
    );
  }
}
