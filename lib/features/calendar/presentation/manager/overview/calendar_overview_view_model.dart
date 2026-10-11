import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notification_badge_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';

@injectable
class CalendarOverviewViewModel extends Cubit<CalendarOverviewState> {
  CalendarOverviewViewModel(
    this._getCalendarUseCase,
    this._getCalendarDayUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
    this._sharedPrefHelper, [
    this._notificationBadgeViewModel,
  ]) : super(const CalendarOverviewState());

  final GetCalendarUseCase _getCalendarUseCase;
  final GetCalendarDayUseCase _getCalendarDayUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper _sharedPrefHelper;
  final NotificationBadgeViewModel? _notificationBadgeViewModel;

  int _calendarRequestGeneration = 0;
  int _dayRequestGeneration = 0;

  void doIntent(CalendarOverviewEvent event) {
    switch (event) {
      case LoadCalendarEvent():
        unawaited(
          loadCalendar(
            subscriptionId: event.subscriptionId,
            localeName: event.localeName,
            retryWithCurrentOnNotFound: event.retryWithCurrentOnNotFound,
          ),
        );
      case SelectCalendarDayEvent():
        selectDay(day: event.day, localeName: event.localeName);
      case ReplaceCalendarDayEvent():
        replaceDay(event.day);
    }
  }

  Future<void> loadCalendar({
    String? subscriptionId,
    required String localeName,
    bool retryWithCurrentOnNotFound = true,
  }) async {
    emit(
      state.copyWith(
        isCalendarLoading: true,
        hasNoSubscription: false,
        clearCalendarFailure: true,
      ),
    );

    final resolvedSubscriptionId = subscriptionId?.trim().isNotEmpty == true
        ? subscriptionId!.trim()
        : await _resolveCurrentSubscriptionId();
    if (resolvedSubscriptionId == null) return;
    if (resolvedSubscriptionId.isEmpty) {
      emit(
        state.copyWith(
          isCalendarLoading: false,
          hasNoSubscription: true,
          clearCalendarFailure: true,
        ),
      );
      return;
    }

    final generation = ++_calendarRequestGeneration;
    _dayRequestGeneration++;
    final badgeVersion = _notificationBadgeViewModel
        ?.beginCalendarCountRequest();

    emit(
      state.copyWith(
        subscriptionId: resolvedSubscriptionId,
        isCalendarLoading: true,
        hasNoSubscription: false,
        clearCalendarFailure: true,
      ),
    );

    final result = await _getCalendarUseCase(
      subscriptionId: resolvedSubscriptionId,
      localeName: localeName,
    );
    if (isClosed || generation != _calendarRequestGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        final days = result.data.days;
        final selectedDate = _initialSelectedDate(days);
        if (_notificationBadgeViewModel != null && badgeVersion != null) {
          final serverCount = result.data.unreadNotificationsCount;
          if (serverCount != null) {
            _notificationBadgeViewModel.acceptCalendarCount(
              serverCount,
              requestVersion: badgeVersion,
            );
          } else if (result.data.hasUnreadNotifications != null) {
            _notificationBadgeViewModel.acceptCalendarCount(
              result.data.hasUnreadNotifications! ? 1 : 0,
              requestVersion: badgeVersion,
            );
          }
        }
        if (subscriptionId == null || subscriptionId.trim().isEmpty) {
          await _sharedPrefHelper.saveData(
            key: StorageKeys.currentSubscriptionId,
            val: resolvedSubscriptionId,
          );
        }
        emit(
          state.copyWith(
            calendar: result.data,
            days: days,
            selectedDate: selectedDate,
            isCalendarLoading: false,
            clearCalendarFailure: true,
          ),
        );
        await _loadSelectedDayDetails(localeName);
      case ApiErrorResult():
        if (retryWithCurrentOnNotFound &&
            _isNotFound(result.failure) &&
            (subscriptionId == null || subscriptionId.trim().isEmpty)) {
          await _sharedPrefHelper.removeData(
            key: StorageKeys.currentSubscriptionId,
          );
          await loadCalendar(
            subscriptionId: null,
            localeName: localeName,
            retryWithCurrentOnNotFound: false,
          );
          return;
        }
        emit(
          state.copyWith(
            isCalendarLoading: false,
            calendarFailure: result.failure,
          ),
        );
    }
  }

