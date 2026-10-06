import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/repo/restaurant_tier_upgrade_repository.dart';

@injectable
class GetSubscriptionUpgradeStatusUseCase {
  GetSubscriptionUpgradeStatusUseCase(this._repository);

  final RestaurantTierUpgradeRepository _repository;

  Future<ApiResult<SubscriptionUpgradeStatusEntity>> call({
    required String subscriptionId,
    required String upgradeId,
  }) {
    return _repository.getUpgradeStatus(subscriptionId, upgradeId);
  }
}
