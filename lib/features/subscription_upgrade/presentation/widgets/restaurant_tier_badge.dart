import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class RestaurantTierBadge extends StatelessWidget {
  const RestaurantTierBadge({
    super.key,
    this.imageUrl,
    this.badgeAsset,
    this.size = Spacing.restaurantTierSmallBadgeSize,
  });

  final String? imageUrl;
  final String? badgeAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final fallbackWidget = (badgeAsset != null && badgeAsset!.isNotEmpty)
        ? Image.asset(
            badgeAsset!,
            width: size,
            height: size,
            fit: BoxFit.contain,
            semanticLabel: locale.subscription_summary_restaurant_tier_label,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.military_tech_rounded,
              color: color.primary,
              size: size,
            ),
          )
        : Icon(Icons.military_tech_rounded, color: color.primary, size: size);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return AppCachedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticLabel: locale.subscription_summary_restaurant_tier_label,
        errorWidget: fallbackWidget,
      );
    }

    return fallbackWidget;
  }
}
