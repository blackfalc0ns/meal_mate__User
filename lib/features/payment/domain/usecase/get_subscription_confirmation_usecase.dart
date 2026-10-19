import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/repo/payment_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';

@injectable
class GetSubscriptionConfirmationUseCase {
  const GetSubscriptionConfirmationUseCase(this._repository);

  final PaymentRepository _repository;

  Future<ApiResult<SubscriptionConfirmationEntity>> call(String subscriptionId) {
    return _repository.getSubscriptionConfirmation(subscriptionId);
  }
}
