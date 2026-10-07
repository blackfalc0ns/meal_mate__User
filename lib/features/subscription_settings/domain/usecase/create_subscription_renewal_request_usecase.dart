import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';

@injectable
class CreateSubscriptionRenewalRequestUseCase {
  CreateSubscriptionRenewalRequestUseCase(this._repository);

  final SubscriptionBillingRepository _repository;

  Future<ApiResult<void>> call(String subscriptionId) {
    return _repository.createCustomerSubscriptionRenewalRequest(subscriptionId);
  }
}
