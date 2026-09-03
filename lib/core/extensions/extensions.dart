import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_date_range_picker.dart';
import 'package:meal_meat_user/core/widget/app_bottom_sheet.dart';
import 'package:meal_meat_user/core/widget/app_custom_dialog.dart';

extension ContextExtension on BuildContext {
  /// Get height of context screen
  /// usage: context.height
  double get height => MediaQuery.of(this).size.height;

  /// Get width of context screen
  /// usage: context.width
  double get width => MediaQuery.of(this).size.width;
}

extension Localization on BuildContext {
  /// Get localization of the context
  /// usage: context.localization
  AppLocalizations get localization => AppLocalizations.of(this)!;
}

extension ThemeX on BuildContext {
  /// Full ThemeData
  ThemeData get theme => Theme.of(this);

  /// Shortcut to textTheme
  TextTheme get textTheme => theme.textTheme;

  /// Shortcut to colorScheme
  ColorScheme get colorScheme => theme.colorScheme;
}

extension NumFormattingExtension on num {
  /// Format price with up to 3 decimal places without trailing zeros
  String get formattedPrice {
    final fixed = toStringAsFixed(3);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

extension StringFormattingExtension on String? {
  /// Formats numeric string by removing trailing decimal zeroes if whole number (e.g. '14.0' -> '14').
  String get formattedNumericValue {
    if (this == null) return '';
    final trimmed = this!.trim();
    if (trimmed.isEmpty) return '';
    final parsed = num.tryParse(trimmed);
    if (parsed != null) {
      if (parsed % 1 == 0) {
        return parsed.toInt().toString();
      }
      return parsed.toString();
    }
    return trimmed;
  }

  /// Shortcut alias for formattedNumericValue
  String get formattedValue => formattedNumericValue;
}

extension BottomSheetExtension on BuildContext {
  /// Open a standardized app bottom sheet
  Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool isScrollControlled = false,
    bool useSafeArea = true,
    Color? backgroundColor,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppBottomSheet.show<T>(
      context: this,
      builder: builder,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
    );
  }
}

extension CustomDialogExtension on BuildContext {
  Future<T?> showAppCustomDialog<T>({
    required String title,
    required String confirmText,
    required String cancelText,
    required T Function() onConfirm,
    required T Function() onCancel,
    String? message,
    Widget? content,
    IconData? icon,
    Color? iconColor,
    Color? confirmTextColor,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
  }) {
    return AppCustomDialog.show<T>(
      context: this,
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      message: message,
      content: content,
      icon: icon,
      iconColor: iconColor,
      confirmTextColor: confirmTextColor,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
    );
  }
}

extension DateRangePickerExtension on BuildContext {
  Future<DateTimeRange?> showAppDateRangePicker({
    required String title,
    required String confirmText,
    required String cancelText,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
  }) {
    return AppDateRangePicker.show(
      context: this,
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      firstDate: firstDate,
      lastDate: lastDate,
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
    );
  }
}
