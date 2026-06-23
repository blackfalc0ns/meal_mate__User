import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable card widget with multiple variants and consistent styling.
/// ─────────────────────────────────────────────────────────────
enum AppCardVariant { elevated, outlined, filled }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.color,
    this.borderColor,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  });

  /// Elevated card with shadow (default).
  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.color,
    this.borderColor,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  }) : variant = AppCardVariant.elevated;

  /// Outlined card with border.
  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  })  : variant = AppCardVariant.outlined,
        elevation = 0;

  /// Flat filled card without shadow or border.
  const AppCard.filled({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.clipBehavior = Clip.none,
  })  : variant = AppCardVariant.filled,
        elevation = 0,
        borderColor = null;

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? elevation;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? Spacing.cardRadius;
    final effectivePadding =
        padding ?? const EdgeInsets.all(Spacing.cardPadding);
    final effectiveColor = color ?? AppColors.card;
    final effectiveElevation = elevation ?? Spacing.cardElevation;

    Widget card = switch (variant) {
      AppCardVariant.elevated => Material(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          elevation: effectiveElevation,
          shadowColor: AppColors.shadow,
          clipBehavior: clipBehavior,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            child: Padding(
              padding: effectivePadding,
              child: child,
            ),
          ),
        ),
      AppCardVariant.outlined => Material(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          elevation: 0,
          clipBehavior: clipBehavior,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                border: Border.all(
                  color: borderColor ?? AppColors.border,
                  width: 1.0,
                ),
              ),
              padding: effectivePadding,
              child: child,
            ),
          ),
        ),
      AppCardVariant.filled => Material(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          elevation: 0,
          clipBehavior: clipBehavior,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            child: Padding(
              padding: effectivePadding,
              child: child,
            ),
          ),
        ),
    };

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    if (width != null || height != null) {
      card = SizedBox(width: width, height: height, child: card);
    }

    return card;
  }
}