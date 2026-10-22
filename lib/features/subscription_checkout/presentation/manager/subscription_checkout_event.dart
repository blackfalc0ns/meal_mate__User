import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';

sealed class SubscriptionCheckoutEvent {
  const SubscriptionCheckoutEvent();
}

class LoadSubscriptionCheckoutEvent extends SubscriptionCheckoutEvent {
  const LoadSubscriptionCheckoutEvent(this.args);
  final SubscriptionCheckoutArgs args;
}

class SelectCheckoutPaymentMethodEvent extends SubscriptionCheckoutEvent {
  const SelectCheckoutPaymentMethodEvent(this.method);
  final PaymentMethodEntity method;
}

class SubmitSubscriptionCheckoutEvent extends SubscriptionCheckoutEvent {
  const SubmitSubscriptionCheckoutEvent(this.args);
  final SubscriptionCheckoutArgs args;
}

class ResetSubscriptionCheckoutAfterFailureEvent
    extends SubscriptionCheckoutEvent {
  const ResetSubscriptionCheckoutAfterFailureEvent();
}
