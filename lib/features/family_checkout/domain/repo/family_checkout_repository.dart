import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

abstract class FamilyCheckoutRepository {
  Future<ApiResult<FamilySummaryEntity>> getFamilySummary({String? memberId});
  Future<ApiResult<List<PaymentMethodEntity>>> getFamilyPaymentMethods(
    double amount,
  );
  Future<ApiResult<PaymentCheckoutEntity>> checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    required int paymentMethodId,
  });
}
