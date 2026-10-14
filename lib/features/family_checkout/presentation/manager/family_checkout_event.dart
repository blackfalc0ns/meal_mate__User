import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySubscriptionCurrentEvent extends FamilyPlanEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class GetFamilySummaryEvent extends FamilyPlanEvent {
  const GetFamilySummaryEvent({this.memberId});

  final String? memberId;
}

class SelectFamilyMemberCheckoutEvent extends FamilyPlanEvent {
  const SelectFamilyMemberCheckoutEvent({
    required this.memberId,
    required this.subscribeNow,
  });

  final String memberId;
  final bool subscribeNow;
}

class SelectFamilyPaymentMethodEvent extends FamilyPlanEvent {
  const SelectFamilyPaymentMethodEvent(this.paymentMethod);

  final PaymentMethodEntity paymentMethod;
}

class CheckoutFamilySubscriptionEvent extends FamilyPlanEvent {
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

class RetryFamilySubscriptionPaymentEvent extends FamilyPlanEvent {
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

class UpdateMemberStartDateEvent extends FamilyPlanEvent {
  const UpdateMemberStartDateEvent({
    required this.memberId,
    required this.startDate,
  });

  final String memberId;
  final String startDate;
}

