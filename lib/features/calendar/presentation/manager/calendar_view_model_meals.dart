part of 'calendar_view_model.dart';

mixin CalendarViewModelMeals on Cubit<CalendarState> {
  GetCalendarAvailableMealsUseCase get _getAvailableMealsUseCase;

  int _availableMealsRequestGeneration = 0;
  int _loadMoreRequestGeneration = 0;

  void _invalidateMealsRequests() {
    _availableMealsRequestGeneration++;
    _loadMoreRequestGeneration++;
  }

  Future<void> _loadAvailableMeals(
    String localeName, {
    String? restaurantId,
    CalendarRestaurantOptionEntity? selectedRestaurant,
  }) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    final resolvedRestaurantId = restaurantId ?? day?.restaurantId;
    if (day == null ||
        !day.isEditable ||
        date.isEmpty ||
        resolvedRestaurantId == null ||
        resolvedRestaurantId.isEmpty) {
      return;
    }

    final generation = ++_availableMealsRequestGeneration;
    _loadMoreRequestGeneration++;
    final capturedDate = date;
    final capturedRestaurantId = resolvedRestaurantId;

    emit(
      state.copyWith(
        isAvailableMealsLoading: true,
        clearAvailableMeals: true,
        clearAvailableMealsFailure: true,
        clearSaveFailure: true,
      ),
    );
    final result = await _getAvailableMealsUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      restaurantId: resolvedRestaurantId,
      localeName: localeName,
    );
    if (isClosed ||
        generation != _availableMealsRequestGeneration ||
        _dateParam(state.selectedDay) != capturedDate ||
        (state.selectedDay?.restaurantId != null &&
            state.selectedDay?.restaurantId != capturedRestaurantId)) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final availableMeals = _withRestaurantFallback(
          result.data,
          selectedRestaurant,
        );
        emit(
          state.copyWith(
            isAvailableMealsLoading: false,
            availableMeals: availableMeals,
            localSelectedMealIds: day.selectedMealIds,
            clearAvailableMealsFailure: true,
          ),
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

  Future<void> _loadMoreMeals({
    required String slot,
    required String localeName,
  }) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    final available = state.availableMeals;
    final restaurantId = day?.restaurantId ?? available?.restaurant?.id;
    if (day == null ||
        !day.isEditable ||
        date.isEmpty ||
        restaurantId == null ||
        restaurantId.isEmpty ||
        available == null ||
        state.isLoadingMoreMeals ||
        state.isAvailableMealsLoading) {
      return;
    }

    final currentSlotEntity = available.slots
        .where((s) => s.slot.trim().toLowerCase() == slot.trim().toLowerCase())
        .firstOrNull;
    if (currentSlotEntity == null || !currentSlotEntity.hasNextPage) {
      return;
    }

    final generation = ++_loadMoreRequestGeneration;
    final capturedDate = date;
    final capturedRestaurantId = restaurantId;
    final capturedSlot = currentSlotEntity.slot;

    emit(
      state.copyWith(isLoadingMoreMeals: true, clearLoadMoreMealsFailure: true),
    );

    final nextPage = currentSlotEntity.page + 1;
    final result = await _getAvailableMealsUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      restaurantId: restaurantId,
      localeName: localeName,
      page: nextPage,
      pageSize: currentSlotEntity.pageSize,
      slot: currentSlotEntity.slot,
    );

    if (isClosed ||
        generation != _loadMoreRequestGeneration ||
        _dateParam(state.selectedDay) != capturedDate ||
        state.availableMeals == null ||
        (state.selectedDay?.restaurantId ??
                state.availableMeals?.restaurant?.id) !=
            capturedRestaurantId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        final currentAvailable = state.availableMeals;
        if (currentAvailable == null) return;
        final updatedAvailableMeals = CalendarMealsMerger.mergeMoreMeals(
          current: currentAvailable,
          incoming: result.data,
          requestedSlot: capturedSlot,
        );
        emit(
          state.copyWith(
            isLoadingMoreMeals: false,
            availableMeals: updatedAvailableMeals,
            clearLoadMoreMealsFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingMoreMeals: false,
            loadMoreMealsFailure: result.failure,
          ),
        );
    }
  }

  void _toggleMeal(String mealId) {
    final available = state.availableMeals;
    if (available == null || mealId.isEmpty) return;
    final meal = available.meals.where((item) => item.id == mealId).firstOrNull;
    if (meal == null || meal.blockReason?.isNotEmpty == true) return;

    final selected = List<String>.from(state.localSelectedMealIds);
    if (selected.contains(mealId)) {
      selected.remove(mealId);
      emit(state.copyWith(localSelectedMealIds: selected));
      return;
    }

    final slotLimit = available.slotRequirements
        .where(
          (requirement) =>
              requirement.slot.trim().toLowerCase() ==
              meal.slot.trim().toLowerCase(),
        )
        .firstOrNull
        ?.count;
    if (slotLimit == null || slotLimit <= 0) return;

    final selectedSlotCount = available.meals
        .where(
          (item) =>
              item.slot.trim().toLowerCase() ==
                  meal.slot.trim().toLowerCase() &&
              selected.contains(item.id),
        )
        .length;
    if (selectedSlotCount >= slotLimit) {
      final selectedMealIdsInSlot = available.meals
          .where(
            (item) =>
                item.slot.trim().toLowerCase() ==
                    meal.slot.trim().toLowerCase() &&
                selected.contains(item.id),
          )
          .map((item) => item.id)
          .toSet();
      final mealIdToReplace = selected
          .where(selectedMealIdsInSlot.contains)
          .firstOrNull;
      if (mealIdToReplace == null) return;
      selected.remove(mealIdToReplace);
    }

    selected.add(mealId);
    emit(state.copyWith(localSelectedMealIds: selected));
  }

  CalendarAvailableMealsEntity _withRestaurantFallback(
    CalendarAvailableMealsEntity availableMeals,
    CalendarRestaurantOptionEntity? selectedRestaurant,
  ) {
    final fallback =
        selectedRestaurant ??
        _restaurantOptionById(
          availableMeals.restaurant?.id ?? state.selectedDay?.restaurantId,
        );
    if (fallback == null) return availableMeals;

    final restaurant = availableMeals.restaurant;
    if (restaurant != null && restaurant.logoUrl?.isNotEmpty == true) {
      return availableMeals;
    }

    return availableMeals.copyWith(
      restaurant: CalendarRestaurantEntity(
        id: restaurant?.id.isNotEmpty == true ? restaurant!.id : fallback.id,
        logoUrl: restaurant?.logoUrl?.isNotEmpty == true
            ? restaurant!.logoUrl
            : fallback.logoUrl,
        tierLogoUrl: restaurant?.tierLogoUrl,
        ratingCount: restaurant?.ratingCount ?? fallback.ratingCount,
        maxUsageCount: restaurant?.maxUsageCount ?? fallback.maxUsageCount,
        name: restaurant?.name.isNotEmpty == true
            ? restaurant!.name
            : fallback.name,
        category: restaurant?.category ?? '',
        rating: restaurant?.rating.isNotEmpty == true
            ? restaurant!.rating
            : fallback.rating,
        deliveryDuration: restaurant?.deliveryDuration ?? '',
        deliveryWindow: restaurant?.deliveryWindow ?? '',
      ),
    );
  }

  CalendarRestaurantOptionEntity? _restaurantOptionById(String? restaurantId) {
    if (restaurantId == null || restaurantId.isEmpty) return null;
    return state.restaurants
        .where((restaurant) => restaurant.id == restaurantId)
        .firstOrNull;
  }
}
