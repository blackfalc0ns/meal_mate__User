import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_uncompleted_subscription_repository.dart';

@injectable
class DeleteUncompletedSubscriptionUseCase {
  DeleteUncompletedSubscriptionUseCase(this._repository);

  final SubscriptionUncompletedSubscriptionRepository _repository;

  Future<ApiResult<void>> call(String subscriptionId) {
    return _repository.deleteUncompletedSubscription(subscriptionId);
  }
}
