import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/data_source/restaurant_tier_upgrade_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/request/subscription_upgrade_request_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_request_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_status_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_summary_response_dto.dart';

@Injectable(as: RestaurantTierUpgradeRemoteDataSource)
class RestaurantTierUpgradeRemoteDataSourceImpl
    implements RestaurantTierUpgradeRemoteDataSource {
  RestaurantTierUpgradeRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<SubscriptionUpgradeOptionsResponseDto> getUpgradeOptions(
    String subscriptionId,
  ) {
    return _apiServices.getSubscriptionUpgradeOptions(subscriptionId);
  }

  @override
  Future<SubscriptionUpgradeSummaryResponseDto> getUpgradeSummary(
    String subscriptionId,
    String targetTier,
  ) {
    return _apiServices.getSubscriptionUpgradeSummary(
      subscriptionId,
      targetTier,
    );
  }

  @override
  Future<SubscriptionUpgradeRequestResponseDto> createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestDto request,
  ) {
    return _apiServices.createSubscriptionUpgradeRequest(
      subscriptionId,
      request,
    );
  }

  @override
  Future<SubscriptionUpgradeStatusResponseDto> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  ) {
    return _apiServices.getSubscriptionUpgradeStatus(subscriptionId, upgradeId);
  }
}
