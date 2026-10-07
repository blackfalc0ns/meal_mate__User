import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';

sealed class SubscriptionBillingEvent {
  const SubscriptionBillingEvent();
}

class GetSubscriptionBillingEvent extends SubscriptionBillingEvent {
  const GetSubscriptionBillingEvent();
}

class RenewSubscriptionEvent extends SubscriptionBillingEvent {
  const RenewSubscriptionEvent(this.subscriptionId);

  final String subscriptionId;
}

class FreezeSubscriptionEvent extends SubscriptionBillingEvent {
  const FreezeSubscriptionEvent({
    required this.subscriptionId,
    required this.request,
  });

  final String subscriptionId;
  final SubscriptionBillingFreezeRequestEntity request;
}

class GetCancellationQuoteEvent extends SubscriptionBillingEvent {
  const GetCancellationQuoteEvent(this.subscriptionId);

  final String subscriptionId;
}

class CancelSubscriptionEvent extends SubscriptionBillingEvent {
  const CancelSubscriptionEvent({
    required this.subscriptionId,
    required this.request,
  });

  final String subscriptionId;
  final SubscriptionBillingCancellationRequestEntity request;
}

class ResetBillingActionEvent extends SubscriptionBillingEvent {
  const ResetBillingActionEvent();
}

typedef ResetSubscriptionBillingActionEvent = ResetBillingActionEvent;

class DeleteUncompletedSubscriptionEvent extends SubscriptionBillingEvent {
  const DeleteUncompletedSubscriptionEvent(this.subscriptionId);

  final String subscriptionId;
}

class GetSubscriptionResumePreviewEvent extends SubscriptionBillingEvent {
  const GetSubscriptionResumePreviewEvent(this.subscriptionId);

  final String subscriptionId;
}

class ResumeSubscriptionEvent extends SubscriptionBillingEvent {
  const ResumeSubscriptionEvent({
    required this.subscriptionId,
    this.startDate,
    this.paymentMethodId,
  });

  final String subscriptionId;
  final String? startDate;
  final int? paymentMethodId;
}
