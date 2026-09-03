import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarFrozenDayState extends StatelessWidget {
  const CalendarFrozenDayState({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.avatarLg,
            height: Spacing.avatarLg,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.ac_unit_rounded,
              size: Spacing.iconLg,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            locale.calendar_day_frozen_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size22,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.calendar_day_frozen_description,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurfaceVariant,
            ).copyWith(height: 1.5),
          ),
          const SizedBox(height: Spacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.surfaceContainerLow,
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.5),
                width: Spacing.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: Spacing.iconSm,
                  color: color.error,
                ),
                const SizedBox(width: Spacing.xs),
                Flexible(
                  child: Text(
                    locale.calendar_selection_locked,
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
