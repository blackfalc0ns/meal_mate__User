import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_meals_merger.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/meal_selection/meal_selection_state.dart';

@injectable
class MealSelectionViewModel extends Cubit<MealSelectionState> {
  MealSelectionViewModel(
    this._getAvailableMealsUseCase,
    this._saveDayMealsUseCase,
    this._autoSelectDayUseCase,
    this._confirmDayMealsUseCase,
  ) : super(const MealSelectionState());

  final GetCalendarAvailableMealsUseCase _getAvailableMealsUseCase;
  final SaveCalendarDayMealsUseCase _saveDayMealsUseCase;
  final AutoSelectCalendarDayUseCase _autoSelectDayUseCase;
  final ConfirmCalendarDayMealsUseCase _confirmDayMealsUseCase;

  int _mealsRequestGeneration = 0;
  int _loadMoreRequestGeneration = 0;

  void doIntent(MealSelectionEvent event) {
    switch (event) {
      case LoadMealsEvent():
        unawaited(
          load(
            subscriptionId: event.subscriptionId,
            date: event.date,
            restaurantId: event.restaurantId,
            localeName: event.localeName,
            initialSelectedMealIds: event.initialSelectedMealIds,
          ),
        );
      case ToggleMealEvent():
        toggleMeal(event.mealId);
      case LoadMoreMealsEvent():
        unawaited(loadMore(slot: event.slot, localeName: event.localeName));
      case SaveMealsEvent():
        unawaited(save(localeName: event.localeName));
      case AutoSelectMealsEvent():
        unawaited(autoSelect(localeName: event.localeName));
      case ConfirmMealsEvent():
        unawaited(confirm(localeName: event.localeName));
      case ClearMealSelectionEvent():
        clear();
    }
  }

  Future<void> load({
    required String subscriptionId,
    required DateTime date,
    required String restaurantId,
    required String localeName,
    List<String> initialSelectedMealIds = const [],
    CalendarRestaurantOptionEntity? selectedRestaurant,
  }) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (subscriptionId.isEmpty || dateStr.isEmpty || restaurantId.isEmpty) {
      return;
    }

    final generation = ++_mealsRequestGeneration;
    _loadMoreRequestGeneration++;
    final capturedRestaurantId = restaurantId;

    emit(
      state.copyWith(
        subscriptionId: subscriptionId,
        date: date,
        restaurantId: restaurantId,
        selectedMealIds: initialSelectedMealIds,
        isLoading: true,
        clearAvailableMeals: true,
        clearFailure: true,
        clearSaveFailure: true,
        clearConfirmFailure: true,
      ),
    );

    final result = await _getAvailableMealsUseCase(
      subscriptionId: subscriptionId,
      date: dateStr,
      restaurantId: restaurantId,
      localeName: localeName,
    );

    if (isClosed ||
        generation != _mealsRequestGeneration ||
        state.restaurantId != capturedRestaurantId) {
      return;
    }

    switch (result) {
      case ApiSuccessResult():
        if (result.data.meals.isEmpty) {
          emit(
            state.copyWith(
              isLoading: false,
              clearAvailableMeals: true,
              failure: Failure(
                code: SubscriptionErrorCodes.calendarBoxNotReady,
                errorMessage: SubscriptionErrorCodes.calendarBoxNotReady,
              ),
            ),
          );
          return;
        }
        final availableMeals = _withRestaurantFallback(
          result.data,
          selectedRestaurant,
        );
        emit(
          state.copyWith(
            isLoading: false,
            availableMeals: availableMeals,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  void toggleMeal(String mealId) {
    final available = state.availableMeals;
    if (available == null || mealId.isEmpty) return;
    final meal = available.meals.where((item) => item.id == mealId).firstOrNull;
    if (meal == null || meal.blockReason?.isNotEmpty == true) return;

    final selected = List<String>.from(state.selectedMealIds);
    if (selected.contains(mealId)) {
      selected.remove(mealId);
      emit(state.copyWith(selectedMealIds: selected));
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
    emit(state.copyWith(selectedMealIds: selected));
  }

  Future<void> loadMore({
    required String slot,
    required String localeName,
  }) async {
    final available = state.availableMeals;
    final date = state.date;
    final restaurantId = state.restaurantId;
    if (available == null ||
        date == null ||
        restaurantId.isEmpty ||
        state.isLoadingMore ||
        state.isLoading) {
      return;
    }

    final currentSlotEntity = available.slots
        .where((s) => s.slot.trim().toLowerCase() == slot.trim().toLowerCase())
        .firstOrNull;
    if (currentSlotEntity == null || !currentSlotEntity.hasNextPage) {
      return;
    }

    final generation = ++_loadMoreRequestGeneration;
    final capturedSlot = currentSlotEntity.slot;
    final capturedRestaurantId = restaurantId;

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreFailure: true));

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final nextPage = currentSlotEntity.page + 1;
    final result = await _getAvailableMealsUseCase(
      subscriptionId: state.subscriptionId,
      date: dateStr,
      restaurantId: restaurantId,
      localeName: localeName,
      page: nextPage,
      pageSize: currentSlotEntity.pageSize,
      slot: currentSlotEntity.slot,
    );

    if (isClosed ||
        generation != _loadMoreRequestGeneration ||
        state.availableMeals == null ||
        state.restaurantId != capturedRestaurantId) {
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
            isLoadingMore: false,
            availableMeals: updatedAvailableMeals,
            clearLoadMoreFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isLoadingMore: false, loadMoreFailure: result.failure),
        );
    }
  }

