import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_tier_restaurant_browse_entity.dart';

abstract interface class SubscriptionPlanRepository {
  Future<ApiResult<List<SubscriptionDurationEntity>>> getDurations({
    required String programId,
    required String bundleId,
    required bool includeFriday,
  });

  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  });

  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
  });

  Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurantsPage({
    required String programId,
    required String bundleId,
    required String tier,
    required int page,
    required int pageSize,
    String? addressId,
  });

  Future<ApiResult<SubscriptionRestaurantDetailsEntity>> getRestaurantDetails({
    required String programId,
    required String bundleId,
    required String restaurantId,
  });
}
