import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class MonthlyPlanHeroImage extends StatelessWidget {
  const MonthlyPlanHeroImage({
    super.key,
    required this.imageAsset,
    this.imageUrl,
  });

  final String imageAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Positioned(
      left: -Spacing.monthlyPlanHeroImageLeft,
      top: -Spacing.monthlyPlanHeroImageTop,
      width: Spacing.monthlyPlanHeroImageWidth,
      height: Spacing.monthlyPlanHeroImageHeight,
      child: Semantics(
        image: true,
        label: locale.nav_subscription,
        child: ColoredBox(
          color: color.surface,
          child: imageUrl == null || imageUrl!.isEmpty
              ? Image.asset(imageAsset, fit: BoxFit.cover)
              : AppCachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  semanticLabel: locale.nav_subscription,
                  backgroundColor: color.surface,
                ),
        ),
      ),
    );
  }
}
