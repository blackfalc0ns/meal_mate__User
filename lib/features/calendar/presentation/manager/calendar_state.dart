import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';

part 'calendar_state_extensions.dart';

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
}
