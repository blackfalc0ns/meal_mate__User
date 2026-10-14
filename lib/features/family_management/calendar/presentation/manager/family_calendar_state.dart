import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyCalendarState {
  const FamilyCalendarState({
    this.members = const [],
    this.selectedMemberIndex = 0,
    this.currentSubscriptionId,
    this.currentMemberName,
    this.visibleMonth,
    this.selectedDate,
    this.selectedDay,
    this.days = const [],
    this.isLoadingMembers = false,
    this.isLoadingCalendar = false,
    this.isLoadingDay = false,
    this.calendarFailure,
    this.dayFailure,
    this.restaurants = const [],
    this.filteredRestaurants = const [],
    this.selectedRestaurant,
    this.availableMeals,
    this.selectedMealsForDay = const [],
    this.hasInitializedMealSelection = false,
    this.selectedCategoryIndex = 0,
    this.isLoadingRestaurants = false,
    this.isLoadingAvailableMeals = false,
    this.isSavingMeals = false,
    this.saveMealsSuccess = false,
    this.restaurantsFailure,
    this.availableMealsFailure,
    this.saveMealsFailure,
  });

  final List<FamilyMemberSummaryEntity> members;
  final int selectedMemberIndex;
  final String? currentSubscriptionId;
  final String? currentMemberName;
  final DateTime? visibleMonth;
  final DateTime? selectedDate;
  final CalendarDayEntity? selectedDay;
  final List<CalendarDayEntity> days;
  final bool isLoadingMembers;
  final bool isLoadingCalendar;
  final bool isLoadingDay;
  final Failure? calendarFailure;
  final Failure? dayFailure;

  // Restaurant & Meal Selection Flow
  final List<CalendarRestaurantOptionEntity> restaurants;
  final List<CalendarRestaurantOptionEntity> filteredRestaurants;
  final CalendarRestaurantOptionEntity? selectedRestaurant;
  final CalendarAvailableMealsEntity? availableMeals;
  final List<CalendarMealEntity> selectedMealsForDay;
  final bool hasInitializedMealSelection;
  final int selectedCategoryIndex;
  final bool isLoadingRestaurants;
  final bool isLoadingAvailableMeals;
  final bool isSavingMeals;
  final bool saveMealsSuccess;
  final Failure? restaurantsFailure;
  final Failure? availableMealsFailure;
  final Failure? saveMealsFailure;

  bool get hasCalendarData => days.isNotEmpty;

  FamilyMemberSummaryEntity? get currentMember {
    if (members.isNotEmpty &&
        selectedMemberIndex >= 0 &&
        selectedMemberIndex < members.length) {
      return members[selectedMemberIndex];
    }
    return null;
  }

  String get displayName {
    return currentMember?.displayName ?? currentMemberName ?? '';
  }

  String? get activeSubscriptionId {
    return currentMember?.effectiveSubscriptionId ?? currentSubscriptionId;
  }

  CalendarNutritionTotalsEntity get selectedNutritionTotals {
    return selectedMealsForDay.fold(
      const CalendarNutritionTotalsEntity(),
      (totals, meal) => CalendarNutritionTotalsEntity(
        calories: totals.calories + _nutrientValue(meal.calories),
        proteinG: totals.proteinG + _nutrientValue(meal.protein),
        carbsG: totals.carbsG + _nutrientValue(meal.carbs),
        fatG: totals.fatG + _nutrientValue(meal.fat),
      ),
    );
  }

  static int _nutrientValue(dynamic value) {
    if (value is num) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? (double.tryParse(value)?.round() ?? 0);
    }
    return 0;
  }

  FamilyCalendarState copyWith({
    List<FamilyMemberSummaryEntity>? members,
    int? selectedMemberIndex,
    String? currentSubscriptionId,
    String? currentMemberName,
    DateTime? visibleMonth,
    DateTime? selectedDate,
    CalendarDayEntity? selectedDay,
    List<CalendarDayEntity>? days,
    bool? isLoadingMembers,
    bool? isLoadingCalendar,
    bool? isLoadingDay,
    Failure? calendarFailure,
    Failure? dayFailure,
    List<CalendarRestaurantOptionEntity>? restaurants,
    List<CalendarRestaurantOptionEntity>? filteredRestaurants,
    CalendarRestaurantOptionEntity? selectedRestaurant,
    CalendarAvailableMealsEntity? availableMeals,
    List<CalendarMealEntity>? selectedMealsForDay,
    bool? hasInitializedMealSelection,
    int? selectedCategoryIndex,
    bool? isLoadingRestaurants,
    bool? isLoadingAvailableMeals,
    bool? isSavingMeals,
    bool? saveMealsSuccess,
    Failure? restaurantsFailure,
    Failure? availableMealsFailure,
    Failure? saveMealsFailure,
    bool clearCalendarFailure = false,
    bool clearDayFailure = false,
    bool clearRestaurantsFailure = false,
    bool clearAvailableMealsFailure = false,
    bool clearSaveMealsFailure = false,
    bool clearSelectedRestaurant = false,
    bool clearAvailableMeals = false,
  }) {
    return FamilyCalendarState(
      members: members ?? this.members,
      selectedMemberIndex: selectedMemberIndex ?? this.selectedMemberIndex,
      currentSubscriptionId:
          currentSubscriptionId ?? this.currentSubscriptionId,
      currentMemberName: currentMemberName ?? this.currentMemberName,
      visibleMonth: visibleMonth ?? this.visibleMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDay: selectedDay ?? this.selectedDay,
      days: days ?? this.days,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      isLoadingCalendar: isLoadingCalendar ?? this.isLoadingCalendar,
      isLoadingDay: isLoadingDay ?? this.isLoadingDay,
      calendarFailure: clearCalendarFailure
          ? null
          : (calendarFailure ?? this.calendarFailure),
      dayFailure: clearDayFailure ? null : (dayFailure ?? this.dayFailure),
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      selectedRestaurant: clearSelectedRestaurant
          ? null
          : (selectedRestaurant ?? this.selectedRestaurant),
      availableMeals: clearAvailableMeals
          ? null
          : (availableMeals ?? this.availableMeals),
      selectedMealsForDay: selectedMealsForDay ?? this.selectedMealsForDay,
      hasInitializedMealSelection:
          hasInitializedMealSelection ?? this.hasInitializedMealSelection,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      isLoadingRestaurants:
          isLoadingRestaurants ?? this.isLoadingRestaurants,
      isLoadingAvailableMeals:
          isLoadingAvailableMeals ?? this.isLoadingAvailableMeals,
      isSavingMeals: isSavingMeals ?? this.isSavingMeals,
      saveMealsSuccess: saveMealsSuccess ?? this.saveMealsSuccess,
      restaurantsFailure: clearRestaurantsFailure
          ? null
          : (restaurantsFailure ?? this.restaurantsFailure),
      availableMealsFailure: clearAvailableMealsFailure
          ? null
          : (availableMealsFailure ?? this.availableMealsFailure),
      saveMealsFailure: clearSaveMealsFailure
          ? null
          : (saveMealsFailure ?? this.saveMealsFailure),
    );
  }
}
