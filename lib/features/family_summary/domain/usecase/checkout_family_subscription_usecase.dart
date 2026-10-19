import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@injectable
class CheckoutFamilySubscriptionUseCase {
  CheckoutFamilySubscriptionUseCase(this._repository);

  final FamilySummaryRepository _repository;

  Future<ApiResult<PaymentCheckoutEntity>> call({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    int? paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int? clientContractVersion,
    String? promoCode,
  }) {
    return _repository.checkoutFamilySubscription(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      correlationId: correlationId,
      paymentMethodId: paymentMethodId,
      batchId: batchId,
      batchVersion: batchVersion,
      idempotencyKey: idempotencyKey,
      clientContractVersion: clientContractVersion,
      promoCode: promoCode,
    );
  }
}
