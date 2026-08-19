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

    final isPremium = iconName == 'crown' || iconName == 'diamond';
    final backgroundColors = isSelected && !usesLightForeground
        ? [color.primaryContainer, color.primary]
        : usesLightForeground
        ? [color.onSurface, color.inverseSurface]
        : isPremium
        ? [color.onSurfaceVariant, color.onSurface]
        : [color.primaryContainer, color.primary];

    return Container(
      width: Spacing.xxl,
      height: Spacing.xxl,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: backgroundColors,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.18),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.hairline),
          ),
        ],
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
                size: Spacing.iconSm,
                color: usesLightForeground ? color.primary : color.onPrimary,
              ),
            )
          : Icon(
              _getFallbackIcon(iconName),
              size: Spacing.iconSm,
              color: usesLightForeground ? color.primary : color.onPrimary,
            ),
    );
  }
}
