import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/restaurant_tier_upgrade_repository.dart';

@injectable
class GetSubscriptionUpgradeOptionsUseCase {
  GetSubscriptionUpgradeOptionsUseCase(this._repository);

  final RestaurantTierUpgradeRepository _repository;

  Future<ApiResult<SubscriptionUpgradeOptionsEntity>> call(
    String subscriptionId,
  ) {
    return _repository.getUpgradeOptions(subscriptionId);
  }
}
