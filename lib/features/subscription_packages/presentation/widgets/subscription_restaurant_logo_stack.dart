import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class SubscriptionRestaurantLogoStack extends StatelessWidget {
  const SubscriptionRestaurantLogoStack({super.key, required this.logoUrls});

  final List<String?> logoUrls;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final visibleLogoUrls = logoUrls.take(3).toList();

    return SizedBox(
      width: Spacing.xxxl * 2.15,
      height: Spacing.lg + Spacing.xs,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final entry in visibleLogoUrls.indexed)
            PositionedDirectional(
              start: entry.$1 * Spacing.md,
              child: Container(
                width: Spacing.lg + Spacing.xs,
                height: Spacing.lg + Spacing.xs,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: color.surface, width: Spacing.xs),
                ),
                child: AppCachedNetworkImage(
                  imageUrl: entry.$2,
                  shape: BoxShape.circle,
                  semanticLabel: locale.nav_subscription,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
