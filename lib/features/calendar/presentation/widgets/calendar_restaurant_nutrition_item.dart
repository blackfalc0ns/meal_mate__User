import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

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
    final color = context.colorScheme;
    final locale = context.localization;
    final resolvedColor = _resolveColor(color);
    final resolvedUnit = unit ?? _resolveUnit(locale);
    final resolvedTarget = target ?? _resolveTarget();
    final resolvedPercentage =
        percentage ??
        (resolvedTarget > 0 ? ((value / resolvedTarget) * 100).round() : 0);
    final progress = resolvedTarget > 0
        ? (value / resolvedTarget).clamp(0.0, 1.0)
        : (resolvedPercentage / 100).clamp(0.0, 1.0);

    return Expanded(
      child: Container(
        height: Spacing.calendarRestaurantSummaryNutritionCardHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xs,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withValues(alpha: 0.04),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onSurface,
                    ),
                  ),
                ),

                const SizedBox(width: Spacing.xss),
                if (animationAsset != null)
                  Lottie.asset(
                    animationAsset!,
                    width: 10,
                    height: 30,
                    fit: BoxFit.cover,
                    repeat: true,
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    size: Spacing.iconSm,
                    color: iconColor ?? color.primary,
                  ),
              ],
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formattedValue,
                      maxLines: 1,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.onSurface,
                      ).copyWith(height: 1),
                    ),
                    if (resolvedUnit.isNotEmpty) ...[
                      const SizedBox(width: 2),
                      Text(
                        resolvedUnit,
                        maxLines: 1,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurface,
                        ).copyWith(height: 1),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: LinearProgressIndicator(
                      minHeight: Spacing
                          .calendarRestaurantSummaryNutritionProgressHeight,
                      value: progress,
                      backgroundColor: color.outline.withValues(alpha: 0.18),
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

  String get _formattedValue {
    if (value >= 1000) {
      final str = value.toString();
      final thousands = str.substring(0, str.length - 3);
      final rest = str.substring(str.length - 3);
      return '$thousands,$rest';
    }
    return value.toString();
  }

  Color _resolveColor(ColorScheme colorScheme) {
    if (color != null) return color!;
    if (animationAsset == Assets.fireAnimation) {
      return colorScheme.calendarNutritionCalories;
    }
    if (animationAsset == Assets.dropletAnimation) {
      return colorScheme.calendarNutritionFat;
    }
    if (animationAsset == Assets.wheatAnimation) {
      return colorScheme.calendarNutritionCarbs;
    }
    if (animationAsset == Assets.muscleAnimation) {
      return colorScheme.calendarNutritionProtein;
    }
    return iconColor ?? colorScheme.primary;
  }

  String _resolveUnit(AppLocalizations locale) {
    if (animationAsset == Assets.fireAnimation) {
      return locale.search_filter_calories_unit;
    }
    return locale.search_filter_grams_unit;
  }

  int _resolveTarget() {
    if (animationAsset == Assets.fireAnimation) {
      return 2400;
    }
    if (animationAsset == Assets.dropletAnimation) {
      return 40;
    }
    if (animationAsset == Assets.wheatAnimation) {
      return 110;
    }
    if (animationAsset == Assets.muscleAnimation) {
      return 50;
    }
    return 100;
  }
}
