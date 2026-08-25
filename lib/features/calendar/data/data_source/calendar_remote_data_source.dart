import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';

abstract interface class CalendarRemoteDataSource {
  Future<CalendarResponseDto> getCalendar(String subscriptionId);

  Future<List<CalendarRestaurantResponseDto>> getRestaurants({
    required String subscriptionId,
    required String date,
  });

  Future<void> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required CalendarSetRestaurantRequestDto request,
  });

  Future<CalendarAvailableMealsResponseDto> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
  });

  Future<void> saveDayMeals({
    required String subscriptionId,
    required String date,
    required CalendarSaveMealsRequestDto request,
  });

  Future<void> autoSelect({
    required String subscriptionId,
    required String date,
  });
}
