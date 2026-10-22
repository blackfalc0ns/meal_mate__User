import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

class CalendarPickerSection extends StatefulWidget {
  const CalendarPickerSection({
    super.key,
    this.isNoSubscription = false,
    this.onDaySelected,
  });

  final bool isNoSubscription;
  final ValueChanged<CalendarDayEntity>? onDaySelected;

  @override
  State<CalendarPickerSection> createState() => _CalendarPickerSectionState();
}

class _CalendarPickerSectionState extends State<CalendarPickerSection> {
  bool _isInitialized = false;
  late DateTime _focusedMonth;
  late DateTime _emptySelectedDate;
  List<CalendarDayEntity> _emptyDays = const [];
  String? _emptyDaysLocaleName;
  bool _isExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      DateTime? initialDate;
      try {
        initialDate = context
            .read<CalendarOverviewViewModel>()
            .state
            .selectedDate;
      } catch (_) {}
      final effectiveDate = initialDate ?? DateTime.now();
      _focusedMonth = DateTime(effectiveDate.year, effectiveDate.month);
      _emptySelectedDate = effectiveDate;
    }
    final localeName = context.localization.localeName;
    if (_emptyDaysLocaleName != localeName) {
      _emptyDaysLocaleName = localeName;
      _updateEmptyDays();
    }
  }

  void _updateEmptyDays() {
    final localeName = _emptyDaysLocaleName;
    if (localeName == null) return;
    final dayCount = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    _emptyDays = List.generate(dayCount, (index) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, index + 1);
      return CalendarDayEntity(
        dayNumber: date.day,
        weekday: DateFormat.EEEE(localeName).format(date),
        date: date,
        isSelected:
            date.year == _emptySelectedDate.year &&
            date.month == _emptySelectedDate.month &&
            date.day == _emptySelectedDate.day,
        canEdit: false,
      );
    });
  }

  void _changeMonth(int direction) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + direction,
      );
      if (widget.isNoSubscription) {
        _updateEmptyDays();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (widget.isNoSubscription) {
      final days = _isExpanded
          ? CalendarDaysBuilder.monthDays(
              focusedMonth: _focusedMonth,
              selectedDate: _emptySelectedDate,
              serviceDays: _emptyDays,
            )
          : _emptyDays;

      return CalendarPickerPanel(
        monthTitle: DateFormat.yMMMM(locale.localeName).format(_focusedMonth),
        days: days,
        isExpanded: _isExpanded,
        onToggleExpanded: () => setState(() => _isExpanded = !_isExpanded),
        onMonthChanged: _changeMonth,
        onDaySelected: (day) {
          if (day.date == null) return;
          setState(() {
            _emptySelectedDate = day.date!;
            _updateEmptyDays();
          });
          widget.onDaySelected?.call(day);
        },
      );
    }

    return BlocSelector<
      CalendarOverviewViewModel,
      CalendarOverviewState,
      ({
        List<CalendarDayEntity> days,
        DateTime? selectedDate,
        bool includeFriday,
      })
    >(
      selector: (state) => (
        days: state.days,
        selectedDate: state.selectedDate,
        includeFriday: state.calendar?.includeFriday != false,
      ),
      builder: (context, data) {
        final selectedDate = data.selectedDate;
        if (selectedDate != null &&
            (_focusedMonth.year != selectedDate.year ||
                _focusedMonth.month != selectedDate.month)) {
          _focusedMonth = DateTime(selectedDate.year, selectedDate.month);
        }

        final displayDays = _isExpanded
            ? CalendarDaysBuilder.monthDays(
                focusedMonth: _focusedMonth,
                selectedDate: selectedDate,
                serviceDays: data.days,
                includeFriday: data.includeFriday,
              )
            : CalendarDaysBuilder.serviceDays(
                data.days,
                includeFriday: data.includeFriday,
                selectedDate: selectedDate,
              );

        return CalendarPickerPanel(
          monthTitle: DateFormat.yMMMM(locale.localeName).format(_focusedMonth),
          days: displayDays,
          includeFriday: data.includeFriday,
          isExpanded: _isExpanded,
          onToggleExpanded: () => setState(() => _isExpanded = !_isExpanded),
          onMonthChanged: _changeMonth,
          onDaySelected:
              widget.onDaySelected ??
              (day) {
                context.read<CalendarOverviewViewModel>().selectDay(
                  day: day,
                  localeName: locale.localeName,
                );
              },
        );
      },
    );
  }
}
