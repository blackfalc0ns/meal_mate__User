import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/family_day_date_arrow_button.dart';

class FamilyDayHeader extends StatelessWidget {
  const FamilyDayHeader({
    super.key,
    required this.dateLabel,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onDatePressed,
  });

  final String dateLabel;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onDatePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.familyDayDateHeaderHeight,
      child: Row(
        children: [
          FamilyDayDateArrowButton(
            icon: Icons.keyboard_arrow_right_rounded,
            onPressed: onNextDay,
          ),
          const Spacer(),
          InkWell(
            onTap: onDatePressed,
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateLabel,
                    locale: Locale(locale.localeName),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Icon(
                    Icons.calendar_month_rounded,
                    size: Spacing.familyDayDateIconSize,
                    color: color.primary,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          FamilyDayDateArrowButton(
            icon: Icons.keyboard_arrow_left_rounded,
            onPressed: onPreviousDay,
          ),
        ],
      ),
    );
  }
}
