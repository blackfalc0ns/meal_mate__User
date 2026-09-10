import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_members_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_calendar_state.dart';

@injectable
class FamilyCalendarViewModel extends Cubit<FamilyCalendarState> {
  FamilyCalendarViewModel([
    GetFamilyMembersUseCase? getMembersUseCase,
    GetCalendarUseCase? getCalendarUseCase,
    GetCalendarDayUseCase? getCalendarDayUseCase,
    GetCalendarRestaurantsUseCase? getRestaurantsUseCase,
    GetCalendarAvailableMealsUseCase? getAvailableMealsUseCase,
    SaveCalendarDayMealsUseCase? saveDayMealsUseCase,
    SetCalendarDayRestaurantUseCase? setDayRestaurantUseCase,
  ]) : _getMembersUseCase =
           getMembersUseCase ??
           (getIt.isRegistered<GetFamilyMembersUseCase>()
               ? getIt<GetFamilyMembersUseCase>()
               : null),
       _getCalendarUseCase =
           getCalendarUseCase ??
           (getIt.isRegistered<GetCalendarUseCase>()
               ? getIt<GetCalendarUseCase>()
               : null),
       _getCalendarDayUseCase =
           getCalendarDayUseCase ??
           (getIt.isRegistered<GetCalendarDayUseCase>()
               ? getIt<GetCalendarDayUseCase>()
               : null),
       _getRestaurantsUseCase =
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
       super(const FamilyCalendarState());

  final GetFamilyMembersUseCase? _getMembersUseCase;
  final GetCalendarUseCase? _getCalendarUseCase;
  final GetCalendarDayUseCase? _getCalendarDayUseCase;
  final GetCalendarRestaurantsUseCase? _getRestaurantsUseCase;
  final GetCalendarAvailableMealsUseCase? _getAvailableMealsUseCase;
  final SaveCalendarDayMealsUseCase? _saveDayMealsUseCase;
  final SetCalendarDayRestaurantUseCase? _setDayRestaurantUseCase;

  void doIntent(FamilyCalendarEvent event) {
    switch (event) {
      case InitFamilyCalendarEvent():
        _init(event);
      case SelectFamilyMemberEvent():
        _selectMember(event.index, event.localeName);
      case SelectFamilyCalendarDayEvent():
        _selectDay(event.day, event.localeName);
      case ChangeFamilyCalendarMonthEvent():
        _changeMonth(event.months);
      case RetryFamilyCalendarEvent():
        _retry(event.localeName);
      case LoadFamilyRestaurantsEvent():
        _loadRestaurants(event.localeName, query: event.query);
      case SelectFamilyRestaurantEvent():
        _selectRestaurant(event.restaurant, event.localeName);
      case LoadFamilyAvailableMealsEvent():
        _loadAvailableMeals(
          event.localeName,
          slot: event.slot,
          page: event.page,
        );
      case SelectFamilyMealCategoryEvent():
        _selectMealCategory(event);
      case SelectMealForSlotEvent():
        _selectMealForSlot(event.meal, event.slot);
      case SaveFamilyDayMealsEvent():
        _saveDayMeals(event.localeName);
    }
  }

