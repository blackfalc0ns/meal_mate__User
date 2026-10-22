import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_event.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_state.dart';

@injectable
class FamilyMealSelectionViewModel extends Cubit<FamilyMealSelectionState> {
  FamilyMealSelectionViewModel(
    this._getRestaurantsUseCase,
    this._getAvailableMealsUseCase,
    this._saveDayMealsUseCase,
    this._setDayRestaurantUseCase,
    this._confirmDayMealsUseCase,
    this._autoSelectDayUseCase,
    this._getCalendarDayUseCase,
    this._familyContext, {
    @factoryParam required this.calendar,
    @factoryParam FamilyMealSelectionState? initialState,
  }) : super(
         initialState ?? FamilyMealSelectionState.fromCalendar(calendar.state),
       ) {
    _calendarSubscription = calendar.stream.listen((calendarState) {
      if (isClosed) return;
      if (calendarState.selectedMemberIndex == state.selectedMemberIndex) {
        if (!identical(
          calendarState.currentUserCapabilities,
          state.currentUserCapabilities,
        )) {
          emit(
            state.copyWith(
              currentUserCapabilities: calendarState.currentUserCapabilities,
            ),
          );
        }
        return;
      }
      emit(FamilyMealSelectionState.fromCalendar(calendarState));
      if (_localeName != null) {
        unawaited(_loadRestaurants(_localeName!));
      }
    });
  }

  final FamilyCalendarViewModel calendar;
  final GetCalendarRestaurantsUseCase _getRestaurantsUseCase;
  final GetCalendarAvailableMealsUseCase _getAvailableMealsUseCase;
  final SaveCalendarDayMealsUseCase _saveDayMealsUseCase;
  final SetCalendarDayRestaurantUseCase _setDayRestaurantUseCase;
  final ConfirmCalendarDayMealsUseCase _confirmDayMealsUseCase;
  final AutoSelectCalendarDayUseCase _autoSelectDayUseCase;
  final GetCalendarDayUseCase _getCalendarDayUseCase;
  final FamilyContextViewModel _familyContext;
  int _mealSaveGeneration = 0;
  late final StreamSubscription<FamilyCalendarState> _calendarSubscription;
  String? _localeName;

  @override
  Future<void> close() async {
    await _calendarSubscription.cancel();
    await super.close();
  }

  void doIntent(FamilyMealSelectionEvent event) {
    switch (event) {
      case LoadFamilyRestaurantsEvent():
        _localeName = event.localeName;
        unawaited(_loadRestaurants(event.localeName, query: event.query));
      case SelectFamilyRestaurantEvent():
        unawaited(_selectRestaurant(event.restaurant, event.localeName));
      case LoadFamilyAvailableMealsEvent():
        unawaited(
          _loadAvailableMeals(
            event.localeName,
            slot: event.slot,
            page: event.page,
          ),
        );
      case SelectFamilyMealCategoryEvent():
        _selectMealCategory(event);
      case SelectMealForSlotEvent():
        _selectMealForSlot(event.meal, event.slot);
      case SaveFamilyDayMealsEvent():
        unawaited(_saveDayMeals(event.localeName));
      case ConfirmFamilyDayMealsEvent():
        unawaited(_confirmDayMeals(event.localeName));
      case AutoSelectFamilyDayMealsEvent():
        unawaited(_autoSelectDayMeals(event.localeName));
      case SelectMealSelectionMemberEvent():
        _selectMember(event);
    }
  }

  void _selectMember(SelectMealSelectionMemberEvent event) {
    if (event.index < 0 ||
        event.index >= state.members.length ||
        event.index == state.selectedMemberIndex) {
      return;
    }
    final member = state.members[event.index];
    emit(
      state.copyWith(
        selectedMemberIndex: event.index,
        currentSubscriptionId: member.effectiveSubscriptionId ?? '',
        currentMemberName: member.displayName,
        selectedMealsForDay: const [],
        clearSelectedRestaurant: true,
        clearAvailableMeals: true,
      ),
    );
    unawaited(
      calendar.doIntent(
        SelectFamilyMemberEvent(
          index: event.index,
          localeName: event.localeName,
        ),
      ),
    );
    unawaited(_loadRestaurants(event.localeName));
  }

