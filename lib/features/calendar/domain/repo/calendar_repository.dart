import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

abstract interface class CalendarRepository {
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  });

  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  });

  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  });

  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  });

  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
    int? page,
    int? pageSize,
    String? slot,
  });

  Future<ApiResult<CalendarDayEntity>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  });

  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  });

  Future<ApiResult<CalendarDayEntity>> confirmDayMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  });

  Future<ApiResult<CustomerDeliveryWidgetEntity>> getDeliveryWidget({
    String? serviceDate,
    String? subscriptionId,
  });

  Future<ApiResult<CustomerDeliveryDetailsEntity>> getDeliveryDetails({
    required String subscriptionDayId,
  });
}
