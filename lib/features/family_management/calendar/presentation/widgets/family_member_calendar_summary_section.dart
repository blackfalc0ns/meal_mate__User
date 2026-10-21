import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_member_calendar_entity.dart';
import 'family_member_calendar_day_summary_card.dart';

class FamilyMemberCalendarSummarySection extends StatelessWidget {
  const FamilyMemberCalendarSummarySection({
    super.key,
    required this.selectedDate,
    required this.mealCount,
  });
  final DateTime selectedDate;
  final int mealCount;
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return FamilyMemberCalendarDaySummaryCard(
      summary: FamilyCalendarDaySummaryEntity(
        title: intl.DateFormat.yMMMMEEEEd(
          locale.localeName,
        ).format(selectedDate),
        subtitle: locale.family_member_selected_meals_count(mealCount),
      ),
      dayNumber: selectedDate.day,
    );
  }
}
