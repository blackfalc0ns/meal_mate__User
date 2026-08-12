import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_nutrition_row.dart';
part 'calendar_restaurant_text_block.dart';
part 'calendar_meta_chip.dart';
part 'calendar_restaurant_summary_logo.dart';

class CalendarRestaurantSummaryCard extends StatelessWidget {
  const CalendarRestaurantSummaryCard({
    super.key,
    required this.restaurant,
    required this.meals,
    required this.onMorePressed,
  });

  final CalendarRestaurantEntity restaurant;
  final List<CalendarMealEntity> meals;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.calendarRestaurantSummaryHeight,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(
          Spacing.calendarRestaurantSummaryRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: Spacing.calendarRestaurantSummaryTopPadding,
            start: Spacing.calendarRestaurantSummaryHorizontalPadding,
            end: Spacing.calendarRestaurantSummaryHorizontalPadding,
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CalendarRestaurantTextBlock(restaurant: restaurant),
                  ),
                  const SizedBox(
                    width: Spacing.calendarRestaurantSummaryLogoGap,
                  ),
                  const CalendarRestaurantSummaryLogo(),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.calendarRestaurantSummaryDividerTop,
            start: Spacing.zero,
            end: Spacing.zero,
            child: CustomPaint(
              painter: _CalendarRestaurantSummaryDividerPainter(
                color: color.onPrimary.withValues(alpha: 0.52),
              ),
              child: const SizedBox(height: Spacing.border),
            ),
          ),
          PositionedDirectional(
            top: Spacing.calendarRestaurantSummaryNutritionTop,
            start: Spacing.lg,
            end: Spacing.lg,
            child: Column(
              children: [
                Text(
                  locale.calendar_daily_nutrition_total,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onPrimary,
                  ),
                ),
                const SizedBox(
                  height: Spacing.calendarRestaurantSummaryNutritionGap,
                ),
                CalendarRestaurantNutritionRow(meals: meals),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: Spacing.calendarRestaurantSummaryButtonBottom,
            start: Spacing.xxl,
            end: Spacing.xxl,
            child: SizedBox(
              height: Spacing.calendarRestaurantSummaryButtonHeight,
              child: FilledButton.icon(
                onPressed: onMorePressed,
                icon: Icon(
                  Icons.restaurant_rounded,
                  color: color.primary,
                  size: Spacing.iconSm,
                ),
                label: Text(locale.calendar_change_restaurant),
                style: FilledButton.styleFrom(
                  backgroundColor: color.surface,
                  foregroundColor: color.primary,
                  padding: EdgeInsets.zero,
                  textStyle: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarRestaurantSummaryDividerPainter extends CustomPainter {
  const _CalendarRestaurantSummaryDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = Spacing.border
      ..strokeCap = StrokeCap.round;
    var start = Spacing.zero;

    while (start < size.width) {
      final end = start + Spacing.calendarRestaurantSummaryDividerDashWidth;
      canvas.drawLine(
        Offset(start, Spacing.zero),
        Offset(end.clamp(Spacing.zero, size.width), Spacing.zero),
        paint,
      );
      start = end + Spacing.calendarRestaurantSummaryDividerDashGap;
    }
  }

  @override
  bool shouldRepaint(
    covariant _CalendarRestaurantSummaryDividerPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}
