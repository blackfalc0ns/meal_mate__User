import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

class FamilyMemberCalendarPickerSection extends StatefulWidget {
  const FamilyMemberCalendarPickerSection({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.serviceDays,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final List<CalendarDayEntity> serviceDays;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<CalendarDayEntity> onDaySelected;

  @override
  State<FamilyMemberCalendarPickerSection> createState() =>
      _FamilyMemberCalendarPickerSectionState();
}

class _FamilyMemberCalendarPickerSectionState
    extends State<FamilyMemberCalendarPickerSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final validDates =
        widget.serviceDays.map((d) => d.date).whereType<DateTime>().toList()
          ..sort();

    final DateTime? minDate = validDates.isNotEmpty ? validDates.first : null;
    final DateTime? maxDate = validDates.isNotEmpty ? validDates.last : null;

    final canGoPrevious =
        minDate == null ||
        DateTime(
          widget.visibleMonth.year,
          widget.visibleMonth.month,
        ).isAfter(DateTime(minDate.year, minDate.month));

    final canGoNext =
        maxDate == null ||
        DateTime(
          widget.visibleMonth.year,
          widget.visibleMonth.month,
        ).isBefore(DateTime(maxDate.year, maxDate.month));

    final calendarDays = _isExpanded
        ? CalendarDaysBuilder.monthDays(
            focusedMonth: widget.visibleMonth,
            selectedDate: widget.selectedDate,
            serviceDays: widget.serviceDays,
          )
        : CalendarDaysBuilder.serviceDays(
            widget.serviceDays,
            selectedDate: widget.selectedDate,
          );

    return CalendarPickerPanel(
      monthTitle: intl.DateFormat.yMMMM(
        locale.localeName,
      ).format(widget.visibleMonth),
      days: calendarDays,
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
  }
}
