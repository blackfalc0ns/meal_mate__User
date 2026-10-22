import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';
import 'package:meal_meat_user/features/family_summary/domain/repo/family_summary_repository.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

@injectable
class RetryFamilySubscriptionPaymentUseCase {
  RetryFamilySubscriptionPaymentUseCase(this._repository);
  final FamilySummaryRepository _repository;

  Future<ApiResult<PaymentCheckoutEntity>> call({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    int? paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int clientContractVersion =
        FamilyCheckoutContractConstants.clientContractVersion,
    String? promoCode,
  }) => _repository.retryFamilySubscriptionPayment(
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
