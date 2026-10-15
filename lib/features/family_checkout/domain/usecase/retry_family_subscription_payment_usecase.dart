import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/repo/family_checkout_repository.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@injectable
class RetryFamilySubscriptionPaymentUseCase {
  RetryFamilySubscriptionPaymentUseCase(this._repository);
  final FamilyCheckoutRepository _repository;

  Future<ApiResult<PaymentCheckoutEntity>> call({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    required int paymentMethodId,
    required String batchId,
    required int batchVersion,
    required String idempotencyKey,
  }) => _repository.retryFamilySubscriptionPayment(
    callbackUrl: callbackUrl,
    errorUrl: errorUrl,
    correlationId: correlationId,
    paymentMethodId: paymentMethodId,
    batchId: batchId,
    batchVersion: batchVersion,
    idempotencyKey: idempotencyKey,
  );
}
