import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/data_source/restaurant_tier_upgrade_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/repo/restaurant_tier_upgrade_repository.dart';

@Injectable(as: RestaurantTierUpgradeRepository)
class RestaurantTierUpgradeRepositoryImpl
    implements RestaurantTierUpgradeRepository {
  RestaurantTierUpgradeRepositoryImpl(this._remoteDataSource);

  final RestaurantTierUpgradeRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> getUpgradeOptions(
    String subscriptionId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getUpgradeOptions(
        subscriptionId,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionUpgradeSummaryEntity>> getUpgradeSummary(
    String subscriptionId,
    String targetTier,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getUpgradeSummary(
        subscriptionId,
        targetTier,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionUpgradeRequestResultEntity>>
  createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestEntity request,
  ) {
    return safeApiCall(() async {
      final requestDto = request.toDto();
      final response = await _remoteDataSource.createUpgradeRequest(
        subscriptionId,
        requestDto,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionUpgradeStatusEntity>> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getUpgradeStatus(
        subscriptionId,
        upgradeId,
      );
      return response.toEntity();
    });
  }
}
