import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_restaurant_logo.dart';

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
          padding: const EdgeInsets.only(
            top: Spacing.md,
            bottom: Spacing.monthlyRestaurantCardBottomPadding,
            left: Spacing.sm,
            right: Spacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.surfaceContainerHighest,
                color.surface,
                color.surface.withValues(alpha: 0.75),
              ],
              stops: const [0, 0.38, 1],
            ),
            borderRadius: BorderRadius.circular(
              Spacing.monthlyRestaurantCardRadius,
            ),
            border: Border.all(
              color: color.outlineVariant,
              width: Spacing.monthlyRestaurantCardBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.04),
                blurRadius: Spacing.monthlyRestaurantCardShadowBlur,
                offset: const Offset(0, Spacing.xs),
              ),
            ],
          ),
          child: Column(
            children: [
              MonthlyRestaurantLogo(
                restaurant: restaurant,
                size: Spacing.monthlyRestaurantCardLogoSize,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                restaurant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
              Text(
                restaurant.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size8,
                  color: color.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${restaurant.meals} ${locale.subscription_details_meal_suffix}',
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size8,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Icon(
                    Icons.star_rounded,
                    size: FontSize.size10,
                    color: color.primary,
                  ),
                  const SizedBox(width: Spacing.monthlyRestaurantCardTinyGap),
                  Text(
                    restaurant.rating,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Container(
                height: Spacing.monthlyRestaurantCardMetaHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Text(
                  '${restaurant.meals} ${locale.subscription_details_meals_in_plan}',
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size8,
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
