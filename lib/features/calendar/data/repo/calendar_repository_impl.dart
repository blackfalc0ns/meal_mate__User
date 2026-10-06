import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/data/data_source/calendar_remote_data_source.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/calendar_restaurants_page_mapper.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
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
  Future<ApiResult<CalendarDayEntity>> getDay({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getDay(
        subscriptionId: subscriptionId,
        date: date,
      );
      return response.toEntity(localeName);
    });
  }

  @override
  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getRestaurants(
        subscriptionId: subscriptionId,
        date: date,
        query: query,
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity(localeName: localeName);
    });
  }

  @override
  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.setDayRestaurant(
        subscriptionId: subscriptionId,
        date: date,
        request: restaurantId.toSetRestaurantDto(),
      );
      return response.toEntity(localeName);
    });
  }

  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
    int? page,
    int? pageSize,
    String? slot,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getAvailableMeals(
        subscriptionId: subscriptionId,
        date: date,
        restaurantId: restaurantId,
        page: page,
        pageSize: pageSize,
        slot: slot,
      );
      return response.toEntity(localeName);
    });
  }

  @override
  Future<ApiResult<CalendarDayEntity>> saveDayMeals({
    required String subscriptionId,
    required String date,
    required List<CalendarMealEntity> meals,
    required String localeName,
  }) {
    return safeApiCall(() async {
      if (meals.isEmpty) {
        final dayResponse = await _remoteDataSource.getDay(
          subscriptionId: subscriptionId,
          date: date,
        );
        return dayResponse.toEntity(localeName);
      }

      final responses = await Future.wait(
        meals.map(
          (meal) => _remoteDataSource.saveDayMeals(
            subscriptionId: subscriptionId,
            date: date,
            request: meal.toSaveMealsDto(),
          ),
        ),
      );

      return responses.last.toEntity(localeName);
    });
  }

  @override
  Future<ApiResult<CalendarDayEntity>> autoSelect({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.autoSelect(
        subscriptionId: subscriptionId,
        date: date,
      );
      return response.toEntity(localeName);
    });
  }

  @override
  Future<ApiResult<CalendarDayEntity>> confirmDayMeals({
    required String subscriptionId,
    required String date,
    required String localeName,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.confirmDayMeals(
        subscriptionId: subscriptionId,
        date: date,
      );
      return response.toEntity(localeName);
    });
  }
}
