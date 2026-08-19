import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_restaurant_grid_card.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_restaurant_list_tile.dart';

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
          ? _RestaurantsGrid(restaurants: restaurants)
          : _RestaurantsList(restaurants: restaurants),
    );
  }
}

class _RestaurantsGrid extends StatelessWidget {
  const _RestaurantsGrid({required this.restaurants});

  final List<MonthlyRestaurantPlanEntity> restaurants;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const ValueKey('restaurants-grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
        childAspectRatio: 0.78,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return MonthlyRestaurantGridCard(restaurant: restaurants[index]);
      },
    );
  }
}

class _RestaurantsList extends StatelessWidget {
  const _RestaurantsList({required this.restaurants});

  final List<MonthlyRestaurantPlanEntity> restaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('restaurants-list'),
      children: [
        for (int index = 0; index < restaurants.length; index++) ...[
          MonthlyRestaurantListTile(
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
