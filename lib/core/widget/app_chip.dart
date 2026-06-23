import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable chip/tag widget for categories, filters, badges.
/// ─────────────────────────────────────────────────────────────
enum AppChipVariant { filled, outlined, light }

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.variant = AppChipVariant.light,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.icon,
    this.avatar,
    this.color,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.isSmall = false,
  });

  final String label;
  final AppChipVariant variant;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final IconData? icon;
  final Widget? avatar;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveRadius = borderRadius ?? (isSmall ? 16.0 : 20.0);
    final effectiveFontSize = fontSize ?? (isSmall ? FontSize.size11 : FontSize.size13);
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: isSmall ? Spacing.sm : Spacing.md,
          vertical: isSmall ? 4.0 : 6.0,
        );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: _backgroundColor(effectiveColor),
          borderRadius: BorderRadius.circular(effectiveRadius),
          border: Border.all(
            color: _borderColor(effectiveColor),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[
              avatar!,
              const SizedBox(width: 4),
            ],
            if (icon != null && avatar == null) ...[
              Icon(
                icon,
                size: isSmall ? 12 : 14,
                color: _textColor(effectiveColor),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: getMediumStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: effectiveFontSize,
                color: _textColor(effectiveColor),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  Icons.close,
                  size: isSmall ? 12 : 14,
                  color: _textColor(effectiveColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _backgroundColor(Color effectiveColor) {
    return switch (variant) {
      AppChipVariant.filled => selected ? effectiveColor : AppColors.disabled,
      AppChipVariant.outlined => Colors.transparent,
      AppChipVariant.light => effectiveColor.withValues(alpha: 0.1),
    };
  }

  Color _borderColor(Color effectiveColor) {
    return switch (variant) {
      AppChipVariant.filled => selected ? effectiveColor : AppColors.disabled,
      AppChipVariant.outlined => selected ? effectiveColor : AppColors.border,
      AppChipVariant.light => selected ? effectiveColor.withValues(alpha: 0.3) : Colors.transparent,
    };
  }

  Color _textColor(Color effectiveColor) {
    return switch (variant) {
      AppChipVariant.filled => selected ? AppColors.white : AppColors.textHint,
      AppChipVariant.outlined => selected ? effectiveColor : AppColors.textSecondary,
      AppChipVariant.light => selected ? effectiveColor : AppColors.textSecondary,
    };
  }
}