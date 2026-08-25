import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
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
    this.onMorePressed,
  });

  final CalendarRestaurantEntity restaurant;
  final List<CalendarMealEntity> meals;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.calendarRestaurantSummaryHeight,
      padding: const EdgeInsetsDirectional.only(
        top: Spacing.sm,
        start: Spacing.sm,
        end: Spacing.sm,
        bottom: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(
          Spacing.calendarRestaurantSummaryRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.20),
            blurRadius: Spacing.sm,
            offset: const Offset(Spacing.zero, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CalendarRestaurantSummaryLogo(),
              const SizedBox(width: Spacing.calendarRestaurantSummaryLogoGap),
              Expanded(
                child: CalendarRestaurantTextBlock(restaurant: restaurant),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          SizedBox(
            width: double.infinity,
            child: CustomPaint(
              painter: _CalendarRestaurantSummaryDividerPainter(
                color: color.onPrimary.withValues(alpha: 0.52),
              ),
              child: const SizedBox(height: Spacing.border),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.calendar_daily_nutrition_total,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onPrimary,
            ),
          ),
          const SizedBox(height: Spacing.calendarRestaurantSummaryNutritionGap),
          CalendarRestaurantNutritionRow(meals: meals),
          //   const Spacer(),
          SizedBox(height: Spacing.md),
          AppButton(
            text: locale.calendar_change_restaurant,
            onPressed: onMorePressed,
            height: Spacing.calendarRestaurantSummaryButtonHeight,
            borderRadius: Spacing.radiusPill,
            color: color.surface,
            textColor: color.primary,
            fontSize: FontSize.size11,
            icon: Icons.restaurant_rounded,
            padding: EdgeInsets.zero,
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
