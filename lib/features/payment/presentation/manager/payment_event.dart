import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

sealed class PaymentEvent {
  const PaymentEvent();
}

class LoadPaymentEvent extends PaymentEvent {
  const LoadPaymentEvent(this.args);

  final PaymentArgs args;
}

class SelectPaymentMethodEvent extends PaymentEvent {
  const SelectPaymentMethodEvent(this.method);

  final PaymentMethodEntity method;
}

class CheckoutPaymentEvent extends PaymentEvent {
  const CheckoutPaymentEvent(this.args);

  final PaymentArgs args;
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
