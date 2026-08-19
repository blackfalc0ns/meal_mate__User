class FamilyCheckoutResponseEntity {
  const FamilyCheckoutResponseEntity({
    required this.familyGroupId,
    required this.paymentAnchorSubscriptionId,
    required this.paymentUrl,
    required this.holdExpiresAtUtc,
    required this.finalPrice,
  });

  final String familyGroupId;
  final String paymentAnchorSubscriptionId;
  final String paymentUrl;
  final String holdExpiresAtUtc;
  final double finalPrice;
}
