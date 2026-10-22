import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_checkout_repository.dart';

@injectable
class CheckoutSubscriptionUseCase {
  CheckoutSubscriptionUseCase(this._repository);

  final SubscriptionCheckoutRepository _repository;

  Future<ApiResult<PaymentCheckoutEntity>> call(
    PaymentCheckoutRequestEntity request,
  ) {
    return _repository.checkout(request);
  }
}
