import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

sealed class FamilyCheckoutEvent {
  const FamilyCheckoutEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyCheckoutEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class GetFamilySummaryEvent extends FamilyCheckoutEvent {
  const GetFamilySummaryEvent({this.memberId});

  final String? memberId;
}

class SelectFamilyMemberCheckoutEvent extends FamilyCheckoutEvent {
  const SelectFamilyMemberCheckoutEvent({
    required this.memberId,
    required this.subscribeNow,
  });

  final String memberId;
  final bool subscribeNow;
}

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
