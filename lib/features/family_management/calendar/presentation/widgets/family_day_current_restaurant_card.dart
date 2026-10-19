import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyDayCurrentRestaurantCard extends StatelessWidget {
  const FamilyDayCurrentRestaurantCard({
    super.key,
    required this.restaurantName,
    this.onChangeRestaurant,
  });

  final String restaurantName;
  final VoidCallback? onChangeRestaurant;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final name = restaurantName.isNotEmpty
        ? restaurantName
        : locale.family_day_default_restaurant_name;

    return Container(
      decoration: BoxDecoration(
        color: color.secondary,
        borderRadius: BorderRadius.circular(Spacing.familyDayMemberCardRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: Spacing.avatarMd - Spacing.xs,
            height: Spacing.avatarMd - Spacing.xs,
            decoration: BoxDecoration(
              color: color.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.restaurant_rounded,
                color: color.secondary,
                size: Spacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  locale: Locale(locale.localeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  locale.family_day_current_restaurant_subtitle,
                  locale: Locale(locale.localeName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSecondary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          OutlinedButton(
            onPressed: onChangeRestaurant,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: color.onSecondary, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusXl),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swap_horiz_rounded,
                  color: color.onSecondary,
                  size: Spacing.iconSm,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.calendar_change_restaurant,
                  locale: Locale(locale.localeName),
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
