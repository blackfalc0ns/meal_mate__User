import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_upgrade_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_request_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_status_response_dto.dart';

abstract interface class RestaurantTierUpgradeRemoteDataSource {
  Future<SubscriptionUpgradeOptionsResponseDto> getUpgradeOptions(
    String subscriptionId,
  );

  Future<SubscriptionUpgradeRequestResponseDto> createUpgradeRequest(
    String subscriptionId,
    SubscriptionUpgradeRequestDto request,
  );

  Future<SubscriptionUpgradeStatusResponseDto> getUpgradeStatus(
    String subscriptionId,
    String upgradeId,
  );
}
