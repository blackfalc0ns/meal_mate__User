import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_uncompleted_subscription_repository.dart';

@injectable
class DeleteUncompletedSubscriptionUseCase {
  const DeleteUncompletedSubscriptionUseCase(this._repository);

  final ProfileUncompletedSubscriptionRepository _repository;

  Future<ApiResult<void>> call(String subscriptionId) {
    return _repository.deleteUncompletedSubscription(subscriptionId);
  }
}
