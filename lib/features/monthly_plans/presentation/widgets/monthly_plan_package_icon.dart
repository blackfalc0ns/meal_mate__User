import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanPackageIcon extends StatelessWidget {
  const MonthlyPlanPackageIcon({
    super.key,
    required this.iconName,
    required this.usesLightForeground,
  });

  final String iconName;
  final bool usesLightForeground;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.xxl,
      height: Spacing.xxl,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: usesLightForeground
              ? [color.onSurface, color.inverseSurface]
              : [color.onSurfaceVariant, color.onSurface],
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
      child: Icon(
        switch (iconName) {
          'crown' => Icons.workspace_premium_rounded,
          'star' => Icons.star_rounded,
          _ => Icons.favorite_rounded,
        },
        size: Spacing.iconMd,
        color: color.onPrimary,
        semanticLabel: locale.nav_subscription,
      ),
    );
  }
}
