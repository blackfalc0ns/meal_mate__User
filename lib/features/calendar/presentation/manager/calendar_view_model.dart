import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';

@injectable
class CalendarViewModel extends Cubit<CalendarState> {
  CalendarViewModel(
    this._getCalendarUseCase,
    this._getCalendarDayUseCase,
    this._getRestaurantsUseCase,
    this._setDayRestaurantUseCase,
    this._getAvailableMealsUseCase,
    this._saveDayMealsUseCase,
    this._autoSelectDayUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
    this._sharedPrefHelper,
  ) : super(const CalendarState());

  final GetCalendarUseCase _getCalendarUseCase;
  final GetCalendarDayUseCase _getCalendarDayUseCase;
  final GetCalendarRestaurantsUseCase _getRestaurantsUseCase;
  final SetCalendarDayRestaurantUseCase _setDayRestaurantUseCase;
  final GetCalendarAvailableMealsUseCase _getAvailableMealsUseCase;
  final SaveCalendarDayMealsUseCase _saveDayMealsUseCase;
  final AutoSelectCalendarDayUseCase _autoSelectDayUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper _sharedPrefHelper;

  void doIntent(CalendarEvent event) {
    switch (event) {
      case LoadCalendarEvent():
        _loadCalendar(
          subscriptionId: event.subscriptionId,
          localeName: event.localeName,
        );
      case SelectCalendarDayEvent():
        _selectDay(day: event.day, localeName: event.localeName);
      case LoadCalendarRestaurantsEvent():
        _loadRestaurants(event.localeName);
      case SelectCalendarRestaurantEvent():
        _selectRestaurant(
          restaurant: event.restaurant,
          localeName: event.localeName,
        );
      case LoadCalendarAvailableMealsEvent():
        _loadAvailableMeals(event.localeName);
      case ToggleCalendarMealEvent():
        _toggleMeal(event.mealId);
      case SaveCalendarDayMealsEvent():
        _saveMeals(event.localeName);
      case AutoSelectCalendarDayEvent():
        _autoSelect(event.localeName);
    }
  }

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
        await _sharedPrefHelper.saveData(
          key: StorageKeys.currentSubscriptionId,
          val: resolvedSubscriptionId,
        );
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
        if (retryWithCurrentOnNotFound && _isNotFound(result.failure)) {
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

  Future<void> _loadRestaurants(String localeName) async {
    final day = state.selectedDay;
    final date = _dateParam(day);
    if (state.subscriptionId.isEmpty || date.isEmpty) return;
    emit(
      state.copyWith(isRestaurantsLoading: true, clearRestaurantsFailure: true),
    );
    final result = await _getRestaurantsUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      localeName: localeName,
    );
    if (isClosed) return;

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

    emit(
      state.copyWith(
        isAvailableMealsLoading: true,
        localSelectedMealIds: const [],
        clearAvailableMeals: true,
        clearAvailableMealsFailure: true,
        clearSaveFailure: true,
      ),
    );
    final result = await _setDayRestaurantUseCase(
      subscriptionId: state.subscriptionId,
      date: date,
      restaurantId: restaurant.id,
      localeName: localeName,
    );
    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        _replaceDay(result.data);
        await _loadAvailableMeals(
          localeName,
          restaurantId: restaurant.id,
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
    if (isClosed) return;

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

  void _selectDay({
    required CalendarDayEntity day,
    required String localeName,
  }) {
    if (day.date == null || !day.hasMeals) return;
    emit(
      state.copyWith(
        selectedDate: day.date,
        localSelectedMealIds: day.selectedMealIds,
        clearRestaurants: true,
        clearAvailableMeals: true,
        clearAvailableMealsFailure: true,
        clearSaveFailure: true,
      ),
    );
    _loadSelectedDayDetailsForDate(day.date!, localeName: localeName);
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
        final completeResult = await _autoSelectDayUseCase(
          subscriptionId: state.subscriptionId,
          date: date,
          localeName: localeName,
        );
        if (isClosed) return;
        if (completeResult case ApiErrorResult()) {
          emit(
            state.copyWith(
              isSaving: false,
              saveFailure: completeResult.failure,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            isSaving: false,
            saveSuccessCount: state.saveSuccessCount + 1,
            clearAvailableMeals: true,
            clearSaveFailure: true,
          ),
        );
        if (completeResult case ApiSuccessResult()) {
          _replaceDay(completeResult.data);
        }
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
        emit(state.copyWith(calendarFailure: result.failure));
    }
  }

  void _replaceDay(CalendarDayEntity updatedDay) {
    if (updatedDay.date == null) return;
    final updatedDays = state.days.map((day) {
      if (day.date == null || !_isSameDay(day.date!, updatedDay.date!)) {
        return day;
      }
      return updatedDay;
    }).toList();
    emit(
      state.copyWith(
        days: updatedDays,
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

  String _dateParam(CalendarDayEntity? day) {
    final date = day?.date;
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
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

    return CalendarAvailableMealsEntity(
      restaurant: CalendarRestaurantEntity(
        id: restaurant?.id.isNotEmpty == true ? restaurant!.id : fallback.id,
        logoUrl: restaurant?.logoUrl?.isNotEmpty == true
            ? restaurant!.logoUrl
            : fallback.logoUrl,
        tierLogoUrl: restaurant?.tierLogoUrl,
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
      meals: availableMeals.meals,
      slotRequirements: availableMeals.slotRequirements,
      coreIngredients: availableMeals.coreIngredients,
    );
  }

  CalendarRestaurantOptionEntity? _restaurantOptionById(String? restaurantId) {
    if (restaurantId == null || restaurantId.isEmpty) return null;
    return state.restaurants
        .where((restaurant) => restaurant.id == restaurantId)
        .firstOrNull;
  }
}
