import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'family_day_header.dart';

class FamilyDayDateSection extends StatelessWidget {
  const FamilyDayDateSection({
    super.key,
    required this.fallbackDate,
    required this.onPreviousDay,
    required this.onNextDay,
  });
  final DateTime fallbackDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  Future<void> _openDatePicker(BuildContext context) async {
    final locale = context.localization;
    final viewModel = context.read<FamilyCalendarViewModel>();
    final validDates =
        viewModel.state.days
            .map((day) => day.date)
            .whereType<DateTime>()
            .map(DateUtils.dateOnly)
            .toList()
          ..sort();
    if (validDates.isEmpty) return;

    final currentDate = viewModel.state.selectedDate ?? fallbackDate;
    final initialDate =
        validDates.any((date) => DateUtils.isSameDay(date, currentDate))
        ? currentDate
        : validDates.first;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: validDates.first,
      lastDate: validDates.last,
      selectableDayPredicate: (date) =>
          validDates.any((valid) => DateUtils.isSameDay(valid, date)),
      locale: Locale(locale.localeName),
    );

    if (pickedDate == null || !context.mounted) {
      return;
    }

    final cleanDate = DateUtils.dateOnly(pickedDate);
    if (DateUtils.isSameDay(cleanDate, currentDate)) {
      return;
    }

    viewModel.doIntent(
      SelectFamilyCalendarDayEvent(
        day: CalendarDayEntity(
          dayNumber: cleanDate.day,
          weekday: '',
          date: cleanDate,
        ),
        localeName: locale.localeName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocSelector<FamilyCalendarViewModel, FamilyCalendarState, DateTime>(
      selector: (state) => state.selectedDate ?? fallbackDate,
      builder: (context, date) => FamilyDayHeader(
        dateLabel: intl.DateFormat.yMMMMEEEEd(locale.localeName).format(date),
        onPreviousDay: onPreviousDay,
        onNextDay: onNextDay,
        onDatePressed: () => _openDatePicker(context),
      ),
    );
  }
}
