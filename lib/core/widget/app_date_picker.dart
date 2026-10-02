import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

/// Reusable App Date Picker matching the design system guidelines.
class AppDatePicker {
  AppDatePicker._();

  /// Standard date format used across APIs and backend models.
  static const String apiDateFormat = 'yyyy-MM-dd';

  /// Formats a [DateTime] into standard `yyyy-MM-dd` string.
  static String formatDate(DateTime date) {
    return DateFormat(apiDateFormat).format(DateUtils.dateOnly(date));
  }

  /// Parses a date string (`yyyy-MM-dd`) into a date-only [DateTime].
  static DateTime? parseDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    try {
      return DateUtils.dateOnly(DateTime.parse(value.trim()));
    } on FormatException {
      return null;
    }
  }

  /// Shows the app-styled Date Picker dialog and returns the selected [DateTime].
  ///
  /// Safe date boundaries:
  /// - [earliestDateString] or [firstDate]: Minimum selectable date. Dates prior to this
  ///   (and prior to today) are automatically disabled.
  /// - [initialDateString] or [initialDate]: Initial selected date, clamped to be >= [firstDate].
  /// - [lastDate]: Maximum selectable date (defaults to 1 year ahead).
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? initialDateString,
    String? earliestDateString,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final color = context.colorScheme;
    final locale = context.localization;

    final today = DateUtils.dateOnly(DateTime.now());
    final minDate = earliestDateString != null
        ? parseDate(earliestDateString)
        : firstDate;
    final effectiveFirstDate = minDate ?? today;
    final safeFirstDate = effectiveFirstDate.isBefore(today)
        ? today
        : effectiveFirstDate;

    final selected = initialDateString != null
        ? parseDate(initialDateString)
        : initialDate;
    final effectiveInitial = selected ?? safeFirstDate;
    final safeInitialDate = effectiveInitial.isBefore(safeFirstDate)
        ? safeFirstDate
        : effectiveInitial;

    final safeLastDate =
        lastDate ?? DateTime(today.year + 1, today.month, today.day);

    return showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: safeFirstDate,
      lastDate: safeLastDate,
      locale: Locale(locale.localeName),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: color.copyWith(
              primary: color.primary,
              onPrimary: color.onPrimary,
              surface: color.surface,
              onSurface: color.onSurface,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: color.surface,
              headerBackgroundColor: color.primary,
              headerForegroundColor: color.onPrimary,
              headerHeadlineStyle: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size20,
                color: color.onPrimary,
              ),
              headerHelpStyle: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onPrimary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusLg),
              ),
              dayStyle: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurface,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: color.primary,
                textStyle: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size14,
                  color: color.primary,
                ),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  /// Shows the Date Picker and returns the formatted date string (`yyyy-MM-dd`),
  /// or null if dismissed or unconfirmed.
  static Future<String?> showFormatted({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? initialDateString,
    String? earliestDateString,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final picked = await show(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateString: initialDateString,
      earliestDateString: earliestDateString,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
    );

    if (picked == null) {
      return null;
    }

    return formatDate(picked);
  }
}
