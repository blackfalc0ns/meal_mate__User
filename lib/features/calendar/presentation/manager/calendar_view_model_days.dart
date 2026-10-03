part of 'calendar_view_model.dart';

mixin CalendarViewModelDays on Cubit<CalendarState> {
  GetCalendarUseCase get _getCalendarUseCase;
  GetCalendarDayUseCase get _getCalendarDayUseCase;
  GetCurrentCustomerSubscriptionUseCase get _getCurrentCustomerSubscriptionUseCase;
  SharedPrefHelper get _sharedPrefHelper;
  Future<void> _loadCalendar({
    required String? subscriptionId,
    required String localeName,
    bool retryWithCurrentOnNotFound = true,
  }) async {
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

    emit(
      state.copyWith(
        subscriptionId: resolvedSubscriptionId,
        isCalendarLoading: true,
        hasNoSubscription: false,
        clearCalendarFailure: true,
        clearAvailableMeals: true,
      ),
    );

    final result = await _getCalendarUseCase(
      subscriptionId: resolvedSubscriptionId,
      localeName: localeName,
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final days = result.data.days;
        final selectedDate = _initialSelectedDate(days);
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
            clearRestaurants: true,
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
          await _loadCalendar(
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

  void _selectDay({
    required CalendarDayEntity day,
    required String localeName,
  }) {
    if (day.date == null) return;
    final needsLoading = day.meals.isEmpty && day.isEditable;
    emit(
      state.copyWith(
        selectedDate: day.date,
        localSelectedMealIds: day.selectedMealIds,
        isSelectedDayLoading: needsLoading,
        clearRestaurants: true,
        clearAvailableMeals: true,
        clearAvailableMealsFailure: true,
        clearSaveFailure: true,
      ),
    );
    unawaited(
      _loadSelectedDayDetailsForDate(day.date!, localeName: localeName),
    );
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
    final date = DateFormat('yyyy-MM-dd').format(selectedDate);
    final result = await _getCalendarDayUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      localeName: localeName,
    );
    if (isClosed || !_isSameSelectedDate(selectedDate)) return;

    switch (result) {
      case ApiSuccessResult():
        _replaceDay(result.data);
      case ApiErrorResult():
        emit(
          state.copyWith(
            calendarFailure: result.failure,
            isSelectedDayLoading: false,
          ),
        );
    }
  }

  void _replaceDay(CalendarDayEntity updatedDay) {
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
    emit(
      state.copyWith(
        days: updatedDays,
        isSelectedDayLoading: false,
        localSelectedMealIds: _isSameSelectedDate(updatedDay.date!)
            ? updatedDay.selectedMealIds
            : state.localSelectedMealIds,
      ),
    );
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
        failure.code == 'errors.common.not_found' ||
        failure.exception.backendErrorCode == 'errors.common.not_found';
  }
}
