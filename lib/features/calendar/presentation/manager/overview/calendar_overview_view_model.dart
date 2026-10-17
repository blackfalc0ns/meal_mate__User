import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/data/services/customer_delivery_realtime_service.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_customer_delivery_widget_usecase.dart';
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
    this._getCustomerDeliveryWidgetUseCase,
    this._notificationBadgeViewModel,
    this._realtimeService,
  ]) : super(const CalendarOverviewState()) {
    _listenToRealtimeDelivery();
  }

  final GetCalendarUseCase _getCalendarUseCase;
  final GetCalendarDayUseCase _getCalendarDayUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper _sharedPrefHelper;
  final GetCustomerDeliveryWidgetUseCase? _getCustomerDeliveryWidgetUseCase;
  final NotificationBadgeViewModel? _notificationBadgeViewModel;
  final CustomerDeliveryRealtimeService? _realtimeService;

  StreamSubscription<String>? _realtimeSubscription;
  bool _isRealtimePaused = false;
  int _calendarRequestGeneration = 0;
  int _dayRequestGeneration = 0;
  int _deliveryRequestGeneration = 0;

  void _listenToRealtimeDelivery() {
    unawaited(_realtimeService?.connect());
    _realtimeSubscription = _realtimeService?.onDeliveryChanged.listen((dayId) {
      if (isClosed) return;
      final matchingDay = state.days
          .where((day) => day.id == dayId)
          .firstOrNull;
      debugPrint('[DeliveryRealtime] event received dayId=$dayId');
      unawaited(
        _loadDeliveryWidgetForDate(
          matchingDay?.date,
          fetchAll: matchingDay == null,
        ),
      );
    });
  }

  void pauseDeliveryRealtime() {
    _isRealtimePaused = true;
    unawaited(_realtimeSubscription?.cancel());
    _realtimeSubscription = null;
    unawaited(_realtimeService?.disconnect());
  }

  void resumeDeliveryRealtime() {
    _isRealtimePaused = false;
    final isAllDelivered =
        state.deliveryWidget != null &&
        state.deliveryWidget!.items.isNotEmpty &&
        state.deliveryWidget!.items.every((item) => item.isTerminalStatus);
    if (!isAllDelivered && _realtimeSubscription == null) {
      _listenToRealtimeDelivery();
    }
    unawaited(loadDeliveryWidget());
  }

  @override
  Future<void> close() async {
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    await _realtimeService?.disconnect();
    return super.close();
  }

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
      case LoadDeliveryWidgetEvent():
        unawaited(loadDeliveryWidget(date: event.date));
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
        if (selectedDate != null) {
          unawaited(_loadDeliveryWidgetForDate(selectedDate));
        }
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
    unawaited(_loadDeliveryWidgetForDate(day.date!));
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
    await Future.wait([
      _loadSelectedDayDetailsForDate(date, localeName: localeName),
      _loadDeliveryWidgetForDate(date),
    ]);
  }

  Future<void> loadDeliveryWidget({DateTime? date}) async {
    final targetDate = date ?? state.selectedDate;
    if (targetDate == null) return;
    await _loadDeliveryWidgetForDate(targetDate);
  }

  Future<void> _loadDeliveryWidgetForDate(
    DateTime? targetDate, {
    bool fetchAll = false,
  }) async {
    final useCase = _getCustomerDeliveryWidgetUseCase;
    if (useCase == null) return;
    if (!fetchAll && targetDate == null) return;
    final dateStr = targetDate == null
        ? null
        : DateFormat('yyyy-MM-dd').format(targetDate);
    final generation = ++_deliveryRequestGeneration;
    debugPrint(
      '[DeliveryRealtime] REST fetching delivery-widget date=${dateStr ?? 'all'} subId=${state.subscriptionId.isNotEmpty ? state.subscriptionId : 'current'} gen=$generation',
    );
    emit(state.copyWith(isDeliveryLoading: true, clearDeliveryFailure: true));

    final result = await useCase(
      serviceDate: dateStr,
      subscriptionId: state.subscriptionId.isNotEmpty
          ? state.subscriptionId
          : null,
    );

    if (isClosed || generation != _deliveryRequestGeneration) {
      debugPrint(
        '[DeliveryRealtime] Ignored stale response gen=$generation current=$_deliveryRequestGeneration',
      );
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            deliveryWidget: result.data,
            isDeliveryLoading: false,
            clearDeliveryFailure: true,
          ),
        );
        debugPrint(
          '[DeliveryRealtime] widget state updated items=${result.data.items.length} gen=$generation',
        );
        final isAllDelivered =
            result.data.items.isNotEmpty &&
            result.data.items.every((item) => item.isTerminalStatus);
        if (isAllDelivered) {
          unawaited(_realtimeSubscription?.cancel());
          _realtimeSubscription = null;
          unawaited(_realtimeService?.disconnect());
          debugPrint(
            '[DeliveryRealtime] All deliveries completed -> socket disconnected',
          );
        } else if (_realtimeSubscription == null && !_isRealtimePaused) {
          _listenToRealtimeDelivery();
        }
      case ApiErrorResult():
        debugPrint(
          '[DeliveryRealtime] widget fetch failed: ${result.failure.errorMessage} gen=$generation',
        );
        emit(
          state.copyWith(
            deliveryFailure: result.failure,
            isDeliveryLoading: false,
          ),
        );
    }
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
