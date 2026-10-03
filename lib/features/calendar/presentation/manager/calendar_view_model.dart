import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/helpers/calendar_meals_merger.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_event.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/calendar_state.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';

part 'calendar_view_model_days.dart';
part 'calendar_view_model_restaurants.dart';
part 'calendar_view_model_meals.dart';
part 'calendar_view_model_actions.dart';

@injectable
class CalendarViewModel extends Cubit<CalendarState>
    with
        CalendarViewModelDays,
        CalendarViewModelMeals,
        CalendarViewModelRestaurants,
        CalendarViewModelActions {
  CalendarViewModel(
    this._getCalendarUseCase,
    this._getCalendarDayUseCase,
    this._getRestaurantsUseCase,
    this._setDayRestaurantUseCase,
    this._getAvailableMealsUseCase,
    this._saveDayMealsUseCase,
    this._autoSelectDayUseCase,
    this._confirmDayMealsUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
    this._sharedPrefHelper,
  ) : super(const CalendarState());

  @override
  final GetCalendarUseCase _getCalendarUseCase;
  @override
  final GetCalendarDayUseCase _getCalendarDayUseCase;
  @override
  final GetCalendarRestaurantsUseCase _getRestaurantsUseCase;
  @override
  final SetCalendarDayRestaurantUseCase _setDayRestaurantUseCase;
  @override
  final GetCalendarAvailableMealsUseCase _getAvailableMealsUseCase;
  @override
  final SaveCalendarDayMealsUseCase _saveDayMealsUseCase;
  @override
  final AutoSelectCalendarDayUseCase _autoSelectDayUseCase;
  @override
  final ConfirmCalendarDayMealsUseCase _confirmDayMealsUseCase;
  @override
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  @override
  final SharedPrefHelper _sharedPrefHelper;

  @override
  void _invalidateDependentOnDayChange() {
    _invalidateRestaurantRequests();
    _invalidateMealsRequests();
  }

  void doIntent(CalendarEvent event) {
    switch (event) {
      case LoadCalendarEvent():
        unawaited(
          _loadCalendar(
            subscriptionId: event.subscriptionId,
            localeName: event.localeName,
          ),
        );
      case SelectCalendarDayEvent():
        _selectDay(day: event.day, localeName: event.localeName);
      case LoadCalendarRestaurantsEvent():
        unawaited(_loadRestaurants(event.localeName, query: event.query));
      case SelectCalendarRestaurantEvent():
        unawaited(
          _selectRestaurant(
            restaurant: event.restaurant,
            localeName: event.localeName,
          ),
        );
      case LoadCalendarAvailableMealsEvent():
        unawaited(_loadAvailableMeals(event.localeName));
      case ToggleCalendarMealEvent():
        _toggleMeal(event.mealId);
      case SaveCalendarDayMealsEvent():
        unawaited(_saveMeals(event.localeName));
      case AutoSelectCalendarDayEvent():
        unawaited(_autoSelect(event.localeName));
      case ConfirmCalendarDayMealsEvent():
        unawaited(_confirmMeals(event.localeName));
      case LoadMoreCalendarMealsEvent():
        unawaited(
          _loadMoreMeals(slot: event.slot, localeName: event.localeName),
        );
    }
  }
}

String _dateParam(CalendarDayEntity? day) {
  final date = day?.date;
  if (date == null) return '';
  return DateFormat('yyyy-MM-dd').format(date);
}
