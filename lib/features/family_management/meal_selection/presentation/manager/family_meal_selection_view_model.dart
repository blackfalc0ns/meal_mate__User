import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/di/di.dart';
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
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyMealSelectionViewModel extends Cubit<FamilyMealSelectionState> {
  FamilyMealSelectionViewModel({
    required this.calendar,
    String? subscriptionId,
    DateTime? date,
    String? memberName,
    List<FamilyMemberSummaryEntity>? members,
    GetCalendarRestaurantsUseCase? getRestaurantsUseCase,
    GetCalendarAvailableMealsUseCase? getAvailableMealsUseCase,
    SaveCalendarDayMealsUseCase? saveDayMealsUseCase,
    SetCalendarDayRestaurantUseCase? setDayRestaurantUseCase,
    ConfirmCalendarDayMealsUseCase? confirmDayMealsUseCase,
    AutoSelectCalendarDayUseCase? autoSelectDayUseCase,
    GetCalendarDayUseCase? getCalendarDayUseCase,
  }) : _getRestaurantsUseCase =
           getRestaurantsUseCase ??
           (getIt.isRegistered<GetCalendarRestaurantsUseCase>()
               ? getIt<GetCalendarRestaurantsUseCase>()
               : null),
       _getAvailableMealsUseCase =
           getAvailableMealsUseCase ??
           (getIt.isRegistered<GetCalendarAvailableMealsUseCase>()
               ? getIt<GetCalendarAvailableMealsUseCase>()
               : null),
       _saveDayMealsUseCase =
           saveDayMealsUseCase ??
           (getIt.isRegistered<SaveCalendarDayMealsUseCase>()
               ? getIt<SaveCalendarDayMealsUseCase>()
               : null),
       _setDayRestaurantUseCase =
           setDayRestaurantUseCase ??
           (getIt.isRegistered<SetCalendarDayRestaurantUseCase>()
               ? getIt<SetCalendarDayRestaurantUseCase>()
               : null),
       _confirmDayMealsUseCase =
           confirmDayMealsUseCase ??
           (getIt.isRegistered<ConfirmCalendarDayMealsUseCase>()
               ? getIt<ConfirmCalendarDayMealsUseCase>()
               : null),
       _autoSelectDayUseCase =
           autoSelectDayUseCase ??
           (getIt.isRegistered<AutoSelectCalendarDayUseCase>()
               ? getIt<AutoSelectCalendarDayUseCase>()
               : null),
       _getCalendarDayUseCase =
           getCalendarDayUseCase ??
           (getIt.isRegistered<GetCalendarDayUseCase>()
               ? getIt<GetCalendarDayUseCase>()
               : null),
       super(
         FamilyMealSelectionState.fromCalendar(
           calendar.state,
           subscriptionId: subscriptionId,
           date: date,
           memberName: memberName,
           members: members,
         ),
       ) {
    _calendarSubscription = calendar.stream.listen((calendarState) {
      if (isClosed ||
          calendarState.selectedMemberIndex == state.selectedMemberIndex) {
        return;
      }
      emit(FamilyMealSelectionState.fromCalendar(calendarState));
      if (_localeName != null) {
        unawaited(_loadRestaurants(_localeName!));
      }
    });
  }

  final FamilyCalendarViewModel calendar;
  final GetCalendarRestaurantsUseCase? _getRestaurantsUseCase;
  final GetCalendarAvailableMealsUseCase? _getAvailableMealsUseCase;
  final SaveCalendarDayMealsUseCase? _saveDayMealsUseCase;
  final SetCalendarDayRestaurantUseCase? _setDayRestaurantUseCase;
  final ConfirmCalendarDayMealsUseCase? _confirmDayMealsUseCase;
  final AutoSelectCalendarDayUseCase? _autoSelectDayUseCase;
  final GetCalendarDayUseCase? _getCalendarDayUseCase;
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
        if (event.index < 0 ||
            event.index >= state.members.length ||
            event.index == state.selectedMemberIndex) {
          break;
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
        calendar.doIntent(
          SelectFamilyMemberEvent(
            index: event.index,
            localeName: event.localeName,
          ),
        );
        unawaited(_loadRestaurants(event.localeName));
    }
  }

  Future<void> _refreshDayDetails({
    required DateTime date,
    required String subscriptionId,
    required String localeName,
  }) async {
    if (_getCalendarDayUseCase == null) return;
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
      calendar.doIntent(ApplyFamilyCalendarDaySnapshotEvent(result.data));
    }
  }

  void _syncCalendar() {
    final day = state.selectedDay;
    if (day == null) return;
    calendar.doIntent(ApplyFamilyCalendarDaySnapshotEvent(day));
  }

  Future<void> _loadRestaurants(String localeName, {String? query}) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty || _getRestaurantsUseCase == null) {
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
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty || _setDayRestaurantUseCase == null) {
      return;
    }

    emit(state.copyWith(selectedRestaurant: restaurant, isSavingMeals: true));

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
        if (result.failure.exception.statusCode == 403 ||
            result.failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
          await _refreshDayDetails(
            date: date,
            subscriptionId: subId,
            localeName: localeName,
          );
        }
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

    if (subId == null ||
        subId.isEmpty ||
        restaurantId == null ||
        _getAvailableMealsUseCase == null) {
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
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty || _saveDayMealsUseCase == null) {
      return;
    }

    if (state.isSavingMeals) return;
    final saveGeneration = ++_mealSaveGeneration;
    emit(state.copyWith(isSavingMeals: true, clearSaveMealsFailure: true));

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
        if (result.failure.exception.statusCode == 403 ||
            result.failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
        }
        // A later slot can fail after earlier slots were committed. Reload
        // for every failure so successful server-side selections are kept.
        await _refreshDayDetails(
          date: date,
          subscriptionId: subId,
          localeName: localeName,
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
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty) {
      return;
    }

    emit(state.copyWith(isSavingMeals: true, clearSaveMealsFailure: true));

    if (_saveDayMealsUseCase != null && state.selectedMealsForDay.isNotEmpty) {
      final saveResult = await _saveDayMealsUseCase(
        subscriptionId: subId,
        date: formattedDate,
        meals: state.selectedMealsForDay,
        localeName: localeName,
      );
      if (isClosed) return;
      if (saveResult case ApiErrorResult(:final failure)) {
        if (failure.exception.statusCode == 403 ||
            failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
          await _refreshDayDetails(
            date: date,
            subscriptionId: subId,
            localeName: localeName,
          );
        }
        emit(state.copyWith(isSavingMeals: false, saveMealsFailure: failure));
        return;
      }
    }

    if (_confirmDayMealsUseCase != null) {
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
          if (confirmResult.failure.exception.statusCode == 403 ||
              confirmResult.failure.exception.errorType ==
                  ApiErrorType.forbidden) {
            if (getIt.isRegistered<FamilyContextViewModel>()) {
              getIt<FamilyContextViewModel>().loadFamilyContext();
            }
            await _refreshDayDetails(
              date: date,
              subscriptionId: subId,
              localeName: localeName,
            );
          }
          emit(
            state.copyWith(
              isSavingMeals: false,
              saveMealsFailure: confirmResult.failure,
            ),
          );
      }
    } else {
      emit(state.copyWith(isSavingMeals: false, saveMealsSuccess: true));
    }
  }

  Future<void> _autoSelectDayMeals(String localeName) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    if (subId == null || subId.isEmpty || _autoSelectDayUseCase == null) {
      return;
    }

    emit(state.copyWith(isSavingMeals: true, clearSaveMealsFailure: true));

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
        if (result.failure.exception.statusCode == 403 ||
            result.failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
          await _refreshDayDetails(
            date: date,
            subscriptionId: subId,
            localeName: localeName,
          );
        }
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: result.failure,
          ),
        );
    }
  }
}
