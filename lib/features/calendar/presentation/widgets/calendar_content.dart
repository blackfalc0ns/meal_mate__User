import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_days_builder.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_day_content.dart';
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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final date = widget.state.selectedDate ?? DateTime.now();
    _focusedMonth = DateTime(date.year, date.month);
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
      return Padding(
        padding: const EdgeInsets.all(Spacing.screenH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStateWidget(
              title: locale.billing_no_subscription_title,
              description: locale.billing_no_subscription_description,
              icon: Icons.calendar_month_rounded,
            ),
            const SizedBox(height: Spacing.lg),
            AppButton(
              text: locale.subscription_details_subscribe_now,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.subscriptions),
            ),
          ],
        ),
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
    });
  }
}