  Future<void> _init(InitFamilyCalendarEvent event) async {
    final initialDate = event.initialDate ?? event.args?.date ?? DateTime.now();
    final visibleMonth = DateTime(initialDate.year, initialDate.month);

    List<FamilyMemberSummaryEntity> members = [];
    if (event.args?.members.isNotEmpty == true) {
      members = List.of(event.args!.members);
    }

    int selectedIndex = 0;
    if (members.isNotEmpty) {
      selectedIndex = _findMemberIndex(
        members,
        memberId: event.args?.memberId,
        subscriptionId: event.args?.subscriptionId,
      );
    }

    emit(
      state.copyWith(
        members: members,
        selectedMemberIndex: selectedIndex,
        currentSubscriptionId: event.args?.subscriptionId,
        currentMemberName: event.args?.displayName,
        visibleMonth: visibleMonth,
        selectedDate: initialDate,
        clearCalendarFailure: true,
        clearDayFailure: true,
      ),
    );

    if (members.isEmpty) {
      if (_getMembersUseCase == null) return;
      emit(state.copyWith(isLoadingMembers: true));
      final membersResult = await _getMembersUseCase(event.localeName);
      if (isClosed) return;

      if (membersResult case ApiSuccessResult(:final data)) {
        members = data;
        if (members.isNotEmpty) {
          selectedIndex = _findMemberIndex(
            members,
            memberId: event.args?.memberId,
            subscriptionId: event.args?.subscriptionId,
          );
        }
        emit(
          state.copyWith(
            members: members,
            selectedMemberIndex: selectedIndex,
            isLoadingMembers: false,
          ),
        );
      } else if (membersResult case ApiErrorResult(:final failure)) {
        emit(state.copyWith(isLoadingMembers: false, calendarFailure: failure));
      }
    }

    await _loadCalendarForActiveMember(event.localeName);
  }

  int _findMemberIndex(
    List<FamilyMemberSummaryEntity> members, {
    String? memberId,
    String? subscriptionId,
  }) {
    if (members.isEmpty) return 0;
    final foundIndex = members.indexWhere((m) {
      if (memberId != null && memberId.isNotEmpty && m.memberId == memberId) {
        return true;
      }
      if (subscriptionId != null &&
          subscriptionId.isNotEmpty &&
          m.subscriptionId == subscriptionId) {
        return true;
      }
      return false;
    });
    return foundIndex >= 0 ? foundIndex : 0;
  }

  Future<void> _selectMember(int index, String localeName) async {
    if (index < 0 || index >= state.members.length) return;
    if (index == state.selectedMemberIndex) return;

    final selectedMember = state.members[index];
    emit(
      state.copyWith(
        selectedMemberIndex: index,
        currentSubscriptionId: selectedMember.subscriptionId,
        currentMemberName: selectedMember.displayName,
        clearCalendarFailure: true,
        clearDayFailure: true,
      ),
    );

    await _loadCalendarForActiveMember(localeName);
  }

