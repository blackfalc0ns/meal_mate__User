import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_grid.dart';
import 'package:meal_meat_user/core/widget/restaurant_plan/subscription_restaurants_list.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class SubscriptionPlanRestaurantsSection extends StatelessWidget {
  const SubscriptionPlanRestaurantsSection({
    super.key,
    required this.mode,
    required this.restaurants,
    this.gridCrossAxisCount = 3,
    this.gridChildAspectRatio = 0.65,
  });

  final SubscriptionPlanViewMode mode;
  final List<MonthlyRestaurantPlanEntity> restaurants;
  final int gridCrossAxisCount;
  final double gridChildAspectRatio;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final isList = child.key == const ValueKey('restaurants-list');
        final offsetTween = Tween<Offset>(
          begin: Offset(isList ? -0.08 : 0.08, 0.03),
          end: Offset.zero,
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetTween.animate(animation),
            child: child,
          ),
        );
      },
      child: mode == SubscriptionPlanViewMode.grid
          ? SubscriptionRestaurantsGrid(
              restaurants: restaurants,
              crossAxisCount: gridCrossAxisCount,
              childAspectRatio: gridChildAspectRatio,
            )
          : SubscriptionRestaurantsList(restaurants: restaurants),
    );
  }
}
