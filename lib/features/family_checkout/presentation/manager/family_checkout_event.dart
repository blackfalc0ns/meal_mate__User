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

class SelectFamilyPaymentMethodEvent extends FamilyPlanEvent {
  const SelectFamilyPaymentMethodEvent(this.paymentMethod);

  final PaymentMethodEntity paymentMethod;
}

class CheckoutFamilySubscriptionEvent extends FamilyPlanEvent {
  const CheckoutFamilySubscriptionEvent({
    required this.callbackUrl,
    required this.errorUrl,
    required this.paymentMethodId,
  });

  final String callbackUrl;
  final String errorUrl;
  final int paymentMethodId;
}
