class StartCampaignPaymentRequestEntity {
  const StartCampaignPaymentRequestEntity({
    required this.sessionId,
    required this.idempotencyKey,
    this.callbackUrl = 'mealmate://campaign-payment/callback',
    this.errorUrl = 'mealmate://campaign-payment/error',
    this.paymentMethodId = 3,
  });

  final String sessionId;
  final String idempotencyKey;
  final String callbackUrl;
  final String errorUrl;
  final int paymentMethodId;
}
