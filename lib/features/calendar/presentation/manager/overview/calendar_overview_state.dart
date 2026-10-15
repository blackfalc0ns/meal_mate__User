import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';

class CalendarOverviewState {
  const CalendarOverviewState({
    this.subscriptionId = '',
    this.calendar,
    this.days = const [],
    this.selectedDate,
    this.isCalendarLoading = false,
    this.isSelectedDayLoading = false,
    this.hasNoSubscription = false,
    this.calendarFailure,
  });

  final String subscriptionId;
  final CalendarSubscriptionEntity? calendar;
  final List<CalendarDayEntity> days;
  final DateTime? selectedDate;
  final bool isCalendarLoading;
  final bool isSelectedDayLoading;
  final bool hasNoSubscription;
  final Failure? calendarFailure;

  CalendarDayEntity? get selectedDay {
    final date = selectedDate;
    if (date == null) return days.firstOrNull;
    return days
        .where((day) => day.date != null && _isSameDay(day.date!, date))
        .firstOrNull;
  }

  bool get hasCalendarData => days.isNotEmpty;

  bool get isFulfillmentNotReady =>
      calendarFailure != null &&
      (calendarFailure!.code == 'calendar.fulfillment_not_ready' ||
          calendarFailure!.exception.backendErrorCode ==
              'calendar.fulfillment_not_ready');

  bool get canConfirmSelectedDayMeals {
    final day = selectedDay;
    if (day == null || !day.isEditable) return false;
    final meals = day.meals;
    if (meals.isEmpty) return false;
    final requiredCount = day.slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
    if (requiredCount > 0 && meals.length != requiredCount) return false;
    return true;
  }

  CalendarOverviewState copyWith({
    String? subscriptionId,
    CalendarSubscriptionEntity? calendar,
    List<CalendarDayEntity>? days,
    DateTime? selectedDate,
    bool? isCalendarLoading,
    bool? isSelectedDayLoading,
    bool? hasNoSubscription,
    Failure? calendarFailure,
    bool clearCalendar = false,
    bool clearSelectedDate = false,
    bool clearCalendarFailure = false,
  }) {
    return CalendarOverviewState(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      calendar: clearCalendar ? null : calendar ?? this.calendar,
      days: days ?? this.days,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
      isCalendarLoading: isCalendarLoading ?? this.isCalendarLoading,
      isSelectedDayLoading: isSelectedDayLoading ?? this.isSelectedDayLoading,
      hasNoSubscription: hasNoSubscription ?? this.hasNoSubscription,
      calendarFailure: clearCalendarFailure
          ? null
          : calendarFailure ?? this.calendarFailure,
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
