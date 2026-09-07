import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@injectable
class CheckoutFamilySubscriptionUseCase {
  CheckoutFamilySubscriptionUseCase(this._repository);

  final FamilyCheckoutRepository _repository;

  Future<ApiResult<PaymentCheckoutEntity>> call({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    required int paymentMethodId,
  }) {
    return _repository.checkoutFamilySubscription(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      correlationId: correlationId,
      paymentMethodId: paymentMethodId,
    );
  }
}
