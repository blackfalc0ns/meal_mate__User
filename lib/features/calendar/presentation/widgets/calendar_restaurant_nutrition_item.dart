import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarRestaurantNutritionItem extends StatelessWidget {
  const CalendarRestaurantNutritionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

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
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: Spacing.calendarRestaurantSummaryNutritionIconSize,
              color: iconColor,
            ),
            const SizedBox(width: Spacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurface,
                    ).copyWith(height: 1),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    value.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size18,
                      color: color.primary,
                    ).copyWith(height: 1),
                  ),
                  const SizedBox(height: Spacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: LinearProgressIndicator(
                      minHeight: Spacing
                          .calendarRestaurantSummaryNutritionProgressHeight,
                      value: _progressValue,
                      backgroundColor: color.outline.withValues(alpha: 0.35),
                      valueColor: AlwaysStoppedAnimation<Color>(color.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _progressValue => (value / 2000).clamp(0.18, 1.0);
}
