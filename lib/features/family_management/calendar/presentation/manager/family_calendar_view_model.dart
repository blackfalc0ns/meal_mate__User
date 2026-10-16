import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_capabilities_usecase.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_event.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_state.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_members_usecase.dart';

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
    ConfirmCalendarDayMealsUseCase? confirmDayMealsUseCase,
    AutoSelectCalendarDayUseCase? autoSelectDayUseCase,
    GetFamilyMemberCapabilitiesUseCase? getCapabilitiesUseCase,
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
       _getCapabilitiesUseCase =
           getCapabilitiesUseCase ??
           (getIt.isRegistered<GetFamilyMemberCapabilitiesUseCase>()
               ? getIt<GetFamilyMemberCapabilitiesUseCase>()
               : null),
       super(const FamilyCalendarState());

  final GetFamilyMembersUseCase? _getMembersUseCase;
  final GetCalendarUseCase? _getCalendarUseCase;
  final GetCalendarDayUseCase? _getCalendarDayUseCase;
  final GetCalendarRestaurantsUseCase? _getRestaurantsUseCase;
  final GetCalendarAvailableMealsUseCase? _getAvailableMealsUseCase;
  final SaveCalendarDayMealsUseCase? _saveDayMealsUseCase;
  final SetCalendarDayRestaurantUseCase? _setDayRestaurantUseCase;
  final ConfirmCalendarDayMealsUseCase? _confirmDayMealsUseCase;
  final AutoSelectCalendarDayUseCase? _autoSelectDayUseCase;
  final GetFamilyMemberCapabilitiesUseCase? _getCapabilitiesUseCase;
  int _mealSaveGeneration = 0;

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
      case ConfirmFamilyDayMealsEvent():
        _confirmDayMeals(event.localeName);
      case AutoSelectFamilyDayMealsEvent():
        _autoSelectDayMeals(event.localeName);
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
      final membersResult = await _getMembersUseCase(locale: event.localeName);
      if (isClosed) return;

      switch (membersResult) {
        case ApiSuccessResult(:final data):
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
        case ApiErrorResult(:final failure):
          emit(
            state.copyWith(isLoadingMembers: false, calendarFailure: failure),
          );
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
        // Use an empty value when the new member has no subscription so the
        // previous member's subscription cannot leak into subsequent calls.
        currentSubscriptionId: selectedMember.effectiveSubscriptionId ?? '',
        currentMemberName: selectedMember.displayName,
        selectedMealsForDay: const [],
        clearCalendarFailure: true,
        clearDayFailure: true,
      ),
    );

    await _loadCalendarForActiveMember(localeName);
  }

  Future<void> _loadCalendarForActiveMember(String localeName) async {
    final activeMember = state.currentMember;
    if (activeMember != null &&
        activeMember.memberId.isNotEmpty &&
        _getCapabilitiesUseCase != null) {
      final capResult = await _getCapabilitiesUseCase(activeMember.memberId);
      if (isClosed) return;
      if (capResult is ApiSuccessResult<List<FamilyCapabilityEntity>>) {
        emit(state.copyWith(memberCapabilities: capResult.data));
      }
    }

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
      final membersResult = await _getMembersUseCase(locale: localeName);
      if (isClosed) return;

      switch (membersResult) {
        case ApiSuccessResult(:final data):
          emit(state.copyWith(members: data, isLoadingMembers: false));
        case ApiErrorResult(:final failure):
          emit(
            state.copyWith(isLoadingMembers: false, calendarFailure: failure),
          );
          return;
      }
    }

    await _loadCalendarForActiveMember(localeName);
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
      case ApiErrorResult():
        if (result.failure.exception.statusCode == 403 ||
            result.failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
          await _fetchDayDetails(
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
        emit(
          state.copyWith(
            availableMeals: result.data,
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
  }

  void _selectMealForSlot(CalendarMealEntity meal, String slot) {
    if (state.isSavingMeals) return;
    final currentMeals = List<CalendarMealEntity>.from(
      state.selectedMealsForDay,
    );
    currentMeals.removeWhere((m) => m.slot == slot);
    currentMeals.add(meal);

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
      case ApiErrorResult():
        if (result.failure.exception.statusCode == 403 ||
            result.failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
        }
        // A later slot can fail after earlier slots were committed. Reload
        // for every failure so successful server-side selections are kept.
        await _fetchDayDetails(
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
          await _fetchDayDetails(
            date: date,
            subscriptionId: subId,
            localeName: localeName,
          );
        }
        emit(
          state.copyWith(
            isSavingMeals: false,
            saveMealsFailure: failure,
          ),
        );
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
        case ApiErrorResult():
          if (confirmResult.failure.exception.statusCode == 403 ||
              confirmResult.failure.exception.errorType == ApiErrorType.forbidden) {
            if (getIt.isRegistered<FamilyContextViewModel>()) {
              getIt<FamilyContextViewModel>().loadFamilyContext();
            }
            await _fetchDayDetails(
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
      case ApiErrorResult():
        if (result.failure.exception.statusCode == 403 ||
            result.failure.exception.errorType == ApiErrorType.forbidden) {
          if (getIt.isRegistered<FamilyContextViewModel>()) {
            getIt<FamilyContextViewModel>().loadFamilyContext();
          }
          await _fetchDayDetails(
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
