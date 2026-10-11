import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';

abstract class SubscriptionTierRemoteDataSource {
  Future<void> checkPrerequisites();

  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
    String? startDate,
    String? familyMemberId,
  });

  Future<List<SubscriptionTierRestaurantBrowseResponseDto>> getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    String? familyMemberId,
    int? durationDays,
    String? startDate,
    bool? includeFriday,
  });
}
