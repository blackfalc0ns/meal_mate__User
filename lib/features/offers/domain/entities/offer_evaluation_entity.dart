class OfferEvaluationEntity {
  const OfferEvaluationEntity({
    this.offerId,
    this.offerName,
    required this.isEligible,
    required this.calculatedDiscountAmount,
    this.finalAmount,
    this.ineligibilityReasons = const [],
    this.allowPromoCodeStacking = false,
  });

  final String? offerId;
  final String? offerName;
  final bool isEligible;
  final double calculatedDiscountAmount;
  final double? finalAmount;
  final List<String> ineligibilityReasons;
  final bool allowPromoCodeStacking;

  String? get firstReason =>
      ineligibilityReasons.isNotEmpty ? ineligibilityReasons.first : null;
}