  Future<void> _recoverOperationFailure(
    Failure failure, {
    required DateTime date,
    required String subscriptionId,
    required String localeName,
    bool refreshDay = false,
  }) async {
    final isForbidden =
        failure.exception.statusCode == 403 ||
        failure.exception.errorType == ApiErrorType.forbidden;
    if (isForbidden) _familyContext.loadFamilyContext();
    if (refreshDay || isForbidden) {
      await _refreshDayDetails(
        date: date,
        subscriptionId: subscriptionId,
        localeName: localeName,
      );
    }
  }

  Future<void> _refreshDayDetails({
    required DateTime date,
    required String subscriptionId,
    required String localeName,
  }) async {
    final result = await _getCalendarDayUseCase(
      subscriptionId: subscriptionId,
      date: intl.DateFormat('yyyy-MM-dd').format(date),
      localeName: localeName,
    );
    if (isClosed) return;
    if (result case ApiSuccessResult()) {
      emit(
        state.copyWith(
          selectedDay: result.data,
          selectedMealsForDay: result.data.meals,
        ),
      );
      unawaited(
        calendar.doIntent(ApplyFamilyCalendarDaySnapshotEvent(result.data)),
      );
    }
  }

  void _syncCalendar() {
    final day = state.selectedDay;
    if (day == null) return;
    unawaited(calendar.doIntent(ApplyFamilyCalendarDaySnapshotEvent(day)));
  }

