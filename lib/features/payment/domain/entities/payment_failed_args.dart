import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:flutter/foundation.dart';

/// Arguments passed to [PaymentFailedScreen] to handle retry, change method, or custom actions.
@immutable
class PaymentFailedArgs {
  const PaymentFailedArgs({
    this.paymentArgs,
    this.errorMessage,
    this.onRetry,
    this.onChangePaymentMethod,
    this.onContactSupport,
  });

  final SubscriptionCheckoutArgs? paymentArgs;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onChangePaymentMethod;
  final VoidCallback? onContactSupport;
}
