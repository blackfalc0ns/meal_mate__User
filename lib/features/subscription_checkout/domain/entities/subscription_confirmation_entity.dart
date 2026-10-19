class SubscriptionConfirmationEntity {
  const SubscriptionConfirmationEntity({
    required this.subscriptionId,
    required this.status,
    required this.programNameAr,
    required this.programNameEn,
    required this.bundleNameAr,
    required this.bundleNameEn,
    this.startDate,
    this.endDate,
    required this.paidAmount,
    required this.appliedDiscount,
    required this.currency,
    this.referralShareCode,
    this.referralShareMessage,
    this.referralShareUrl,
  });

  final String subscriptionId;
  final String status;
  final String programNameAr;
  final String programNameEn;
  final String bundleNameAr;
  final String bundleNameEn;
  final String? startDate;
  final String? endDate;
  final double paidAmount;
  final double appliedDiscount;
  final String currency;
  final String? referralShareCode;
  final String? referralShareMessage;
  final String? referralShareUrl;

  String programName(String lang) =>
      lang == 'ar' ? programNameAr : (programNameEn.isNotEmpty ? programNameEn : programNameAr);

  String bundleName(String lang) =>
      lang == 'ar' ? bundleNameAr : (bundleNameEn.isNotEmpty ? bundleNameEn : bundleNameAr);
}