  Future<void> _loadRestaurants(String localeName, {String? query}) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty) {
      return;
    }

    emit(
      state.copyWith(isLoadingRestaurants: true, clearRestaurantsFailure: true),
    );

    final result = await _getRestaurantsUseCase(
      subscriptionId: subId,
      date: formattedDate,
      localeName: localeName,
      query: query,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            restaurants: result.data.restaurants,
            filteredRestaurants: result.data.restaurants,
            isLoadingRestaurants: false,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingRestaurants: false,
            restaurantsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _selectRestaurant(
    CalendarRestaurantOptionEntity restaurant,
    String localeName,
  ) async {
    if (calendar.state.selectedDay?.isEditable != true) return;
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        selectedRestaurant: restaurant,
        isSavingMeals: true,
        saveMealsSuccess: false,
        clearSaveMealsFailure: true,
      ),
    );

    final result = await _setDayRestaurantUseCase(
      subscriptionId: subId,
      date: formattedDate,
      restaurantId: restaurant.id,
      localeName: localeName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(selectedDay: result.data, isSavingMeals: false));
        await _loadAvailableMeals(localeName);
      case ApiErrorResult():
        await _recoverOperationFailure(
          result.failure,
          date: date,
          subscriptionId: subId,
          localeName: localeName,
        );
        if (isClosed) return;
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: result.failure,
            availableMealsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadAvailableMeals(
    String localeName, {
    String? slot,
    int? page,
  }) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);
    final restaurantId =
        state.selectedDay?.restaurantId ?? state.selectedRestaurant?.id;

    if (subId == null || subId.isEmpty || restaurantId == null) {
      return;
    }

    emit(
      state.copyWith(
        isLoadingAvailableMeals: true,
        clearAvailableMealsFailure: true,
      ),
    );

    final result = await _getAvailableMealsUseCase(
      subscriptionId: subId,
      date: formattedDate,
      restaurantId: restaurantId,
      localeName: localeName,
      slot: slot,
      page: page,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final selectedFromBackend = result.data.meals
            .where((meal) => meal.selected)
            .toList();
        emit(
          state.copyWith(
            availableMeals: result.data,
            selectedMealsForDay: selectedFromBackend.isNotEmpty
                ? selectedFromBackend
                : state.selectedMealsForDay,
            isLoadingAvailableMeals: false,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingAvailableMeals: false,
            availableMealsFailure: result.failure,
          ),
        );
    }
  }

  void _selectMealCategory(SelectFamilyMealCategoryEvent event) {
    emit(state.copyWith(selectedCategoryIndex: event.index));
    final slot = switch (event.index) {
      1 => 'breakfast',
      2 => 'lunch',
      3 => 'dinner',
      4 => 'snack',
      _ => null,
    };
    unawaited(_loadAvailableMeals(event.localeName, slot: slot));
  }

  void _selectMealForSlot(CalendarMealEntity meal, String slot) {
    if (state.isSavingMeals) return;
    final currentMeals = List<CalendarMealEntity>.from(
      state.selectedMealsForDay,
    );
    if (currentMeals.any((m) => m.id == meal.id)) {
      currentMeals.removeWhere((m) => m.id == meal.id);
    } else {
      final requiredForSlot = state.availableMeals?.slotRequirements
          .where((requirement) => requirement.slot == slot)
          .firstOrNull
          ?.count;
      final selectedInSlot = currentMeals.where((m) => m.slot == slot).length;
      if (requiredForSlot != null && selectedInSlot >= requiredForSlot) return;
      currentMeals.add(meal);
    }

    emit(state.copyWith(selectedMealsForDay: currentMeals));
  }

  Future<void> _saveDayMeals(String localeName) async {
    if (calendar.state.selectedDay?.isEditable != true) return;
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty) {
      return;
    }

    if (state.isSavingMeals) return;
    final saveGeneration = ++_mealSaveGeneration;
    emit(
      state.copyWith(
        isSavingMeals: true,
        saveMealsSuccess: false,
        clearSaveMealsFailure: true,
      ),
    );

    final result = await _saveDayMealsUseCase(
      subscriptionId: subId,
      date: formattedDate,
      meals: state.selectedMealsForDay,
      localeName: localeName,
    );

    if (isClosed || saveGeneration != _mealSaveGeneration) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            selectedDay: result.data,
            selectedMealsForDay: result.data.meals,
            isSavingMeals: false,
            saveMealsSuccess: true,
          ),
        );
        _syncCalendar();
      case ApiErrorResult():
        await _recoverOperationFailure(
          result.failure,
          date: date,
          subscriptionId: subId,
          localeName: localeName,
          refreshDay: true,
        );
        if (isClosed || saveGeneration != _mealSaveGeneration) return;
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _confirmDayMeals(String localeName) async {
    if (calendar.state.selectedDay?.isEditable != true) return;
    if (state.isSavingMeals) return;
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        isSavingMeals: true,
        saveMealsSuccess: false,
        clearSaveMealsFailure: true,
      ),
    );

    if (state.selectedMealsForDay.isNotEmpty) {
      final saveResult = await _saveDayMealsUseCase(
        subscriptionId: subId,
        date: formattedDate,
        meals: state.selectedMealsForDay,
        localeName: localeName,
      );
      if (isClosed) return;
      if (saveResult case ApiErrorResult(:final failure)) {
        await _recoverOperationFailure(
          failure,
          date: date,
          subscriptionId: subId,
          localeName: localeName,
        );
        if (isClosed) return;
        emit(state.copyWith(isSavingMeals: false, saveMealsFailure: failure));
        return;
      }
    }

    final confirmResult = await _confirmDayMealsUseCase(
      subscriptionId: subId,
      date: formattedDate,
      localeName: localeName,
    );
    if (isClosed) return;

    switch (confirmResult) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            selectedDay: confirmResult.data,
            isSavingMeals: false,
            saveMealsSuccess: true,
          ),
        );
        _syncCalendar();
      case ApiErrorResult():
        await _recoverOperationFailure(
          confirmResult.failure,
          date: date,
          subscriptionId: subId,
          localeName: localeName,
        );
        if (isClosed) return;
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: confirmResult.failure,
          ),
        );
    }
  }

  Future<void> _autoSelectDayMeals(String localeName) async {
    if (calendar.state.selectedDay?.isEditable != true) return;
    if (state.isSavingMeals) return;
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        isSavingMeals: true,
        saveMealsSuccess: false,
        clearSaveMealsFailure: true,
      ),
    );

    final result = await _autoSelectDayUseCase(
      subscriptionId: subId,
      date: formattedDate,
      localeName: localeName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            selectedDay: result.data,
            selectedMealsForDay: result.data.meals,
            isSavingMeals: false,
          ),
        );
        _syncCalendar();
      case ApiErrorResult():
        await _recoverOperationFailure(
          result.failure,
          date: date,
          subscriptionId: subId,
          localeName: localeName,
        );
        if (isClosed) return;
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: result.failure,
          ),
        );
    }
  }
}
