import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';

class CalendarState {
  const CalendarState({
    this.subscriptionId = '',
    this.calendar,
    this.days = const [],
    this.restaurants = const [],
    this.availableMeals,
    this.selectedDate,
    this.localSelectedMealIds = const [],
    this.isCalendarLoading = false,
    this.isRestaurantsLoading = false,
    this.isAvailableMealsLoading = false,
    this.isSaving = false,
    this.saveSuccessCount = 0,
    this.isConfirming = false,
    this.confirmSuccessCount = 0,
    this.isLoadingMoreMeals = false,
    this.calendarFailure,
    this.restaurantsFailure,
    this.availableMealsFailure,
    this.loadMoreMealsFailure,
    this.saveFailure,
    this.confirmFailure,
    this.hasNoSubscription = false,
  });

  final String subscriptionId;
  final CalendarSubscriptionEntity? calendar;
  final List<CalendarDayEntity> days;
  final List<CalendarRestaurantOptionEntity> restaurants;
  final CalendarAvailableMealsEntity? availableMeals;
  final DateTime? selectedDate;
  final List<String> localSelectedMealIds;
  final bool isCalendarLoading;
  final bool isRestaurantsLoading;
  final bool isAvailableMealsLoading;
  final bool isSaving;
  final int saveSuccessCount;
  final bool isConfirming;
  final int confirmSuccessCount;
  final bool isLoadingMoreMeals;
  final Failure? calendarFailure;
  final Failure? restaurantsFailure;
  final Failure? availableMealsFailure;
  final Failure? loadMoreMealsFailure;
  final Failure? saveFailure;
  final Failure? confirmFailure;
  final bool hasNoSubscription;

  CalendarDayEntity? get selectedDay {
    final date = selectedDate;
    if (date == null) return days.firstOrNull;
    return days
        .where((day) => day.date != null && _isSameDay(day.date!, date))
        .firstOrNull;
  }

  bool get hasCalendarData => days.isNotEmpty;

  bool get hasRestaurantPool => restaurants.isNotEmpty;

  bool get canEditSelectedDay => selectedDay?.isEditable == true;

  List<CalendarMealEntity> get selectedDayMeals {
    return selectedDay?.meals ?? const [];
  }

  int get requiredMealsCount {
    final availableCount = availableMeals?.requiredMealsCount ?? 0;
    if (availableCount > 0) return availableCount;
    final day = selectedDay;
    if (day == null) return 0;
    return day.slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
  }

  bool get canSaveMeals {
    final available = availableMeals;
    if (available == null ||
        localSelectedMealIds.length != requiredMealsCount) {
      return false;
    }
    for (final requirement in available.slotRequirements) {
      final count = available.meals
          .where(
            (meal) =>
                meal.slot == requirement.slot &&
                localSelectedMealIds.contains(meal.id),
          )
          .length;
      if (count != requirement.count) return false;
    }
    return true;
  }

  bool get canConfirmSelectedDayMeals {
    final day = selectedDay;
    if (day == null || !day.isEditable || isConfirming || isSaving) return false;
    final meals = selectedDayMeals;
    if (meals.isEmpty) return false;
    final requiredCount = day.slotRequirements.fold<int>(
      0,
      (total, requirement) => total + requirement.count,
    );
    if (requiredCount > 0 && meals.length != requiredCount) return false;
    return true;
  }

  List<CalendarRestaurantOptionEntity> restaurantsWithUsageLimits() {
    return restaurants;
  }

  CalendarState copyWith({
    String? subscriptionId,
    CalendarSubscriptionEntity? calendar,
    List<CalendarDayEntity>? days,
    List<CalendarRestaurantOptionEntity>? restaurants,
    CalendarAvailableMealsEntity? availableMeals,
    DateTime? selectedDate,
    List<String>? localSelectedMealIds,
    bool? isCalendarLoading,
    bool? isRestaurantsLoading,
    bool? isAvailableMealsLoading,
    bool? isSaving,
    int? saveSuccessCount,
    bool? isConfirming,
    int? confirmSuccessCount,
    bool? isLoadingMoreMeals,
    Failure? calendarFailure,
    Failure? restaurantsFailure,
    Failure? availableMealsFailure,
    Failure? loadMoreMealsFailure,
    Failure? saveFailure,
    Failure? confirmFailure,
    bool? hasNoSubscription,
    bool clearRestaurants = false,
    bool clearAvailableMeals = false,
    bool clearCalendarFailure = false,
    bool clearRestaurantsFailure = false,
    bool clearAvailableMealsFailure = false,
    bool clearLoadMoreMealsFailure = false,
    bool clearSaveFailure = false,
    bool clearConfirmFailure = false,
  }) {
    return CalendarState(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      calendar: calendar ?? this.calendar,
      days: days ?? this.days,
      restaurants: clearRestaurants
          ? const []
          : restaurants ?? this.restaurants,
      availableMeals: clearAvailableMeals
          ? null
          : availableMeals ?? this.availableMeals,
      selectedDate: selectedDate ?? this.selectedDate,
      localSelectedMealIds: localSelectedMealIds ?? this.localSelectedMealIds,
      isCalendarLoading: isCalendarLoading ?? this.isCalendarLoading,
      isRestaurantsLoading: isRestaurantsLoading ?? this.isRestaurantsLoading,
      isAvailableMealsLoading:
          isAvailableMealsLoading ?? this.isAvailableMealsLoading,
      isSaving: isSaving ?? this.isSaving,
      saveSuccessCount: saveSuccessCount ?? this.saveSuccessCount,
      isConfirming: isConfirming ?? this.isConfirming,
      confirmSuccessCount: confirmSuccessCount ?? this.confirmSuccessCount,
      isLoadingMoreMeals: isLoadingMoreMeals ?? this.isLoadingMoreMeals,
      calendarFailure: clearCalendarFailure
          ? null
          : calendarFailure ?? this.calendarFailure,
      restaurantsFailure: clearRestaurantsFailure
          ? null
          : restaurantsFailure ?? this.restaurantsFailure,
      availableMealsFailure: clearAvailableMealsFailure
          ? null
          : availableMealsFailure ?? this.availableMealsFailure,
      loadMoreMealsFailure: clearLoadMoreMealsFailure
          ? null
          : loadMoreMealsFailure ?? this.loadMoreMealsFailure,
      saveFailure: clearSaveFailure ? null : saveFailure ?? this.saveFailure,
      confirmFailure:
          clearConfirmFailure ? null : confirmFailure ?? this.confirmFailure,
      hasNoSubscription: hasNoSubscription ?? this.hasNoSubscription,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
