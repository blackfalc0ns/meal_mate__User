import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_day_cell.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_calendar_month_nav_button.dart';

class FamilyMemberCalendarMonthCard extends StatelessWidget {
  const FamilyMemberCalendarMonthCard({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.days,
    required this.subscriptionDays,
    required this.onMonthChanged,
    required this.onDaySelected,
    this.canGoPrevious = true,
    this.canGoNext = true,
  });

  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final List<CalendarDayEntity> days;
  final List<CalendarDayEntity> subscriptionDays;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<CalendarDayEntity> onDaySelected;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final weekdays = [
      locale.calendar_weekday_sat_short,
      locale.calendar_weekday_sun_short,
      locale.calendar_weekday_mon_short,
      locale.calendar_weekday_tue_short,
      locale.calendar_weekday_wed_short,
      locale.calendar_weekday_thu_short,
      locale.calendar_weekday_fri_short,
    ];

    final monthFormat = intl.DateFormat.MMMM(locale.localeName);
    final yearFormat = intl.DateFormat.y(locale.localeName);
    final monthName = monthFormat.format(visibleMonth);
    final yearName = yearFormat.format(visibleMonth);

    return Column(
      key: const ValueKey('family-calendar-month-card'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month navigation header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xs,
          ),
          child: Row(
            children: [
              FamilyMemberCalendarMonthNavButton(
                icon: Icons.chevron_left_rounded,
                isEnabled: canGoPrevious,
                onPressed: () => onMonthChanged(-1),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size22,
                      color: color.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: monthName,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size22,
                          color: color.primary,
                        ),
                      ),
                      TextSpan(text: ' $yearName'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FamilyMemberCalendarMonthNavButton(
                icon: Icons.chevron_right_rounded,
                isEnabled: canGoNext,
                onPressed: () => onMonthChanged(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        // White calendar card
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(
              Spacing.familyMemberCalendarCardRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.familyMemberCalendarCardPadding,
              vertical: Spacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Weekday headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final dayLabel in weekdays)
                      Expanded(
                        child: Center(
                          child: Text(
                            dayLabel,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                // Days Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final day = days[index];
                    return FamilyMemberCalendarDayCell(
                      day: day,
                      isSelected: day.isSelected,
                      onTap: day.isMuted ? null : () => onDaySelected(day),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
