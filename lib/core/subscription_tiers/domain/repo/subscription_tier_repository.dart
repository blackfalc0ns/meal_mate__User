import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';

abstract class SubscriptionTierRepository {
  Future<ApiResult<void>> checkPrerequisites();

  Future<ApiResult<List<SubscriptionTierEntity>>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? startDate,
    String? familyMemberId,
  });

  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>>
  getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    String? familyMemberId,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
  });
}
