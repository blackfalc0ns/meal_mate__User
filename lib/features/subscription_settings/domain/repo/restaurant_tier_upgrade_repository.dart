import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';

abstract interface class RestaurantTierUpgradeRepository {
  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> getUpgradeOptions(
    String subscriptionId,
  );

  Future<ApiResult<SubscriptionUpgradeRequestResultEntity>> createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestEntity request,
  );

  Future<ApiResult<SubscriptionUpgradeStatusEntity>> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  );
}
