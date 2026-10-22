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
    this.durationDays,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.paymentDate,
    this.includeFriday = false,
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
  final int? durationDays;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? paymentDate;
  final bool includeFriday;

  String programName(String lang) => lang.startsWith('ar')
      ? (programNameAr.isNotEmpty ? programNameAr : programNameEn)
      : (programNameEn.isNotEmpty ? programNameEn : programNameAr);

  String bundleName(String lang) {
    final ar = bundleNameAr.isNotEmpty ? bundleNameAr : programNameAr;
    final en = bundleNameEn.isNotEmpty ? bundleNameEn : programNameEn;
    if (lang.startsWith('ar')) {
      return ar.isNotEmpty ? ar : en;
    }
    return en.isNotEmpty ? en : ar;
  }

  String tierName(String lang) {
    final ar = (tierNameAr?.isNotEmpty == true) ? tierNameAr! : (tier ?? '');
    final en = (tierNameEn?.isNotEmpty == true)
        ? tierNameEn!
        : ((tier?.isNotEmpty == true) ? tier! : (tierNameAr ?? ''));
    if (lang.startsWith('ar')) {
      return ar.isNotEmpty ? ar : en;
    }
    return en.isNotEmpty ? en : ar;
  }
}
