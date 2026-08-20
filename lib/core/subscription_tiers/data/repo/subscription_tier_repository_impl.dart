import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/mapper/subscription_tier_mapper.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/mapper/subscription_tier_restaurant_browse_mapper.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_restaurant_browse_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';

@Injectable(as: SubscriptionTierRepository)
class SubscriptionTierRepositoryImpl implements SubscriptionTierRepository {
  SubscriptionTierRepositoryImpl(this._remoteDataSource);

  final SubscriptionTierRemoteDataSource _remoteDataSource;

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
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<SubscriptionTierRestaurantBrowseEntity>>> getTierRestaurants({
    required String programId,
    required String bundleId,
    required String tier,
    required List<String> restaurantIds,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTierRestaurants(
        programId: programId,
        bundleId: bundleId,
        tier: tier,
        restaurantIds: restaurantIds,
      );
      return response.map((item) => item.toEntity()).toList();
    });
  }
}
