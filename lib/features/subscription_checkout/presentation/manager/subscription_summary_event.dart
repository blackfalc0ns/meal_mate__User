import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

sealed class SubscriptionSummaryEvent {
  const SubscriptionSummaryEvent();
}

class GetSubscriptionSummaryEvent extends SubscriptionSummaryEvent {
  const GetSubscriptionSummaryEvent(this.request);

  final SubscriptionSummaryRequestEntity request;
}
