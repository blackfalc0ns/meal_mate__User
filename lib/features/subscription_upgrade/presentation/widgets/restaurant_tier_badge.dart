import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class RestaurantTierBadge extends StatelessWidget {
  const RestaurantTierBadge({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AppCachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      semanticLabel: locale.subscription_summary_restaurant_tier_label,
    );
  }
}
