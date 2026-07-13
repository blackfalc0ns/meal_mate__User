import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
part 'calendar_restaurant_text_block.dart';
part 'calendar_meta_chip.dart';
part 'calendar_restaurant_summary_logo.dart';

class CalendarRestaurantSummaryCard extends StatelessWidget {
  const CalendarRestaurantSummaryCard({
    super.key,
    required this.restaurant,
    required this.onMorePressed,
  });

  final CalendarRestaurantEntity restaurant;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(10),
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
          Positioned.fill(
            top: 15,
            bottom: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RestaurantTextBlock(restaurant: restaurant),
                const SizedBox(width: 14),
                const _RestaurantLogo(),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 15,
            start: 25,
            end: 25,
            child: SizedBox(
              height: 21,
              child: FilledButton.icon(
                onPressed: onMorePressed,
                icon: Icon(
                  Icons.restaurant_rounded,
                  color: color.primary,
                  size: 12,
                ),
                label: Text(locale.calendar_change_restaurant),
                style: FilledButton.styleFrom(
                  backgroundColor: color.surface,
                  foregroundColor: color.primary,
                  padding: EdgeInsets.zero,
                  textStyle: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 8.6,
                    color: color.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
