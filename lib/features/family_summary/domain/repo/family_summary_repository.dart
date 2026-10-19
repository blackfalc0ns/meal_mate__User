import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_selection_entity.dart';

abstract class FamilySummaryRepository {
  Future<ApiResult<FamilySummarySelectionEntity>>
  selectFamilyMemberForCheckout({
    required String memberId,
    required bool subscribeNow,
  });
  Future<ApiResult<void>> saveFamilyMemberStartDate({
    required String memberId,
    required String startDate,
  });
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({
    String? memberId,
    String? promoCode,
  });
  Future<ApiResult<List<PaymentMethodEntity>>> getFamilyPaymentMethods(
    double amount,
  );
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    int? paymentMethodId,
    String? batchId,
    int? batchVersion,
    String? idempotencyKey,
    int? clientContractVersion,
    String? promoCode,
  });
  Future<ApiResult<PaymentCheckoutEntity>> retryFamilySubscriptionPayment({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    int? paymentMethodId,
    required String batchId,
    required int batchVersion,
    required String idempotencyKey,
    int clientContractVersion =
        FamilySummaryContractConstants.clientContractVersion,
    String? promoCode,
  });
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilyRenewal({
    required String renewalRequestId,
    required String startDate,
    required String addressId,
    required String callbackUrl,
    required String errorUrl,
    String? correlationId,
    int paymentMethodId =
        FamilySummaryContractConstants.defaultRenewalPaymentMethodId,
    String? idempotencyKey,
    int? clientContractVersion,
  });
}

typedef FamilyCheckoutRepository = FamilySummaryRepository;
