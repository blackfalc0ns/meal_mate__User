import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

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

  final PaymentArgs? paymentArgs;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onChangePaymentMethod;
  final VoidCallback? onContactSupport;
}
