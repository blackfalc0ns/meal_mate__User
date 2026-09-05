import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawMethodCard extends StatelessWidget {
  const InfluencerWithdrawMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.base,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary.withValues(alpha: 0.04)
              : color.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
          border: Border.all(
            color: isSelected ? color.primary : color.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: Spacing.buttonSmallHeight,
              height: Spacing.buttonSmallHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
              ),
              child: Icon(
                icon,
                color: isSelected ? color.onSurface : color.onSurfaceVariant,
                size: Spacing.iconMd,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: isSelected ? color.primary : color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Container(
              width: Spacing.iconMd,
              height: Spacing.iconMd,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color.primary : color.surface,
                border: isSelected
                    ? null
                    : Border.all(color: color.outlineVariant, width: 1.5),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: color.onPrimary,
                      size: Spacing.iconSm - Spacing.xs,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
