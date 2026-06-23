import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// Responsive breakpoints and layout helpers.
/// ─────────────────────────────────────────────────────────────
class ResponsiveHelper {
  ResponsiveHelper._();

  // Breakpoints
  static const double mobile = 360;
  static const double tablet = 600;
  static const double desktop = 900;

  /// Whether the screen width is mobile-sized.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;

  /// Whether the screen width is tablet-sized.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet &&
      MediaQuery.of(context).size.width < desktop;

  /// Whether the screen width is desktop-sized.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  /// Returns value based on screen size.
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// Screen width shortcut.
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Screen height shortcut.
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Padding-safe width.
  static double widthPadding(BuildContext context) =>
      MediaQuery.of(context).size.width -
      MediaQuery.of(context).padding.left -
      MediaQuery.of(context).padding.right;

  /// Whether the device has a notch.
  static bool hasNotch(BuildContext context) =>
      MediaQuery.of(context).padding.top > 24;

  /// Bottom padding (for devices with gesture navigation).
  static double bottomPadding(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  /// Top padding (status bar height).
  static double topPadding(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  /// Scale a value based on screen width (responsive sizing).
  static double scale(BuildContext context, double value) {
    final screenWidth = width(context);
    return value * (screenWidth / mobile).clamp(0.8, 1.2);
  }
}

/// ─────────────────────────────────────────────────────────────
/// Shorthand extension on BuildContext for responsive values.
/// ─────────────────────────────────────────────────────────────
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  double get screenWidth => ResponsiveHelper.width(this);
  double get screenHeight => ResponsiveHelper.height(this);
  double get bottomPadding => ResponsiveHelper.bottomPadding(this);
  double get topPadding => ResponsiveHelper.topPadding(this);
}