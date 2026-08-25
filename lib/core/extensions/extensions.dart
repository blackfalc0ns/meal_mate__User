import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_bottom_sheet.dart';

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
