import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';

sealed class SubscriptionSummaryEvent {
  const SubscriptionSummaryEvent();
}

class GetSubscriptionSummaryEvent extends SubscriptionSummaryEvent {
  const GetSubscriptionSummaryEvent(this.request);

  final SubscriptionSummaryRequestEntity request;
}

class ChangeSubscriptionStartDateEvent extends SubscriptionSummaryEvent {
  const ChangeSubscriptionStartDateEvent({
    required this.startDate,
    required this.baseRequest,
  });

  final String startDate;
  final SubscriptionSummaryRequestEntity baseRequest;
}

class ApplySubscriptionPromoCodeEvent extends SubscriptionSummaryEvent {
  const ApplySubscriptionPromoCodeEvent(this.promoCode);

  final String promoCode;
}

class RemoveSubscriptionPromoCodeEvent extends SubscriptionSummaryEvent {
  const RemoveSubscriptionPromoCodeEvent();
}

class UpdateSubscriptionCouponDraftEvent extends SubscriptionSummaryEvent {
  const UpdateSubscriptionCouponDraftEvent(this.draft);

  final String draft;
}

class LoadMoreSubscriptionSummaryRestaurantsEvent
    extends SubscriptionSummaryEvent {
  const LoadMoreSubscriptionSummaryRestaurantsEvent();
}

class RetrySubscriptionSummaryRestaurantsEvent
    extends SubscriptionSummaryEvent {
  const RetrySubscriptionSummaryRestaurantsEvent();
}
