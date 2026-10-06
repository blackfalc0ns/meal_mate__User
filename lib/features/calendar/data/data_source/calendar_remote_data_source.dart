import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';

abstract interface class CalendarRemoteDataSource {
  Future<CalendarResponseDto> getCalendar(String subscriptionId);

  Future<CalendarDayResponseDto> getDay({
    required String subscriptionId,
    required String date,
  });

  Future<CalendarRestaurantsResponseDto> getRestaurants({
    required String subscriptionId,
    required String date,
    String? query,
    int? page,
    int? pageSize,
  });

  Future<CalendarDayResponseDto> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required CalendarSetRestaurantRequestDto request,
  });

  Future<CalendarAvailableMealsResponseDto> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    int? page,
    int? pageSize,
    String? slot,
  });

  Future<CalendarDayResponseDto> saveDayMeals({
    required String subscriptionId,
    required String date,
    required CalendarSaveMealsRequestDto request,
  });

  Future<CalendarDayResponseDto> autoSelect({
    required String subscriptionId,
    required String date,
  });

  Future<CalendarDayResponseDto> confirmDayMeals({
    required String subscriptionId,
    required String date,
  });
}
