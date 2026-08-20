import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilySetupHeaderBadge extends StatelessWidget {
  const FamilySetupHeaderBadge({
    super.key,
    this.title,
    this.icon,
  });

  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final displayTitle = (title != null && title!.trim().isNotEmpty)
        ? title!.trim()
        : locale.family_name;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: Spacing.xxl,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(Spacing.xss),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.10),
                blurRadius: Spacing.xs,
                offset: const Offset(0, Spacing.xs),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon ?? Icons.group_rounded,
                size: Spacing.md,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                displayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
