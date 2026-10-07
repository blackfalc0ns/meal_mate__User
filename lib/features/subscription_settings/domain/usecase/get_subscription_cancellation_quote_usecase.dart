import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_billing_repository.dart';

@injectable
class GetSubscriptionCancellationQuoteUseCase {
  GetSubscriptionCancellationQuoteUseCase(this._repository);

  final SubscriptionBillingRepository _repository;

  Future<ApiResult<SubscriptionBillingCancellationQuoteEntity>> call(
    String subscriptionId,
  ) {
    return _repository.getCustomerSubscriptionCancellationQuote(subscriptionId);
  }
}
