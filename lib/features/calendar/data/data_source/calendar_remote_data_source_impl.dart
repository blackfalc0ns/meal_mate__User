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
  Future<CalendarDayResponseDto> getDay({
    required String subscriptionId,
    required String date,
  }) {
    return _apiServices.getSubscriptionCalendarDay(subscriptionId, date);
  }

  @override
  Future<List<CalendarRestaurantResponseDto>> getRestaurants({
    required String subscriptionId,
    required String date,
  }) async {
    final response = await _apiServices.getSubscriptionCalendarDayRestaurants(
      subscriptionId,
      date,
    );
    final dayRestaurants = response.restaurants ?? const [];
    if (dayRestaurants.isEmpty) return dayRestaurants;

    final poolResponse = await _apiServices.getSubscriptionCalendarRestaurants(
      subscriptionId,
    );
    final poolLogos = <String, String>{};
    for (final restaurant in poolResponse.restaurants ?? const []) {
      final id = restaurant.restaurantId ?? restaurant.id;
      final logo = restaurant.logoUrl ?? restaurant.imageUrl;
      if (id == null || id.isEmpty || logo == null || logo.isEmpty) continue;
      poolLogos[id] = logo;
    }
    if (poolLogos.isEmpty) return dayRestaurants;

    return dayRestaurants.map((restaurant) {
      if (restaurant.logoUrl?.isNotEmpty == true ||
          restaurant.imageUrl?.isNotEmpty == true) {
        return restaurant;
      }
      final id = restaurant.restaurantId ?? restaurant.id;
      final logo = id == null ? null : poolLogos[id];
      if (logo == null || logo.isEmpty) return restaurant;
      return CalendarRestaurantResponseDto(
        id: restaurant.id,
        restaurantId: restaurant.restaurantId,
        name: restaurant.name,
        nameAr: restaurant.nameAr,
        nameEn: restaurant.nameEn,
        description: restaurant.description,
        descriptionAr: restaurant.descriptionAr,
        descriptionEn: restaurant.descriptionEn,
        category: restaurant.category,
        categoryAr: restaurant.categoryAr,
        categoryEn: restaurant.categoryEn,
        rating: restaurant.rating,
        logoUrl: logo,
        imageUrl: restaurant.imageUrl,
        mealCount: restaurant.mealCount,
        safeMealCount: restaurant.safeMealCount,
        limit: restaurant.limit,
        usedCount: restaurant.usedCount,
        remainingCount: restaurant.remainingCount,
        isBusy: restaurant.isBusy,
        isQuotaExhausted: restaurant.isQuotaExhausted,
        isEnabled: restaurant.isEnabled,
        disabledReason: restaurant.disabledReason,
        deliveryDuration: restaurant.deliveryDuration,
        deliveryWindow: restaurant.deliveryWindow,
        maxUsageCount: restaurant.maxUsageCount,
      );
    }).toList();
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
  }) {
    return _apiServices.getSubscriptionCalendarRestaurantMeals(
      subscriptionId,
      date,
      restaurantId,
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
}
