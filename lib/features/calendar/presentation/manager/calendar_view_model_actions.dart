part of 'calendar_view_model.dart';

mixin CalendarViewModelActions on Cubit<CalendarState>, CalendarViewModelDays {
  SaveCalendarDayMealsUseCase get _saveDayMealsUseCase;
  AutoSelectCalendarDayUseCase get _autoSelectDayUseCase;
  ConfirmCalendarDayMealsUseCase get _confirmDayMealsUseCase;

  Future<void> _saveMeals(String localeName) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    final available = state.availableMeals;
    if (day == null ||
        available == null ||
        date.isEmpty ||
        !state.canSaveMeals) {
      return;
    }
    final selectedMeals = available.meals
        .where((meal) => state.localSelectedMealIds.contains(meal.id))
        .toList();
    if (selectedMeals.length != state.localSelectedMealIds.length) return;

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _saveDayMealsUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      meals: selectedMeals,
      localeName: localeName,
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        _replaceDay(result.data);
        emit(
          state.copyWith(
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
            clearAvailableMeals: true,
            clearSaveFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
    }
  }

  Future<void> _autoSelect(String localeName) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    if (day == null || date.isEmpty || !day.isEditable) return;

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final result = await _autoSelectDayUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      localeName: localeName,
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isSaving: false, clearSaveFailure: true));
        _replaceDay(result.data);
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
    }
  }

  Future<void> _confirmMeals(String localeName) async {
    if (state.isConfirming || state.isSaving) return;

    final day = state.selectedDay;
    final date = _dateParam(day);
    if (day == null || date.isEmpty) return;

    final available = state.availableMeals;
    if (available != null) {
      if (!state.canSaveMeals) return;
      final selectedMeals = available.meals
          .where((meal) => state.localSelectedMealIds.contains(meal.id))
          .toList();
      if (selectedMeals.length != state.localSelectedMealIds.length) return;

      emit(
        state.copyWith(
          isConfirming: true,
          clearConfirmFailure: true,
          clearSaveFailure: true,
        ),
      );

      final saveResult = await _saveDayMealsUseCase(
        subscriptionId: state.subscriptionId,
        date: date,
        meals: selectedMeals,
        localeName: localeName,
      );

      if (isClosed) return;

      switch (saveResult) {
        case ApiSuccessResult():
          _replaceDay(saveResult.data);
        case ApiErrorResult():
          emit(
            state.copyWith(
              isConfirming: false,
              confirmFailure: saveResult.failure,
            ),
          );
          return;
      }
    } else {
      if (!state.canConfirmSelectedDayMeals) return;
      emit(state.copyWith(isConfirming: true, clearConfirmFailure: true));
    }

    final result = await _confirmDayMealsUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      localeName: localeName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final currentMeals = day.meals;
        final confirmedDay = result.data.copyWith(
          meals: result.data.meals.isNotEmpty
              ? result.data.meals
              : currentMeals,
          canEdit: false,
        );
        _replaceDay(confirmedDay);
        emit(
          state.copyWith(
            isConfirming: false,
            confirmSuccessCount: state.confirmSuccessCount + 1,
            clearAvailableMeals: true,
            clearConfirmFailure: true,
          ),
        );
      case ApiErrorResult():
        if (result.failure.code ==
            SubscriptionErrorCodes.calendarSelectionLocked) {
          _replaceDay(day.copyWith(canEdit: false, isLocked: true));
        } else if (result.failure.code ==
            SubscriptionErrorCodes.calendarDayUnavailable) {
          _loadCalendar(
            subscriptionId: state.subscriptionId,
            localeName: localeName,
          );
        }
        emit(
          state.copyWith(isConfirming: false, confirmFailure: result.failure),
        );
    }
  }
}
