import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

class PaymentArgs {
  const PaymentArgs({
    required this.summary,
    required this.summaryRequest,
    required this.restaurantId,
  });

  final SubscriptionSummaryEntity summary;
  final SubscriptionSummaryRequestEntity summaryRequest;
  final String restaurantId;
}

class PaymentWebViewArgs {
  const PaymentWebViewArgs({required this.checkout});

  final PaymentCheckoutEntity checkout;
}
