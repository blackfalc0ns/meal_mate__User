class FamilyCheckoutRequestEntity {
  const FamilyCheckoutRequestEntity({
    required this.callbackUrl,
    required this.errorUrl,
    this.correlationId,
    required this.paymentMethodId,
  });

  final String callbackUrl;
  final String errorUrl;
  final String? correlationId;
  final int paymentMethodId;
}
