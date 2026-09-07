import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressChooseLocationModeCard extends StatelessWidget {
  const AddressChooseLocationModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final backgroundColor = isSelected
        ? color.secondaryContainer.withValues(alpha: 0.35)
        : color.surface;
    final borderColor = isSelected ? color.primary : color.outlineVariant;
    final titleColor = isSelected ? color.primary : color.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Spacing.sm),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: Spacing.xss),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.xs),
            icon,
          ],
        ),
      ),
    );
  }
}
