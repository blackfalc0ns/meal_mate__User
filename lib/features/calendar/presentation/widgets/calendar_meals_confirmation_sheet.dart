import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';

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
    return AppWoltModalSheet.show<void>(
      context: context,
      hasTopBarLayer: false,
      showDragHandle: true,
      child: CalendarMealsConfirmationSheet(
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

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: Spacing.xs,
        start: Spacing.base,
        end: Spacing.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Spacing.sm),
          Image.asset(
            Assets.calendarMealsConfirmedIllustration,
            height: 85,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.calendar_confirmed_sheet_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            locale.calendar_confirmed_sheet_subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.secondaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locale.calendar_confirmed_sheet_status_label,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Container(
                  width: 1,
                  height: 16,
                  color: color.outlineVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(width: Spacing.md),
                Text(
                  statusText ?? locale.calendar_status_confirmed,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.primary,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Container(
                  width: Spacing.iconSm + 4,
                  height: Spacing.iconSm + 4,
                  decoration: BoxDecoration(
                    color: color.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_rounded,
                    color: color.onPrimary,
                    size: Spacing.iconXs + 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            locale.calendar_confirmed_sheet_note,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          AppButton(
            text: locale.calendar_confirmed_sheet_back_to_calendar,
            onPressed: () {
              Navigator.of(context).pop();
              onBackToCalendar?.call();
            },
            height: Spacing.buttonSmallHeight,
            borderRadius: Spacing.buttonRadius,
            color: color.primary,
            textColor: color.onPrimary,
            fontSize: FontSize.size14,
          ),
          const SizedBox(height: Spacing.xs),
          SizedBox(
            width: double.infinity,
            height: Spacing.buttonSmallHeight,
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
                  fontSize: FontSize.size14,
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
