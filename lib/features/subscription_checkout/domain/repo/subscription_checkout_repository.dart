import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';

abstract interface class SubscriptionCheckoutRepository {
  Future<ApiResult<List<PaymentMethodEntity>>> getPaymentMethods({
    required double amount,
  });
  Future<ApiResult<PaymentCheckoutEntity>> checkout(
    PaymentCheckoutRequestEntity request,
  );
}
