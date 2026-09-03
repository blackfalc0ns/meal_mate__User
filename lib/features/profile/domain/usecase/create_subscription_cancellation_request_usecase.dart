import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class CreateSubscriptionCancellationRequestUseCase {
  CreateSubscriptionCancellationRequestUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<ProfileBillingCancellationResultEntity>> call({
    required String subscriptionId,
    required ProfileBillingCancellationRequestEntity request,
  }) {
    return _repository.createCustomerSubscriptionCancellationRequest(
      subscriptionId: subscriptionId,
      request: request,
    );
  }
}
