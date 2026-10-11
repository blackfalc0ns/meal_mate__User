import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/data/data_source/subscription_plan_remote_data_source.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_duration_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_restaurant_details_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_tier_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/data/mapper/subscription_tier_restaurant_browse_mapper.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/repo/subscription_plan_repository.dart';

@Injectable(as: SubscriptionPlanRepository)
class SubscriptionPlanRepositoryImpl implements SubscriptionPlanRepository {
  SubscriptionPlanRepositoryImpl(this._remoteDataSource);

  final SubscriptionPlanRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getDurations(
        programId: programId,
        bundleId: bundleId,
        includeFriday: includeFriday,
      );
      return response.map((duration) => duration.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTiers(
        programId: programId,
        bundleId: bundleId,
        durationDays: durationDays,
        includeFriday: includeFriday,
      );
      return response.map((tier) => tier.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTierRestaurants(
        programId: programId,
        bundleId: bundleId,
        tier: tier,
      );
      return response.map((restaurant) => restaurant.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurantsPage({
    required String programId,
    required String bundleId,
    required String tier,
    required int page,
    required int pageSize,
    String? addressId,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTierRestaurantsPage(
        programId: programId,
        bundleId: bundleId,
        tier: tier,
        page: page,
        pageSize: pageSize,
        addressId: addressId,
        durationDays: durationDays,
        startDate: startDate,
        includeFriday: includeFriday,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionRestaurantDetailsEntity>> getRestaurantDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getRestaurantDetails(
        programId: programId,
        bundleId: bundleId,
        restaurantId: restaurantId,
      );
      return response.toEntity();
    });
  }
}
