import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable button with loading state, icon, and variants.
/// ─────────────────────────────────────────────────────────────
enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.iconWidget,
    this.height,
    this.borderRadius,
    this.color,
    this.gradient,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
  });

  /// Named factories for convenience.
  const AppButton.filled({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.iconWidget,
    this.height,
    this.borderRadius,
    this.color,
    this.gradient,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
  }) : variant = AppButtonVariant.filled;

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.iconWidget,
    this.height,
    this.borderRadius,
    this.color,
    this.gradient,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.iconWidget,
    this.height,
    this.borderRadius,
    this.color,
    this.gradient,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
  }) : variant = AppButtonVariant.text;
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final Widget? iconWidget;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final LinearGradient? gradient;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final effectiveColor = color ?? AppColors.primaryDark;
    final h = height ?? Spacing.buttonHeight;
    final r = borderRadius ?? Spacing.buttonRadius;

    Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: variant == AppButtonVariant.filled
                  ? (textColor ?? colors.onPrimary)
                  : effectiveColor,
            ),
          )
        : _buildContent(context, effectiveColor);

    Widget button;
    switch (variant) {
      case AppButtonVariant.filled:
        button = _GradientButtonShell(
          gradient: gradient,
          borderRadius: r,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              padding:
                  padding ?? const EdgeInsets.symmetric(horizontal: Spacing.sm),
              backgroundColor: gradient == null
                  ? effectiveColor
                  : Colors.transparent,
              foregroundColor: textColor ?? colors.onPrimary,
              minimumSize: Size(isExpanded ? double.infinity : 0, h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: child,
          ),
        );
        break;
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding:
                padding ?? const EdgeInsets.symmetric(horizontal: Spacing.sm),
            foregroundColor: textColor ?? effectiveColor,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
            side: BorderSide(color: effectiveColor),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
          ),
          child: child,
        );
        break;
    }
    return button;
  }

  Widget _buildContent(BuildContext context, Color effectiveColor) {
    final colors = Theme.of(context).colorScheme;
    final textDirection = Directionality.of(context);

    final style = getBoldStyle(
      fontSize: fontSize ?? FontSize.size16,
      fontFamily: FontConstant.alexandria,
      color: variant == AppButtonVariant.filled
          ? (textColor ?? colors.onPrimary)
          : (textColor ?? effectiveColor),
    ).copyWith(fontWeight: fontWeight);

    if (text.isEmpty && (iconWidget != null || icon != null)) {
      return iconWidget ?? Icon(icon, size: Spacing.iconMd);
    }

    if (iconWidget != null || icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: textDirection,
        children: [
          Text(
            text,
            style: style,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: Spacing.sm),
          iconWidget ?? Icon(icon, size: 24),
        ],
      );
    }
    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _GradientButtonShell extends StatelessWidget {
  const _GradientButtonShell({
    required this.child,
    required this.borderRadius,
    this.gradient,
  });

  final Widget child;
  final double borderRadius;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    if (gradient == null) {
      return child;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
