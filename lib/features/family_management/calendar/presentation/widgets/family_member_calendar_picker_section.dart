import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

class FamilyMemberCalendarPickerSection extends StatefulWidget {
  const FamilyMemberCalendarPickerSection({
    super.key,
    required this.fallbackDate,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  final DateTime fallbackDate;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  State<FamilyMemberCalendarPickerSection> createState() =>
      _FamilyMemberCalendarPickerSectionState();
}

class _FamilyMemberCalendarPickerSectionState
    extends State<FamilyMemberCalendarPickerSection> {
  bool _isExpanded = false;
  List<CalendarDayEntity>? _sourceDays;
  DateTime? _minDate;
  DateTime? _maxDate;
  DateTime? _calculatedMonth;
  DateTime? _calculatedDate;
  bool? _calculatedExpanded;
  List<CalendarDayEntity> _calendarDays = const [];

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocSelector<
      FamilyCalendarViewModel,
      FamilyCalendarState,
      ({
        DateTime month,
        DateTime? date,
        List<CalendarDayEntity> days,
        bool includeFriday,
      })
    >(
      selector: (state) => (
        month: state.visibleMonth ?? state.selectedDate ?? widget.fallbackDate,
        date: state.selectedDate,
        days: state.days,
        includeFriday: state.includeFriday,
      ),
      builder: (context, data) {
        final daysChanged = !identical(_sourceDays, data.days);
        if (daysChanged) {
          _sourceDays = data.days;
          final validDates =
              data.days.map((day) => day.date).whereType<DateTime>().toList()
                ..sort();
          _minDate = validDates.isEmpty ? null : validDates.first;
          _maxDate = validDates.isEmpty ? null : validDates.last;
        }
        final minDate = _minDate;
        final maxDate = _maxDate;
        final canGoPrevious =
            minDate == null ||
            DateTime(
              data.month.year,
              data.month.month,
            ).isAfter(DateTime(minDate.year, minDate.month));

        final canGoNext =
            maxDate == null ||
            DateTime(
              data.month.year,
              data.month.month,
            ).isBefore(DateTime(maxDate.year, maxDate.month));

        if (daysChanged ||
            _calculatedMonth != data.month ||
            _calculatedDate != data.date ||
            _calculatedExpanded != _isExpanded) {
          _calculatedMonth = data.month;
          _calculatedDate = data.date;
          _calculatedExpanded = _isExpanded;
          _calendarDays = _isExpanded
              ? CalendarDaysBuilder.monthDays(
                  focusedMonth: data.month,
                  selectedDate: data.date,
                  serviceDays: data.days,
                  includeFriday: data.includeFriday,
                )
              : CalendarDaysBuilder.serviceDays(
                  data.days,
                  includeFriday: data.includeFriday,
                  selectedDate: data.date,
                );
        }

        return CalendarPickerPanel(
          monthTitle: intl.DateFormat.yMMMM(
            locale.localeName,
          ).format(data.month),
          days: _calendarDays,
          includeFriday: data.includeFriday,
          isExpanded: _isExpanded,
          backgroundColor: color.surface,
          showBottomBorder: false,
          onToggleExpanded: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          onMonthChanged: (months) {
            if (months < 0 && !canGoPrevious) return;
            if (months > 0 && !canGoNext) return;
            widget.onMonthChanged(months);
          },
          onDaySelected: (day) {
            if (day.isMuted) return;
            widget.onDaySelected(day);
          },
        );
      },
    );
  }
}
