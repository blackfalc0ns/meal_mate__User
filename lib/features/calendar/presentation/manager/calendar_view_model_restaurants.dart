part of 'calendar_view_model.dart';

mixin CalendarViewModelRestaurants
    on Cubit<CalendarState>, CalendarViewModelDays, CalendarViewModelMeals {
  GetCalendarRestaurantsUseCase get _getRestaurantsUseCase;
  SetCalendarDayRestaurantUseCase get _setDayRestaurantUseCase;

  int _restaurantRequestGeneration = 0;
  int _setRestaurantRequestGeneration = 0;

  void _invalidateRestaurantRequests() {
    _restaurantRequestGeneration++;
    _setRestaurantRequestGeneration++;
  }

  Future<void> _loadRestaurants(String localeName, {String? query}) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    if (state.subscriptionId.isEmpty || date.isEmpty) return;

    final generation = ++_restaurantRequestGeneration;
    final capturedDate = date;

    emit(
      state.copyWith(isRestaurantsLoading: true, clearRestaurantsFailure: true),
    );
    final result = await _getRestaurantsUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      localeName: localeName,
      query: query,
    );
    if (isClosed ||
        generation != _restaurantRequestGeneration ||
        _dateParam(state.selectedDay) != capturedDate) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isRestaurantsLoading: false,
            restaurants: result.data,
            clearRestaurantsFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isRestaurantsLoading: false,
            restaurantsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _selectRestaurant({
    required CalendarRestaurantOptionEntity restaurant,
    required String localeName,
  }) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    if (day == null ||
        !day.isEditable ||
        date.isEmpty ||
        restaurant.id.isEmpty) {
      return;
    }

    final generation = ++_setRestaurantRequestGeneration;
    _invalidateMealsRequests();
    final capturedDayDate = day.date;
    final capturedRestaurantId = restaurant.id;

    emit(
      state.copyWith(
        isAvailableMealsLoading: true,
        isLoadingMoreMeals: false,
        localSelectedMealIds: const [],
        clearAvailableMeals: true,
        clearAvailableMealsFailure: true,
        clearSaveFailure: true,
        clearLoadMoreMealsFailure: true,
      ),
    );
    final result = await _setDayRestaurantUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      restaurantId: restaurant.id,
      localeName: localeName,
    );
    if (isClosed ||
        generation != _setRestaurantRequestGeneration ||
        capturedDayDate == null ||
        !_isSameSelectedDate(capturedDayDate)) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        _replaceDay(result.data);
        await _loadAvailableMeals(
          localeName,
          restaurantId: capturedRestaurantId,
          selectedRestaurant: restaurant,
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isAvailableMealsLoading: false,
            availableMealsFailure: result.failure,
          ),
        );
    }
  }
}
