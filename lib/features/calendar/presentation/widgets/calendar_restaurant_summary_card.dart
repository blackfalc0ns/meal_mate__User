import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_badge.dart';

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
    const cardHeight = 126.0;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(
          Spacing.calendarRestaurantSummaryRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(Spacing.zero, Spacing.xs),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 0,
            width: context.width * 0.60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  restaurant.imageUrl?.isNotEmpty == true
                      ? restaurant.imageUrl!
                      : AssetsFake.familyDietHouseMeal,
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: [
                        color.primary.withValues(alpha: 0.55),
                        color.primary.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.75],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const PositionedDirectional(
            top: Spacing.sm,
            end: Spacing.sm,
            child: CalendarRestaurantBadge(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CalendarRestaurantSummaryLogo(
                      logoUrl: restaurant.logoUrl,
                      semanticLabel: restaurant.name,
                    ),
                    const SizedBox(width: Spacing.sm),
                    CalendarRestaurantTextBlock(restaurant: restaurant),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                _buildAction(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selectedDay = day;
    final showStatus = onMorePressed == null && selectedDay != null;
    const buttonHeight = Spacing.calendarRestaurantSummaryButtonHeight + 6;

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
        height: buttonHeight,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Spacing.radiusPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: Spacing.iconSm - 2, color: foregroundColor),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
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

    return Material(
      color: color.surface,
      borderRadius: BorderRadius.circular(Spacing.radiusPill),
      child: InkWell(
        onTap: onMorePressed,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
        child: Container(
          height: buttonHeight,
          width: double.infinity,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: [
              Icon(
                Icons.sync_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                locale.calendar_change_restaurant,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
