import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/presentation/models/calendar_meal_item.dart';

class CalendarMealTimelineCard extends StatelessWidget {
  const CalendarMealTimelineCard({super.key, required this.meal});

  final CalendarMealItem meal;

  @override
  Widget build(BuildContext context) {
    final isCurrent = meal.state == CalendarMealState.current;
    final isCompleted = meal.state == CalendarMealState.completed;
    final accent = isCurrent
        ? AppColors.calendarCurrent
        : AppColors.calendarAccentDark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const PositionedDirectional(
          start: -18,
          top: 0,
          bottom: -18,
          child: ColoredBox(
            color: AppColors.calendarBorder,
            child: SizedBox(width: 2),
          ),
        ),
        _MealCardBody(meal: meal, isCurrent: isCurrent, accent: accent),
        PositionedDirectional(
          start: isCurrent ? -32 : -30,
          top: 16,
          child: _TimelineMarker(
            accent: accent,
            isCurrent: isCurrent,
            isCompleted: isCompleted,
          ),
        ),
      ],
    );
  }
}

class _MealCardBody extends StatelessWidget {
  const _MealCardBody({
    required this.meal,
    required this.isCurrent,
    required this.accent,
  });

  final CalendarMealItem meal;
  final bool isCurrent;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCurrent ? 16 : 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrent ? accent : AppColors.calendarBorder,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarShadow,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              meal.asset,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: _MealDetails(meal: meal, isCurrent: isCurrent),
          ),
        ],
      ),
    );
  }
}

class _MealDetails extends StatelessWidget {
  const _MealDetails({required this.meal, required this.isCurrent});

  final CalendarMealItem meal;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final status = switch (meal.state) {
      CalendarMealState.completed => context.localization.calendar_completed,
      CalendarMealState.current => context.localization.calendar_current,
      CalendarMealState.upcoming => context.localization.calendar_upcoming,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                meal.time,
                textAlign: TextAlign.end,
                style: getBoldStyle(
                  fontSize: 14,
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  color: isCurrent
                      ? AppColors.calendarCurrentDark
                      : AppColors.calendarAccentDark,
                ),
              ),
            ),
            _StatusBadge(label: status, isCurrent: isCurrent),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          meal.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getMediumStyle(
            fontSize: 18,
            fontFamily: FontConstant.ibmPlexSansArabic,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          alignment: WrapAlignment.end,
          children: [
            if (meal.extra != null) _NutrientChip(meal.extra!),
            Text(
              meal.calories,
              style: getRegularStyle(
                fontSize: 12,
                fontFamily: FontConstant.ibmPlexSansArabic,
                color: AppColors.calendarTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.isCurrent});
  final String label;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.calendarCurrent
            : AppColors.calendarTimelineInactive,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontSize: 10,
          fontFamily: FontConstant.ibmPlexSansArabic,
          color: isCurrent ? AppColors.white : AppColors.calendarAccentDark,
        ),
      ),
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({
    required this.accent,
    required this.isCurrent,
    required this.isCompleted,
  });
  final Color accent;
  final bool isCurrent;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCurrent ? 30 : 26,
      height: isCurrent ? 30 : 26,
      decoration: BoxDecoration(
        color: accent,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.calendarIndicatorBorder, width: 4),
        boxShadow: isCurrent
            ? const [
                BoxShadow(
                  color: AppColors.calendarCurrentShadow,
                  blurRadius: 5,
                ),
              ]
            : null,
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 14, color: AppColors.white)
          : isCurrent
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _NutrientChip extends StatelessWidget {
  const _NutrientChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.calendarTimelineDivider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: getRegularStyle(
          fontSize: 12,
          fontFamily: FontConstant.ibmPlexSansArabic,
          color: AppColors.calendarTextBrown,
        ),
      ),
    );
  }
}
