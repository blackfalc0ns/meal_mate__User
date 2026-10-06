import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_badge.dart';

class RestaurantTierPreview extends StatelessWidget {
  const RestaurantTierPreview({
    super.key,
    required this.name,
    required this.badgeAsset,
    this.imageUrl,
  });

  final String name;
  final String badgeAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RestaurantTierBadge(
          imageUrl: imageUrl,
          badgeAsset: badgeAsset,
          size: Spacing.restaurantTierSmallBadgeSize,
        ),
        const SizedBox(width: Spacing.xs),
        Flexible(
          child: Semantics(
            label: locale.subscription_summary_restaurant_tier_label,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size16,
                color: color.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