  Future<ApiResult<CalendarDayEntity>> save({
    required String localeName,
  }) async {
    final date = state.date;
    final available = state.availableMeals;
    if (date == null ||
        available == null ||
        state.isSaving ||
        state.isConfirming ||
        !state.canSave) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Cannot save meals',
          code: 'cannot_save',
        ),
      );
    }

    final selectedMeals = available.meals
        .where((meal) => state.selectedMealIds.contains(meal.id))
        .toList();
    if (selectedMeals.length != state.selectedMealIds.length) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Some selected meals are not found',
          code: 'invalid_selection',
        ),
      );
    }

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final result = await _saveDayMealsUseCase(
      subscriptionId: state.subscriptionId,
      date: dateStr,
      meals: selectedMeals,
      localeName: localeName,
    );

    if (isClosed) return result;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isSaving: false, clearSaveFailure: true));
        return result;
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
        return result;
    }
  }

  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String localeName,
    DateTime? date,
    String? subscriptionId,
  }) async {
    final targetDate = date ?? state.date;
    final targetSubId = (subscriptionId != null && subscriptionId.isNotEmpty)
        ? subscriptionId
        : state.subscriptionId;
    if (targetDate == null ||
        targetSubId.isEmpty ||
        state.isSaving ||
        state.isConfirming) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Invalid state for auto-select',
          code: 'invalid_state',
        ),
      );
    }

    emit(state.copyWith(isSaving: true, clearSaveFailure: true));
    final dateStr = DateFormat('yyyy-MM-dd').format(targetDate);
    final result = await _autoSelectDayUseCase(
      subscriptionId: targetSubId,
      date: dateStr,
      localeName: localeName,
    );

    if (isClosed) return result;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isSaving: false, clearSaveFailure: true));
        return result;
      case ApiErrorResult():
        emit(state.copyWith(isSaving: false, saveFailure: result.failure));
        return result;
    }
  }

  Future<ApiResult<CalendarDayEntity>> confirm({
    required String localeName,
    DateTime? date,
    String? subscriptionId,
  }) async {
    final targetDate = date ?? state.date;
    final targetSubId = (subscriptionId != null && subscriptionId.isNotEmpty)
        ? subscriptionId
        : state.subscriptionId;
    if (targetDate == null ||
        targetSubId.isEmpty ||
        state.isSaving ||
        state.isConfirming) {
      return ApiErrorResult(
        failure: Failure(
          errorMessage: 'Cannot confirm in current state',
          code: 'invalid_state',
        ),
      );
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(targetDate);
    final available = state.availableMeals;
    if (available != null) {
      if (!state.canSave) {
        return ApiErrorResult(
          failure: Failure(
            errorMessage: 'Cannot confirm incomplete box',
            code: SubscriptionErrorCodes.calendarBoxIncomplete,
          ),
        );
      }

      final selectedMeals = available.meals
          .where((meal) => state.selectedMealIds.contains(meal.id))
          .toList();
      if (selectedMeals.length != state.selectedMealIds.length) {
        return ApiErrorResult(
          failure: Failure(
            errorMessage: 'Some selected meals are not found',
            code: 'invalid_selection',
          ),
        );
      }

      emit(
        state.copyWith(
          isConfirming: true,
          clearConfirmFailure: true,
          clearSaveFailure: true,
        ),
      );

      final saveResult = await _saveDayMealsUseCase(
        subscriptionId: targetSubId,
        date: dateStr,
        meals: selectedMeals,
        localeName: localeName,
      );

      if (isClosed) return saveResult;

      if (saveResult is ApiErrorResult<CalendarDayEntity>) {
        emit(
          state.copyWith(
            isConfirming: false,
            confirmFailure: saveResult.failure,
          ),
        );
        return saveResult;
      }
    } else {
      emit(state.copyWith(isConfirming: true, clearConfirmFailure: true));
    }

    final result = await _confirmDayMealsUseCase(
      subscriptionId: targetSubId,
      date: dateStr,
      localeName: localeName,
    );

    if (isClosed) return result;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isConfirming: false, clearConfirmFailure: true));
        return result;
      case ApiErrorResult():
        emit(
          state.copyWith(isConfirming: false, confirmFailure: result.failure),
        );
        return result;
    }
  }

  void clear() {
    _mealsRequestGeneration++;
    _loadMoreRequestGeneration++;
    emit(const MealSelectionState());
  }

  CalendarAvailableMealsEntity _withRestaurantFallback(
    CalendarAvailableMealsEntity availableMeals,
    CalendarRestaurantOptionEntity? selectedRestaurant,
  ) {
    if (selectedRestaurant == null) return availableMeals;

    final restaurant = availableMeals.restaurant;
    if (restaurant != null && restaurant.logoUrl?.isNotEmpty == true) {
      return availableMeals;
    }

    return availableMeals.copyWith(
      restaurant: CalendarRestaurantEntity(
        id: restaurant?.id.isNotEmpty == true
            ? restaurant!.id
            : selectedRestaurant.id,
        logoUrl: restaurant?.logoUrl?.isNotEmpty == true
            ? restaurant!.logoUrl
            : selectedRestaurant.logoUrl,
        tierLogoUrl: restaurant?.tierLogoUrl,
        ratingCount: restaurant?.ratingCount ?? selectedRestaurant.ratingCount,
        maxUsageCount:
            restaurant?.maxUsageCount ?? selectedRestaurant.maxUsageCount,
        name: restaurant?.name.isNotEmpty == true
            ? restaurant!.name
            : selectedRestaurant.name,
        category: restaurant?.category ?? '',
        rating: restaurant?.rating?.isNotEmpty == true
            ? restaurant!.rating
            : selectedRestaurant.rating,
        deliveryDuration: restaurant?.deliveryDuration ?? '',
        deliveryWindow: restaurant?.deliveryWindow ?? '',
      ),
    );
  }
}
