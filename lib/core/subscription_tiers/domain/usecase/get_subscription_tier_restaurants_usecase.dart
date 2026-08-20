import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';

@injectable
class GetSubscriptionTierRestaurantsUseCase {
  GetSubscriptionTierRestaurantsUseCase(this._repository);

  final SubscriptionTierRepository _repository;

  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>> call({
    required String programId,
    required String bundleId,
    required String tier,
    required List<String> restaurantIds,
  }) {
    return _repository.getTierRestaurants(
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      restaurantIds: restaurantIds,
    );
  }
}
