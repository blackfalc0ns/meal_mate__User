import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
part 'calendar_restaurant_text_block.dart';
part 'calendar_meta_chip.dart';
part 'calendar_restaurant_summary_logo.dart';

class CalendarRestaurantSummaryCard extends StatelessWidget {
  const CalendarRestaurantSummaryCard({
    super.key,
    required this.restaurant,
    this.day,
    this.onMorePressed,
  });

  final CalendarRestaurantEntity restaurant;
  final CalendarDayEntity? day;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CalendarRestaurantSummaryLogo(
                logoUrl: restaurant.logoUrl,
                semanticLabel: restaurant.name,
              ),
              const SizedBox(width: Spacing.calendarRestaurantSummaryLogoGap),
              Expanded(
                child: CalendarRestaurantTextBlock(restaurant: restaurant),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          _buildAction(context),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selectedDay = day;
    final showStatus = onMorePressed == null && selectedDay != null;

    if (showStatus) {
      final isClosed =
          selectedDay.isRestaurantClosed || !selectedDay.hasSelectedMeals;
      final label = isClosed
          ? locale.calendar_selection_locked_before_72_hours
          : locale.calendar_meals_changed;
      final icon = isClosed ? Icons.lock_rounded : Icons.check_rounded;
      final backgroundColor = isClosed
          ? color.errorContainer
          : color.secondaryContainer;
      final foregroundColor = isClosed
          ? color.onErrorContainer
          : color.onSecondaryContainer;

      return Container(
        height: Spacing.calendarRestaurantSummaryButtonHeight,
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: Spacing.iconSm, color: foregroundColor),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      );
    }

    return AppButton(
      text: locale.calendar_change_restaurant,
      onPressed: onMorePressed,
      height: Spacing.calendarRestaurantSummaryButtonHeight,
      borderRadius: Spacing.radiusPill,
      color: color.surface,
      textColor: color.primary,
      fontSize: FontSize.size11,
      icon: Icons.sync_rounded,
      padding: EdgeInsets.zero,
    );
  }
}
