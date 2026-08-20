import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';

@Injectable(as: SubscriptionTierRemoteDataSource)
class SubscriptionTierRemoteDataSourceImpl
    implements SubscriptionTierRemoteDataSource {
  SubscriptionTierRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionTierResponseDto>> getTiers({
    required String programId,
    required String bundleId,
    required int? durationDays,
    required bool includeFriday,
  }) {
    return _apiServices.getSubscriptionTiers(
      programId,
      bundleId,
      durationDays,
      includeFriday,
    );
  }

  @override
  Future<List<SubscriptionTierRestaurantBrowseResponseDto>> getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    required List<String> restaurantIds,
  }) {
    return _apiServices.getSubscriptionTierRestaurants(
      programId,
      bundleId,
      tier,
      restaurantIds.isEmpty ? null : restaurantIds,
    );
  }
}
