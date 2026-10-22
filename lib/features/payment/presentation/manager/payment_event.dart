import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

sealed class PaymentEvent {
  const PaymentEvent();
}

class VerifyPaymentFulfillmentEvent extends PaymentEvent {
  const VerifyPaymentFulfillmentEvent(this.subscriptionId);

  final String subscriptionId;
}

class PollSubscriptionCalendarEvent extends PaymentEvent {
  const PollSubscriptionCalendarEvent(this.subscriptionId);

  final String subscriptionId;
}

class MarkPaymentFailedEvent extends PaymentEvent {
  const MarkPaymentFailedEvent();
}

class HandlePaymentReturnEvent extends PaymentEvent {
  const HandlePaymentReturnEvent(this.paymentReturn);

  final PaymentReturn paymentReturn;
}

class InitCheckoutSessionEvent extends PaymentEvent {
  const InitCheckoutSessionEvent(
    this.checkout, {
    this.flowType = 'individual',
    this.batchId,
    this.batchVersion,
  });

  final PaymentCheckoutEntity checkout;
  final String flowType;
  final String? batchId;
  final int? batchVersion;
}

class RenewPaymentHoldEvent extends PaymentEvent {
  const RenewPaymentHoldEvent();
}

class MarkPaymentLaunchedEvent extends PaymentEvent {
  const MarkPaymentLaunchedEvent();
}
