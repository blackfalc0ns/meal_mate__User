class SubscriptionSummaryEntity {
  const SubscriptionSummaryEntity({
    required this.programId,
    required this.programNameAr,
    required this.programNameEn,
    required this.bundleId,
    required this.bundleNameAr,
    required this.bundleNameEn,
    this.imageUrl,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    required this.restaurantCount,
    required this.tier,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.serviceDates,
    required this.slotRequirements,
    required this.basePrice,
    required this.campaignDiscount,
    required this.promoDiscount,
    required this.walletCredit,
    required this.gatewayFee,
    required this.finalPrice,
    required this.currencyCode,
    required this.termsAcceptanceRequired,
    required this.checkoutEndpoint,
    required this.includeFriday,
    required this.fridayDays,
    required this.totalServiceDays,
  });

  final String programId;
  final String programNameAr;
  final String programNameEn;
  final String bundleId;
  final String bundleNameAr;
  final String bundleNameEn;
  final String? imageUrl;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final int restaurantCount;
  final String tier;
  final int durationDays;
  final String startDate;
  final String endDate;
  final List<String> serviceDates;
  final List<SubscriptionSummarySlotRequirementEntity> slotRequirements;
  final double basePrice;
  final double campaignDiscount;
  final double promoDiscount;
  final double walletCredit;
  final double gatewayFee;
  final double finalPrice;
  final String currencyCode;
  final bool termsAcceptanceRequired;
  final String checkoutEndpoint;
  final bool includeFriday;
  final int fridayDays;
  final int totalServiceDays;

  String programName(String localeName) =>
      localeName == 'ar' ? programNameAr : programNameEn;

  String bundleName(String localeName) =>
      localeName == 'ar' ? bundleNameAr : bundleNameEn;

  String? restaurantName(String localeName) =>
      localeName == 'ar' ? restaurantNameAr : restaurantNameEn;
}

class SubscriptionSummarySlotRequirementEntity {
  const SubscriptionSummarySlotRequirementEntity({
    required this.slot,
    required this.count,
  });

  final String slot;
  final int count;
}
