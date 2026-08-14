import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

abstract interface class PaymentRepository {
  Future<ApiResult<List<PaymentMethodEntity>>> getPaymentMethods({
    required double amount,
  });

  Future<ApiResult<PaymentCheckoutEntity>> checkout(
    PaymentCheckoutRequestEntity request,
  );
}
