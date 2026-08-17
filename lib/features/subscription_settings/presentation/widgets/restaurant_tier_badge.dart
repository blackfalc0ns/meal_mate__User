import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class RestaurantTierBadge extends StatelessWidget {
  const RestaurantTierBadge({
    super.key,
    required this.imageAsset,
    this.size = Spacing.restaurantTierBadgeSize,
  });

  final String imageAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Image.asset(
      imageAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: locale.subscription_summary_restaurant_tier_label,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.verified_rounded, color: color.primary, size: size);
      },
    );
  }
}
