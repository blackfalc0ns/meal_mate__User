import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';

@Injectable(as: CalendarRemoteDataSource)
class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  CalendarRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<CalendarResponseDto> getCalendar(String subscriptionId) {
    return _apiServices.getSubscriptionCalendar(subscriptionId);
  }

  @override
  Future<List<CalendarRestaurantResponseDto>> getRestaurants(
    String subscriptionId,
  ) async {
    final response = await _apiServices.getSubscriptionCalendarRestaurants(
      subscriptionId,
    );
    return response.restaurants ?? const [];
  }

  @override
  Future<void> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required CalendarSetRestaurantRequestDto request,
  }) {
    return _apiServices.setSubscriptionCalendarDayRestaurant(
      subscriptionId,
      date,
      request,
    );
  }

  @override
  Future<CalendarAvailableMealsResponseDto> getAvailableMeals({
    required String subscriptionId,
    required String date,
  }) {
    return _apiServices.getSubscriptionCalendarAvailableMeals(
      subscriptionId,
      date,
    );
  }

  @override
  Future<void> saveDayMeals({
    required String subscriptionId,
    required String date,
    required CalendarSaveMealsRequestDto request,
  }) {
    return _apiServices.saveSubscriptionCalendarDayMeals(
      subscriptionId,
      date,
      request,
    );
  }

  @override
  Future<void> autoSelect({
    required String subscriptionId,
    required String date,
  }) {
    return _apiServices.autoSelectSubscriptionCalendarDay(subscriptionId, date);
  }
}
