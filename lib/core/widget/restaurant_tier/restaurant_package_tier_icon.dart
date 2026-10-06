import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class RestaurantPackageTierIcon extends StatelessWidget {
  const RestaurantPackageTierIcon({
    super.key,
    this.iconName = '',
    required this.logoUrl,
    required this.usesLightForeground,
    required this.isSelected,
  });

  final String iconName;
  final String? logoUrl;
  final bool usesLightForeground;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final fallbackColor =
        usesLightForeground ? color.surface : color.primary;

    return SizedBox(
      width: Spacing.monthlyPlanPackageIconSize,
      height: Spacing.monthlyPlanPackageIconSize,
      child: AppCachedNetworkImage(
        imageUrl: logoUrl,
        width: Spacing.monthlyPlanPackageIconSize,
        height: Spacing.monthlyPlanPackageIconSize,
        shape: BoxShape.circle,
        fit: BoxFit.contain,
        semanticLabel: locale.nav_subscription,
        errorWidget: Icon(
          Icons.workspace_premium_rounded,
          size: Spacing.monthlyPlanPackageIconSize,
          color: fallbackColor,
        ),
      ),
    );
  }
}

