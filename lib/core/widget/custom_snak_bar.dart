import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';

// ─────────────────────────────────────────────────────────────
// CustomSnackbar — backed by CherryToast.
// يظهر في الأسفل، يدخل من الأعلى، النص من اليمين، بدون زر X.
// ─────────────────────────────────────────────────────────────

enum CustomSnackbarPosition { top, bottom }

class CustomSnackbar {
  CustomSnackbar._();

  static const Duration _defaultDuration = Duration(milliseconds: 2500);
  static const double _toastWidth = 340;

  static TextStyle get _textStyle => getBoldStyle(
    color: AppColors.white,
    fontSize: FontSize.size13,
    fontFamily: FontConstant.alexandria,
  );

  static void _show({
    required BuildContext context,
    required String message,
    required Color themeColor,
    required IconData icon,
    required Duration duration,
    VoidCallback? onTap,
  }) {
    final localizedMessage = mapFailureMessage(context, message);

    CherryToast(
      animationCurve: Curves.linearToEaseOut,
      iconWidget: Icon(icon, color: AppColors.white),
      themeColor: themeColor,
      backgroundColor: themeColor,
      title: Text(
        localizedMessage,
        style: _textStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textDirection: TextDirection.rtl,
      ),
      textDirection: TextDirection.rtl,
      toastPosition: Position.top,
      animationType: AnimationType.fromRight,
      animationDuration: const Duration(milliseconds: 380),
      toastDuration: duration,
      autoDismiss: true,
      displayCloseButton: true,
      enableIconAnimation: false,
      width: _toastWidth,
      onToastClosed: onTap,
    ).show(context);
  }

  // ── public API ─────────────────────────────────────────────

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _show(
      context: context,
      message: message,
      themeColor: const Color(0xFF49C98B),
      icon: Icons.check_circle_outline_rounded,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _show(
      context: context,
      message: message,
      themeColor: const Color(0xFFC85A54),
      icon: Icons.error_outline_rounded,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _show(
      context: context,
      message: message,
      themeColor: const Color(0xFFD08A2E),
      icon: Icons.warning_amber_rounded,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    CustomSnackbarPosition position = CustomSnackbarPosition.bottom,
  }) {
    _show(
      context: context,
      message: message,
      themeColor: AppColors.primary,
      icon: Icons.info_outline_rounded,
      duration: duration,
      onTap: onTap,
    );
  }

  static void showTopBanner({
    required BuildContext context,
    required String message,
    Duration duration = _defaultDuration,
    VoidCallback? onTap,
    Color backgroundColor = AppColors.primary,
    IconData icon = Icons.notifications_active_outlined,
  }) {
    _show(
      context: context,
      message: message,
      themeColor: backgroundColor,
      icon: icon,
      duration: duration,
      onTap: onTap,
    );
  }
}
