class FamilyPaymentMethodEntity {
  const FamilyPaymentMethodEntity({
    required this.paymentMethodId,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.integrationType,
    required this.isAvailable,
    this.unavailableReason,
  });

  final int paymentMethodId;
  final String code;
  final String nameAr;
  final String nameEn;
  final String? integrationType;
  final bool isAvailable;
  final String? unavailableReason;
}
