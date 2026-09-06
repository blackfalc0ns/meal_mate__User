import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/restaurant_tier_upgrade_repository.dart';

@injectable
class GetSubscriptionUpgradeSummaryUseCase {
  const GetSubscriptionUpgradeSummaryUseCase(this._repository);

  final RestaurantTierUpgradeRepository _repository;

  Future<ApiResult<SubscriptionUpgradeSummaryEntity>> call({
    required String subscriptionId,
    required String targetTier,
  }) {
    return _repository.getUpgradeSummary(subscriptionId, targetTier);
  }
}
