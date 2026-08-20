import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
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

  IconData _getFallbackIcon(String name) {
    switch (name.toLowerCase()) {
      case 'crown':
        return Icons.workspace_premium_rounded;
      case 'diamond':
        return Icons.diamond_rounded;
      case 'heart':
      default:
        return Icons.favorite_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isCrown = iconName.toLowerCase() == 'crown';
    final isDiamond = iconName.toLowerCase() == 'diamond';

    final List<Color> outerBevelColors = isDiamond
        ? [const Color(0xFFCCA054), const Color(0xFF4A3716)]
        : isCrown
        ? [const Color(0xFF1B6B40), const Color(0xFF042B17)]
        : [color.primaryContainer, color.primary];

    final List<Color> innerGradientColors = isDiamond
        ? [const Color(0xFF2A2B2D), const Color(0xFF0F1011)]
        : isCrown
        ? [const Color(0xFF0B5C32), const Color(0xFF022A16)]
        : [color.primary, color.onPrimaryContainer];

    final Color iconColor = isDiamond
        ? const Color(0xFFCCA054)
        : color.onPrimary;

    return Container(
      width: Spacing.monthlyPlanPackageIconSize,
      height: Spacing.monthlyPlanPackageIconSize,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: outerBevelColors,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.22),
            blurRadius: Spacing.xs,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.2, -0.3),
            radius: 0.85,
            colors: innerGradientColors,
          ),
          border: Border.all(
            color: isDiamond
                ? const Color(0x66CCA054)
                : color.surface.withValues(alpha: 0.25),
            width: Spacing.hairline,
          ),
        ),
        child: logoUrl != null && logoUrl!.isNotEmpty
            ? AppCachedNetworkImage(
                imageUrl: logoUrl,
                width: Spacing.xxl,
                height: Spacing.xxl,
                shape: BoxShape.circle,
                fit: BoxFit.contain,
                semanticLabel: locale.nav_subscription,
                backgroundColor: color.surface.withValues(alpha: 0),
                errorWidget: Icon(
                  _getFallbackIcon(iconName),
                  size: Spacing.lg,
                  color: iconColor,
                ),
              )
            : Icon(
                _getFallbackIcon(iconName),
                size: Spacing.lg,
                color: iconColor,
              ),
      ),
    );
  }
}
