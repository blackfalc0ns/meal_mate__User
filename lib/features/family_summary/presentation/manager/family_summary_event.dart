import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

sealed class FamilySummaryEvent {
  const FamilySummaryEvent();
}

typedef FamilyCheckoutEvent = FamilySummaryEvent;

class GetFamilySubscriptionCurrentEvent extends FamilyCheckoutEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class GetFamilySummaryEvent extends FamilyCheckoutEvent {
  const GetFamilySummaryEvent({this.memberId});

  final String? memberId;
}

class SelectFamilyMemberSummaryEvent extends FamilySummaryEvent {
  const SelectFamilyMemberSummaryEvent({
    required this.memberId,
    required this.subscribeNow,
  });

  final String memberId;
  final bool subscribeNow;
}

typedef SelectFamilyMemberCheckoutEvent = SelectFamilyMemberSummaryEvent;

class SelectFamilyPaymentMethodEvent extends FamilyCheckoutEvent {
  const SelectFamilyPaymentMethodEvent(this.paymentMethod);

  final PaymentMethodEntity paymentMethod;
}

class CheckoutFamilySubscriptionEvent extends FamilyCheckoutEvent {
  const CheckoutFamilySubscriptionEvent({
    required this.callbackUrl,
    required this.errorUrl,
    required this.correlationId,
    required this.paymentMethodId,
  });

  final String callbackUrl;
  final String errorUrl;
  final String correlationId;
  final int paymentMethodId;
}

class RetryFamilySubscriptionPaymentEvent extends FamilyCheckoutEvent {
  const RetryFamilySubscriptionPaymentEvent({
    required this.callbackUrl,
    required this.errorUrl,
    required this.correlationId,
    required this.paymentMethodId,
  });
  final String callbackUrl;
  final String errorUrl;
  final String correlationId;
  final int paymentMethodId;
}

class UpdateMemberStartDateEvent extends FamilyCheckoutEvent {
  const UpdateMemberStartDateEvent({
    required this.memberId,
    required this.startDate,
  });

  final String memberId;
  final String startDate;
}

class ApplyFamilyCouponEvent extends FamilyCheckoutEvent {
  const ApplyFamilyCouponEvent(this.promoCode);

  final String promoCode;
}

class RemoveFamilyCouponEvent extends FamilyCheckoutEvent {
  const RemoveFamilyCouponEvent();
}
