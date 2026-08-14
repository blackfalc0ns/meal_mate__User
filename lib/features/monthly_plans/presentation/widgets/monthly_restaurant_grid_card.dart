import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_restaurant_logo.dart';

class MonthlyRestaurantGridCard extends StatelessWidget {
  const MonthlyRestaurantGridCard({super.key, required this.restaurant});

  final MonthlyRestaurantPlanEntity restaurant;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Material(
      color: color.surface.withValues(alpha: 0),
      borderRadius: BorderRadius.circular(Spacing.monthlyRestaurantCardRadius),
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.restaurantDetails,
          arguments: restaurant,
        ),
        borderRadius: BorderRadius.circular(
          Spacing.monthlyRestaurantCardRadius,
        ),
        child: Ink(
          padding: const EdgeInsetsDirectional.only(
            top: Spacing.md,
            bottom: Spacing.sm,
            start: Spacing.md,
            end: Spacing.md,
          ),
          decoration: BoxDecoration(
           
            borderRadius: BorderRadius.circular(
              Spacing.monthlyRestaurantCardRadius,
            ),
            border: Border.all(
              color: color.outlineVariant,
              width: Spacing.monthlyRestaurantCardBorderWidth,
            ),
           
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MonthlyRestaurantLogo(
                restaurant: restaurant,
                size: Spacing.iconXl,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                restaurant.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ).copyWith(height: 1.25),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                restaurant.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurfaceVariant,
                ),
              ),
              
             Spacer(),
              Container(
                height: Spacing.monthlyRestaurantCardMetaHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Text(
                  '${restaurant.bundleMeals} ${locale.subscription_details_meals_in_plan}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
