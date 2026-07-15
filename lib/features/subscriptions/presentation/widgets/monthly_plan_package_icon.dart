import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanPackageIcon extends StatelessWidget {
  const MonthlyPlanPackageIcon({
    super.key,
    required this.iconName,
    required this.isFeatured,
  });

  final String iconName;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: Spacing.xxl,
      height: Spacing.xxl,
      decoration: BoxDecoration(
        color: isFeatured
            ? color.onPrimary.withValues(alpha: 0.16)
            : color.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        switch (iconName) {
          'crown' => Icons.workspace_premium_rounded,
          'star' => Icons.star_rounded,
          _ => Icons.favorite_rounded,
        },
        size: Spacing.iconMd,
        color: isFeatured ? color.onPrimary : color.onSurface,
        semanticLabel: locale.nav_subscription,
      ),
    );
  }
}