  void selectDay({required CalendarDayEntity day, required String localeName}) {
    if (day.date == null) return;
    _dayRequestGeneration++;

    final needsLoading = day.meals.isEmpty && day.isEditable;
    emit(
      state.copyWith(
        selectedDate: day.date,
        isSelectedDayLoading: needsLoading,
      ),
    );
    unawaited(
      _loadSelectedDayDetailsForDate(day.date!, localeName: localeName),
    );
  }

  void replaceDay(CalendarDayEntity updatedDay) {
    if (updatedDay.date == null) return;
    final updatedDays = state.days.map((day) {
      if (day.date == null || !_isSameDay(day.date!, updatedDay.date!)) {
        return day;
      }
      final resolvedMeals = updatedDay.meals.isNotEmpty
          ? updatedDay.meals
          : day.meals;
      return updatedDay.copyWith(meals: resolvedMeals);
    }).toList();
    emit(state.copyWith(days: updatedDays, isSelectedDayLoading: false));
  }

  DateTime? _initialSelectedDate(List<CalendarDayEntity> days) {
    if (days.isEmpty) return null;
    final today = DateTime.now();
    final todayDay = days
        .where(
          (day) =>
              day.date != null &&
              day.date!.year == today.year &&
              day.date!.month == today.month &&
              day.date!.day == today.day,
        )
        .firstOrNull;
    return todayDay?.date ?? days.first.date;
  }

  Future<void> refreshDay(DateTime date, {required String localeName}) async {
    await _loadSelectedDayDetailsForDate(date, localeName: localeName);
  }

  Future<void> _loadSelectedDayDetails(String localeName) async {
    final selectedDate = state.selectedDate;
    if (selectedDate == null) return;
    await _loadSelectedDayDetailsForDate(selectedDate, localeName: localeName);
  }

  Future<void> _loadSelectedDayDetailsForDate(
    DateTime selectedDate, {
    required String localeName,
  }) async {
    if (state.subscriptionId.isEmpty || localeName.isEmpty) return;
    final generation = ++_dayRequestGeneration;
    final date = DateFormat('yyyy-MM-dd').format(selectedDate);
    final result = await _getCalendarDayUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      localeName: localeName,
    );
    if (isClosed ||
        generation != _dayRequestGeneration ||
        !_isSameSelectedDate(selectedDate)) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        replaceDay(result.data);
      case ApiErrorResult():
        emit(
          state.copyWith(
            calendarFailure: result.failure,
            isSelectedDayLoading: false,
          ),
        );
    }
  }

  bool _isSameSelectedDate(DateTime date) {
    final selectedDate = state.selectedDate;
    if (selectedDate == null) return false;
    return _isSameDay(selectedDate, date);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<String?> _resolveCurrentSubscriptionId() async {
    final result = await _getCurrentCustomerSubscriptionUseCase();
    switch (result) {
      case ApiSuccessResult():
        final subscriptionId = result.data.subscription?.subscriptionId ?? '';
        if (subscriptionId.isEmpty) {
          await _sharedPrefHelper.removeData(
            key: StorageKeys.currentSubscriptionId,
          );
          return '';
        }
        await _sharedPrefHelper.saveData(
          key: StorageKeys.currentSubscriptionId,
          val: subscriptionId,
        );
        return subscriptionId;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isCalendarLoading: false,
            calendarFailure: result.failure,
          ),
        );
        return '';
    }
  }

  bool _isNotFound(Failure failure) {
    return failure.exception.errorType == ApiErrorType.notFound ||
        failure.code == SubscriptionErrorCodes.commonNotFound ||
        failure.exception.backendErrorCode ==
            SubscriptionErrorCodes.commonNotFound;
  }
}
