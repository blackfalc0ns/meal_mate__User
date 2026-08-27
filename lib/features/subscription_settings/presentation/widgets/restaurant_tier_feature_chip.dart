import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';

class RestaurantTierFeatureChip extends StatelessWidget {
  const RestaurantTierFeatureChip({super.key, required this.feature});

  final RestaurantTierFeatureEntity feature;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final icon = switch (feature.icon) {
      RestaurantTierFeatureIcon.food => Icons.restaurant_rounded,
      RestaurantTierFeatureIcon.reward => Icons.emoji_events_rounded,
      RestaurantTierFeatureIcon.restaurant => Icons.add_rounded,
    };

    return Container(
      height: Spacing.restaurantTierInlineButtonHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.2),
        border: Border.all(color: color.primaryContainer),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color.primary,
            size: Spacing.iconSm,
            semanticLabel: locale.subscription_summary_restaurant_tier_label,
          ),

          Flexible(
            child: Text(
              feature.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
