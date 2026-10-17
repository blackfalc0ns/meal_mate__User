import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/customer_delivery_response_dto.dart';

@Injectable(as: CalendarRemoteDataSource)
class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  CalendarRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<CalendarResponseDto> getCalendar(String subscriptionId) {
    return _apiServices.getSubscriptionCalendar(subscriptionId);
  }

  @override
  Future<CalendarDayResponseDto> getDay({
    required String subscriptionId,
    required String date,
  }) {
    return _apiServices.getSubscriptionCalendarDay(subscriptionId, date);
  }

  @override
  Future<CalendarRestaurantsResponseDto> getRestaurants({
    required String subscriptionId,
    required String date,
    String? query,
    int? page,
    int? pageSize,
  }) {
    return _apiServices.getSubscriptionCalendarDayRestaurants(
      subscriptionId,
      date,
      query,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<CalendarDayResponseDto> setDayRestaurant({
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
    required String restaurantId,
    int? page,
    int? pageSize,
    String? slot,
  }) {
    return _apiServices.getSubscriptionCalendarRestaurantMeals(
      subscriptionId,
      date,
      restaurantId,
      page: page,
      pageSize: pageSize,
      slot: slot,
    );
  }

  @override
  Future<CalendarDayResponseDto> saveDayMeals({
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
  Future<CalendarDayResponseDto> autoSelect({
    required String subscriptionId,
    required String date,
  }) {
    return _apiServices.autoSelectSubscriptionCalendarDay(subscriptionId, date);
  }

  @override
  Future<CalendarDayResponseDto> confirmDayMeals({
    required String subscriptionId,
    required String date,
  }) {
    return _apiServices.confirmSubscriptionCalendarDay(subscriptionId, date);
  }

  @override
  Future<CustomerDeliveryWidgetResponseDto> getDeliveryWidget({
    String? serviceDate,
    String? subscriptionId,
  }) {
    return _apiServices.getCustomerDeliveryWidget(
      serviceDate: serviceDate,
      subscriptionId: subscriptionId,
    );
  }

  @override
  Future<CustomerDeliveryDetailsResponseDto> getDeliveryDetails({
    required String subscriptionDayId,
  }) {
    return _apiServices.getCustomerSubscriptionDayDeliveryDetails(
      subscriptionDayId,
    );
  }
}
