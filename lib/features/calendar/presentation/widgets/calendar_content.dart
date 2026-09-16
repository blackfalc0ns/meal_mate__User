import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_content.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_empty_meals_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_picker_panel.dart';

class CalendarContent extends StatefulWidget {
  const CalendarContent({
    super.key,
    required this.state,
    required this.showBottomSpace,
    required this.onSelectRestaurant,
    required this.onChangeMeal,
    required this.onMealTap,
  });
  final CalendarState state;
  final bool showBottomSpace;
  final VoidCallback onSelectRestaurant;
  final VoidCallback onChangeMeal;
  final void Function(CalendarMealEntity, CalendarRestaurantEntity?) onMealTap;
  @override
  State<CalendarContent> createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  late DateTime _focusedMonth;
  late DateTime _emptySelectedDate;
  List<CalendarDayEntity> _emptyDays = const [];
  String? _emptyDaysLocaleName;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final date = widget.state.selectedDate ?? DateTime.now();
    _focusedMonth = DateTime(date.year, date.month);
    _emptySelectedDate = date;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeName = context.localization.localeName;
    if (_emptyDaysLocaleName != localeName) {
      _emptyDaysLocaleName = localeName;
      _updateEmptyDays();
    }
  }

  @override
  void didUpdateWidget(covariant CalendarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selectedDate = widget.state.selectedDate;
    if (selectedDate != null &&
        (_focusedMonth.year != selectedDate.year ||
            _focusedMonth.month != selectedDate.month)) {
      _focusedMonth = DateTime(selectedDate.year, selectedDate.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final state = widget.state;

    if (state.isCalendarLoading && !state.hasCalendarData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasNoSubscription) {
      final days = _isExpanded
          ? CalendarDaysBuilder.monthDays(
              focusedMonth: _focusedMonth,
              selectedDate: _emptySelectedDate,
              serviceDays: _emptyDays,
            )
          : _emptyDays;
      return Column(
        children: [
          CalendarPickerPanel(
            monthTitle: DateFormat.yMMMM(
              locale.localeName,
            ).format(_focusedMonth),
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
            },
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                  vertical: Spacing.lg,
                ),
                child: CalendarEmptyMealsState(
                  isNoSubscription: true,
                  onAddMeals: () =>
                      context.pushNamed(AppRoutes.subscriptions),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (state.calendarFailure != null && !state.hasCalendarData) {
      return ApiErrorWidget(
        exception: state.calendarFailure!.exception,
        onRetry: () => context.read<CalendarViewModel>().doIntent(
          LoadCalendarEvent(
            subscriptionId: state.subscriptionId,
            localeName: locale.localeName,
          ),
        ),
      );
    }

    if (!state.hasCalendarData) {
      return EmptyStateWidget(
        title: locale.calendar_title,
        description: locale.billing_no_subscription_description,
        icon: Icons.calendar_month_rounded,
      );
    }

    final selectedDay = state.selectedDay;
    final days = _isExpanded
        ? CalendarDaysBuilder.monthDays(
            focusedMonth: _focusedMonth,
            selectedDate: state.selectedDate,
            serviceDays: state.days,
          )
        : CalendarDaysBuilder.serviceDays(
            state.days,
            selectedDate: state.selectedDate,
          );

    return Column(
      children: [
        CalendarPickerPanel(
          monthTitle: DateFormat.yMMMM(locale.localeName).format(_focusedMonth),
          days: days,
          isExpanded: _isExpanded,
          onToggleExpanded: () {
            setState(() => _isExpanded = !_isExpanded);
          },
          onMonthChanged: _changeMonth,
          onDaySelected: (day) {
            context.read<CalendarViewModel>().doIntent(
              SelectCalendarDayEvent(day: day, localeName: locale.localeName),
            );
          },
        ),
        Expanded(
          child: CalendarDayContent(
            selectedDay: selectedDay,
            showBottomSpace: widget.showBottomSpace,
            onSelectRestaurant: widget.onSelectRestaurant,
            onChangeMeal: widget.onChangeMeal,
            onMealTap: widget.onMealTap,
          ),
        ),
      ],
    );
  }

  void _changeMonth(int direction) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + direction,
      );
      if (widget.state.hasNoSubscription) {
        _emptySelectedDate = DateTime(_focusedMonth.year, _focusedMonth.month);
        _updateEmptyDays();
      }
    });
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
        hasMeals: false,
      );
    });
  }
}
