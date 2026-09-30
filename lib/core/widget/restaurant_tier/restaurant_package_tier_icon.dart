import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class RestaurantPackageTierIcon extends StatelessWidget {
  const RestaurantPackageTierIcon({
    super.key,
    required this.iconName,
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
    final locale = context.localization;

    final lower = iconName.toLowerCase();
    final isDiamond = lower.contains('diamond') ||
        lower.contains('max') ||
        lower.contains('elite');
    final isCrown = !isDiamond &&
        (lower.contains('crown') ||
            lower.contains('plus') ||
            lower.contains('platinum'));

    final String assetPath = isDiamond
        ? Assets.restaurantTierMax
        : isCrown
        ? Assets.restaurantTierPlus
        : Assets.restaurantTierSelect;

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return SizedBox(
        width: Spacing.monthlyPlanPackageIconSize,
        height: Spacing.monthlyPlanPackageIconSize,
        child: ClipOval(
          child: AppCachedNetworkImage(
            imageUrl: logoUrl,
            width: Spacing.monthlyPlanPackageIconSize,
            height: Spacing.monthlyPlanPackageIconSize,
            shape: BoxShape.circle,
            fit: BoxFit.contain,
            semanticLabel: locale.nav_subscription,
            errorWidget: Image.asset(
              assetPath,
              width: Spacing.monthlyPlanPackageIconSize,
              height: Spacing.monthlyPlanPackageIconSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: Spacing.monthlyPlanPackageIconSize,
      height: Spacing.monthlyPlanPackageIconSize,
      child: Image.asset(
        assetPath,
        width: Spacing.monthlyPlanPackageIconSize,
        height: Spacing.monthlyPlanPackageIconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