  Future<void> _loadCalendarForActiveMember(String localeName) async {
    final subId = state.activeSubscriptionId;
    if (subId == null || subId.isEmpty || _getCalendarUseCase == null) {
      return;
    }

    emit(state.copyWith(isLoadingCalendar: true, clearCalendarFailure: true));

    final result = await _getCalendarUseCase(
      subscriptionId: subId,
      localeName: localeName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final targetDate = state.selectedDate ?? DateTime.now();
        CalendarDayEntity? matchedSelectedDay;

        final mappedDays = result.data.days.map((day) {
          final isSelected =
              day.date != null &&
              day.date!.year == targetDate.year &&
              day.date!.month == targetDate.month &&
              day.date!.day == targetDate.day;

          final updatedDay = day.copyWith(isSelected: isSelected);
          if (isSelected) {
            matchedSelectedDay = updatedDay;
          }
          return updatedDay;
        }).toList();

        emit(
          state.copyWith(
            days: mappedDays,
            selectedDay: matchedSelectedDay ?? state.selectedDay,
            isLoadingCalendar: false,
          ),
        );

        await _fetchDayDetails(
          date: targetDate,
          subscriptionId: subId,
          localeName: localeName,
        );

      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingCalendar: false,
            calendarFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _selectDay(CalendarDayEntity day, String localeName) async {
    final newDate = day.date;
    if (newDate == null) return;

    final updatedDays = state.days.map((d) {
      final isSelected =
          d.date != null &&
          d.date!.year == newDate.year &&
          d.date!.month == newDate.month &&
          d.date!.day == newDate.day;
      return d.copyWith(isSelected: isSelected);
    }).toList();

    DateTime? newVisibleMonth = state.visibleMonth;
    if (newVisibleMonth != null &&
        (newVisibleMonth.year != newDate.year ||
            newVisibleMonth.month != newDate.month)) {
      newVisibleMonth = DateTime(newDate.year, newDate.month);
    }

    emit(
      state.copyWith(
        selectedDate: newDate,
        visibleMonth: newVisibleMonth,
        selectedDay: day.copyWith(isSelected: true),
        days: updatedDays,
      ),
    );

    final subId = state.activeSubscriptionId;
    if (subId != null && subId.isNotEmpty) {
      await _fetchDayDetails(
        date: newDate,
        subscriptionId: subId,
        localeName: localeName,
      );
    }
  }

  Future<void> _fetchDayDetails({
    required DateTime date,
    required String subscriptionId,
    required String localeName,
  }) async {
    if (_getCalendarDayUseCase == null) return;
    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);
    emit(state.copyWith(isLoadingDay: true, clearDayFailure: true));

    final result = await _getCalendarDayUseCase(
      subscriptionId: subscriptionId,
      date: formattedDate,
      localeName: localeName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final dayWithSelection = result.data.copyWith(isSelected: true);
        final updatedDays = state.days.map((d) {
          if (d.date != null &&
              d.date!.year == date.year &&
              d.date!.month == date.month &&
              d.date!.day == date.day) {
            return dayWithSelection;
          }
          return d;
        }).toList();

        emit(
          state.copyWith(
            selectedDay: dayWithSelection,
            selectedMealsForDay: dayWithSelection.meals,
            hasInitializedMealSelection: true,
            days: updatedDays,
            isLoadingDay: false,
          ),
        );

      case ApiErrorResult():
        emit(state.copyWith(isLoadingDay: false, dayFailure: result.failure));
    }
  }

  void _changeMonth(int months) {
    final currentMonth = state.visibleMonth ?? DateTime.now();
    emit(
      state.copyWith(
        visibleMonth: DateTime(currentMonth.year, currentMonth.month + months),
      ),
    );
  }

  Future<void> _retry(String localeName) async {
    if (state.members.isEmpty) {
      if (_getMembersUseCase == null) return;
      emit(state.copyWith(isLoadingMembers: true, clearCalendarFailure: true));
      final membersResult = await _getMembersUseCase(localeName);
      if (isClosed) return;

      if (membersResult case ApiSuccessResult(:final data)) {
        emit(state.copyWith(members: data, isLoadingMembers: false));
      } else if (membersResult case ApiErrorResult(:final failure)) {
        emit(state.copyWith(isLoadingMembers: false, calendarFailure: failure));
        return;
      }
    }

    await _loadCalendarForActiveMember(localeName);
  }

  // --- Restaurant & Meal Selection Operations ---

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
            restaurants: result.data,
            filteredRestaurants: result.data,
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
    final isRestaurantAlreadySet =
        state.selectedDay?.restaurantId == restaurant.id;
    emit(
      state.copyWith(
        selectedRestaurant: restaurant,
        selectedMealsForDay: isRestaurantAlreadySet
            ? state.selectedMealsForDay
            : const [],
        hasInitializedMealSelection:
            isRestaurantAlreadySet && state.hasInitializedMealSelection,
        isLoadingAvailableMeals: true,
        clearAvailableMeals: true,
        clearAvailableMealsFailure: true,
      ),
    );

    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    if (!isRestaurantAlreadySet) {
      if (subId == null ||
          subId.isEmpty ||
          restaurant.id.isEmpty ||
          _setDayRestaurantUseCase == null) {
        emit(state.copyWith(isLoadingAvailableMeals: false));
        return;
      }

      final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);
      final setRestaurantResult = await _setDayRestaurantUseCase(
        subscriptionId: subId,
        date: formattedDate,
        restaurantId: restaurant.id,
        localeName: localeName,
      );

      if (isClosed) return;

      switch (setRestaurantResult) {
        case ApiSuccessResult():
          final updatedDay = setRestaurantResult.data.copyWith(
            isSelected: true,
          );
          final updatedDays = state.days.map((day) {
            if (day.date != null &&
                day.date!.year == date.year &&
                day.date!.month == date.month &&
                day.date!.day == date.day) {
              return updatedDay;
            }
            return day;
          }).toList();
          emit(state.copyWith(selectedDay: updatedDay, days: updatedDays));
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoadingAvailableMeals: false,
              availableMealsFailure: setRestaurantResult.failure,
            ),
          );
          return;
      }
    }

    await _loadAvailableMeals(localeName);
  }

  Future<void> _loadAvailableMeals(
    String localeName, {
    String? slot,
    int? page,
  }) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final restaurant = state.selectedRestaurant;

    if (subId == null ||
        subId.isEmpty ||
        restaurant == null ||
        _getAvailableMealsUseCase == null) {
      return;
    }

    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

    emit(
      state.copyWith(
        isLoadingAvailableMeals: true,
        clearAvailableMealsFailure: true,
      ),
    );

    final result = await _getAvailableMealsUseCase(
      subscriptionId: subId,
      date: formattedDate,
      restaurantId: restaurant.id,
      localeName: localeName,
      slot: slot,
      page: page,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final selectedMeals = state.hasInitializedMealSelection
            ? state.selectedMealsForDay
            : result.data.meals.where((meal) => meal.selected).toList();
        emit(
          state.copyWith(
            availableMeals: result.data,
            selectedMealsForDay: selectedMeals,
            hasInitializedMealSelection: true,
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

  Future<void> _selectMealCategory(SelectFamilyMealCategoryEvent event) async {
    emit(state.copyWith(selectedCategoryIndex: event.index));
    final slot = switch (event.index) {
      1 => 'breakfast',
      2 => 'lunch',
      3 => 'dinner',
      4 => 'snack',
      _ => null,
    };
    await _loadAvailableMeals(event.localeName, slot: slot);
  }

  void _selectMealForSlot(CalendarMealEntity meal, String slot) {
    final currentMeals = List<CalendarMealEntity>.from(
      state.selectedMealsForDay,
    );
    final normalizedSlot = (meal.slot.isNotEmpty ? meal.slot : slot)
        .trim()
        .toLowerCase();
    final selectedMealIndex = currentMeals.indexWhere(
      (selectedMeal) => selectedMeal.id == meal.id,
    );
    if (selectedMealIndex >= 0) {
      currentMeals.removeAt(selectedMealIndex);
      emit(state.copyWith(selectedMealsForDay: currentMeals));
      return;
    }

    final slotLimit = state.availableMeals?.slotRequirements
        .where(
          (requirement) =>
              requirement.slot.trim().toLowerCase() == normalizedSlot,
        )
        .firstOrNull
        ?.count;
    final selectedInSlot = currentMeals.where(
      (selectedMeal) =>
          selectedMeal.slot.trim().toLowerCase() == normalizedSlot,
    );

    if (slotLimit != null &&
        slotLimit > 0 &&
        selectedInSlot.length >= slotLimit) {
      currentMeals.remove(selectedInSlot.first);
    }
    currentMeals.add(meal.copyWith(slot: normalizedSlot, selected: true));

    emit(state.copyWith(selectedMealsForDay: currentMeals));
  }

  Future<void> _saveDayMeals(String localeName) async {
    final subId = state.activeSubscriptionId;
    final date = state.selectedDate ?? DateTime.now();
    final meals = state.selectedMealsForDay;

    if (subId == null || subId.isEmpty || _saveDayMealsUseCase == null) return;

    final formattedDate = intl.DateFormat('yyyy-MM-dd').format(date);

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
      meals: meals,
      localeName: localeName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final updatedDay = result.data.copyWith(isSelected: true);
        final updatedDays = state.days.map((d) {
          if (d.date != null &&
              d.date!.year == date.year &&
              d.date!.month == date.month &&
              d.date!.day == date.day) {
            return updatedDay;
          }
          return d;
        }).toList();

        emit(
          state.copyWith(
            selectedDay: updatedDay,
            days: updatedDays,
            isSavingMeals: false,
            saveMealsSuccess: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: result.failure,
          ),
        );
    }
  }
}
