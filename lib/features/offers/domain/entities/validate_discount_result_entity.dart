class ValidateDiscountResultEntity {
  const ValidateDiscountResultEntity({
    required this.isValid,
    required this.code,
    required this.codeType,
    required this.discountAmount,
    this.discountPercent,
    this.eligibilityCode,
    this.messageAr,
    this.messageEn,
    this.offerId,
    this.offerName,
  });

  final bool isValid;
  final String code;
  final String codeType; // "Offer" | "PromoCode" | "ReferralCode"
  final double discountAmount;
  final double? discountPercent;
  final String? eligibilityCode;
  final String? messageAr;
  final String? messageEn;
  final String? offerId;
  final String? offerName;

  String? message(String lang) => lang == 'ar' ? (messageAr ?? messageEn) : (messageEn ?? messageAr);
}
