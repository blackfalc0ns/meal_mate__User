import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';

abstract interface class PaymentRepository {
  Future<ApiResult<PaymentStatusEntity>> getSubscriptionPaymentStatus(
    String subscriptionId,
  );

  Future<ApiResult<dynamic>> getSubscriptionCalendar(String subscriptionId);

  Future<ApiResult<SubscriptionConfirmationEntity>> getSubscriptionConfirmation(
    String subscriptionId,
  );
}
