import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_subscription_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';

@Injectable(as: CalendarRepository)
class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl(this._remoteDataSource);

  final CalendarRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CalendarSubscriptionEntity>> getCalendar({
    required String subscriptionId,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCalendar(subscriptionId);
      return response.toSubscriptionEntity(
        subscriptionId: subscriptionId,
        localeName: localeName,
      );
    });
  }

  @override
  Future<ApiResult<List<CalendarRestaurantOptionEntity>>> getRestaurants({
    required String subscriptionId,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getRestaurants(subscriptionId);
      return response
          .map((restaurant) => restaurant.toOptionEntity(localeName))
          .where((restaurant) => restaurant.id.isNotEmpty)
          .toList();
    });
  }

  @override
  Future<ApiResult<void>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
  }) {
    return safeApiCall(() {
      return _remoteDataSource.setDayRestaurant(
        subscriptionId: subscriptionId,
        date: date,
        request: restaurantId.toSetRestaurantDto(),
      );
    });
  }

  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getAvailableMeals(
        subscriptionId: subscriptionId,
        date: date,
      );
      return response.toEntity(localeName);
    });
  }

  @override
  Future<ApiResult<void>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<String> mealIds,
  }) {
    return safeApiCall(() {
      return _remoteDataSource.saveDayMeals(
        subscriptionId: subscriptionId,
        date: date,
        request: mealIds.toSaveMealsDto(),
      );
    });
  }

  @override
  Future<ApiResult<void>> autoSelect({
    required String subscriptionId,
    required String date,
  }) {
    return safeApiCall(() {
      return _remoteDataSource.autoSelect(
        subscriptionId: subscriptionId,
        date: date,
      );
    });
  }
}
