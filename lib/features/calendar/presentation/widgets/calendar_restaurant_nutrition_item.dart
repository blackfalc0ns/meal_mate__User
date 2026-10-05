import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarRestaurantNutritionItem extends StatelessWidget {
  const CalendarRestaurantNutritionItem({
    super.key,
    this.icon,
    this.animationAsset,
    required this.label,
    required this.value,
    this.unit,
    this.target,
    this.percentage,
    this.color,
    this.iconColor,
  });

  final IconData? icon;
  final String? animationAsset;
  final String label;
  final int value;
  final String? unit;
  final int? target;
  final int? percentage;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final themeColor = context.colorScheme;
    final locale = context.localization;
    final resolvedColor = color ?? iconColor ?? themeColor.primary;
    final resolvedUnit = unit ?? locale.search_filter_grams_unit;
    final resolvedPercentage =
        percentage ??
        ((target != null && target! > 0)
            ? ((value / target!) * 100).round()
            : 0);
    final progress = (target != null && target! > 0)
        ? (value / target!).clamp(0.0, 1.0)
        : (resolvedPercentage / 100).clamp(0.0, 1.0);

    return Expanded(
      child: Container(
        height: Spacing.calendarRestaurantSummaryNutritionCardHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xs,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: themeColor.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(
            color: themeColor.outlineVariant.withValues(alpha: 0.35),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.shadow.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: themeColor.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.xss),
                if (animationAsset != null)
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      resolvedColor,
                      BlendMode.srcIn,
                    ),
                    child: Lottie.asset(
                      animationAsset!,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, size: 18, color: resolvedColor),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatValue(value),
                    maxLines: 1,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size18,
                      color: themeColor.onSurface,
                    ).copyWith(height: 1),
                  ),
                  if (resolvedUnit.isNotEmpty) ...[
                    const SizedBox(width: 3),
                    Text(
                      resolvedUnit,
                      maxLines: 1,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: themeColor.onSurface,
                      ).copyWith(height: 1),
                    ),
                  ],
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      value: progress,
                      backgroundColor: themeColor.outline.withValues(
                        alpha: 0.12,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(resolvedColor),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  '%$resolvedPercentage',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: resolvedColor,
                  ).copyWith(height: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(int val) {
    if (val >= 1000) {
      final str = val.toString();
      final thousands = str.substring(0, str.length - 3);
      final rest = str.substring(str.length - 3);
      return '$thousands,$rest';
    }
    return val.toString();
  }
}
