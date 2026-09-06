import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/repo/subscription_tier_repository.dart';

@injectable
class CheckSubscriptionPrerequisitesUseCase {
  CheckSubscriptionPrerequisitesUseCase(this._repository);

  final SubscriptionTierRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.checkPrerequisites();
  }
}
