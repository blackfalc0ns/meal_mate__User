import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class MonthlyRestaurantClassificationsRow extends StatelessWidget {
  const MonthlyRestaurantClassificationsRow({
    super.key,
    required this.logoUrls,
  });

  final List<String?> logoUrls;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final visibleLogoUrls = logoUrls
        .where((logoUrl) => logoUrl != null && logoUrl.isNotEmpty)
        .take(3)
        .toList();

    if (visibleLogoUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: Spacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final logoUrl in visibleLogoUrls)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs / 2),
              child: Container(
                width: Spacing.lg,
                height: Spacing.lg,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.outlineVariant,
                    width: Spacing.hairline,
                  ),
                ),
                child: AppCachedNetworkImage(
                  imageUrl: logoUrl,
                  width: Spacing.lg,
                  height: Spacing.lg,
                  shape: BoxShape.circle,
                  fit: BoxFit.contain,
                  semanticLabel: locale.subscription_restaurant_categories_title,
                  errorWidget: const SizedBox.shrink(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
