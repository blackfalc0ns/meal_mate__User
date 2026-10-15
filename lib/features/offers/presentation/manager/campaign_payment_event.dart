sealed class CampaignPaymentEvent {
  const CampaignPaymentEvent();
}

class StartPaymentIntent extends CampaignPaymentEvent {
  const StartPaymentIntent({
    required this.sessionId,
    this.paymentMethodId = 3,
    this.callbackUrl = 'mealmate://campaign-payment/callback',
    this.errorUrl = 'mealmate://campaign-payment/error',
  });

  final String sessionId;
  final int paymentMethodId;
  final String callbackUrl;
  final String errorUrl;
}

class HandleReturnIntent extends CampaignPaymentEvent {
  const HandleReturnIntent({
    required this.sessionId,
    this.paymentId,
    this.callbackStatus,
  });

  final String sessionId;
  final String? paymentId;
  final String? callbackStatus;
}

class ReadStatusIntent extends CampaignPaymentEvent {
  const ReadStatusIntent(this.sessionId);
  final String sessionId;
}

class RetryPaymentIntent extends CampaignPaymentEvent {
  const RetryPaymentIntent();
}

class ResetPaymentFlowIntent extends CampaignPaymentEvent {
  const ResetPaymentFlowIntent();
}
