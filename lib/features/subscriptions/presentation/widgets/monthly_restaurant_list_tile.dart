import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_restaurant_logo.dart';

class MonthlyRestaurantListTile extends StatelessWidget {
  const MonthlyRestaurantListTile({
    super.key,
    required this.restaurant,
    required this.index,
  });

  final MonthlyRestaurantPlanEntity restaurant;
  final int index;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return TweenAnimationBuilder<double>(
      key: ValueKey('list-${restaurant.name}'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (index.clamp(0, 6) * 45)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * -24, 0),
            child: child,
          ),
        );
      },
      child: Container(
        height: 87,
        padding: const EdgeInsets.all(Spacing.sm),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7F3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.appBorder),
        ),
        child: Row(
          children: [
            MonthlyRestaurantLogo(restaurant: restaurant, size: 52),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                  Text(
                    restaurant.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        restaurant.rating,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size9,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Text(
                        '${restaurant.meals} ${locale.subscription_details_meal_suffix}',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.ramen_dining_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    '${restaurant.meals} ${locale.subscription_details_meal_suffix}',
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size9,
                      color: AppColors.brandDeepGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
