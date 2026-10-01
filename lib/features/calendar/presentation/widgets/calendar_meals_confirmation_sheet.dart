import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class CalendarMealsConfirmationSheet extends StatelessWidget {
  const CalendarMealsConfirmationSheet({
    super.key,
    this.onBackToCalendar,
    this.onViewMeals,
    this.statusText,
  });

  final VoidCallback? onBackToCalendar;
  final VoidCallback? onViewMeals;
  final String? statusText;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onBackToCalendar,
    VoidCallback? onViewMeals,
    String? statusText,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CalendarMealsConfirmationSheet(
        onBackToCalendar: onBackToCalendar,
        onViewMeals: onViewMeals,
        statusText: statusText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      padding: const EdgeInsetsDirectional.only(
        top: Spacing.md,
        start: Spacing.xl,
        end: Spacing.xl,
        bottom: Spacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: color.outlineVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          Image.asset(
            Assets.calendarMealsConfirmedIllustration,
            height: 140,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            locale.calendar_confirmed_sheet_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size20,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.calendar_confirmed_sheet_subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: color.secondaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
              border: Border.all(
                color: color.secondaryContainer,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  locale.calendar_confirmed_sheet_status_label,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Container(
                  width: 1,
                  height: 16,
                  color: color.outlineVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(width: Spacing.sm),
                Icon(
                  Icons.check_circle_rounded,
                  color: color.primary,
                  size: Spacing.iconSm + 2,
                ),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Text(
                    statusText ?? locale.calendar_status_awaiting_restaurant,
                    textAlign: TextAlign.start,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.calendar_confirmed_sheet_note,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.xl),
          AppButton(
            text: locale.calendar_confirmed_sheet_back_to_calendar,
            onPressed: () {
              Navigator.of(context).pop();
              onBackToCalendar?.call();
            },
            height: Spacing.buttonHeight,
            borderRadius: Spacing.buttonRadius,
            color: color.primary,
            textColor: color.onPrimary,
            fontSize: FontSize.size16,
          ),
          const SizedBox(height: Spacing.sm),
          SizedBox(
            width: double.infinity,
            height: Spacing.buttonHeight,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onViewMeals?.call();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                ),
              ),
              child: Text(
                locale.calendar_confirmed_sheet_view_meals,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
