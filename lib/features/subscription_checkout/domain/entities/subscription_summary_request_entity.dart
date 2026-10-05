class SubscriptionSummaryRequestEntity {
  const SubscriptionSummaryRequestEntity({
    required this.includeFriday,
    required this.durationDays,
    required this.tier,
    required this.bundleId,
    required this.programId,
    this.startDate = '',
    this.promoCode,
    this.restaurantsPage,
    this.restaurantsPageSize,
  });

  final bool includeFriday;
  final int durationDays;
  final String tier;
  final String bundleId;
  final String programId;
  final String startDate;
  final String? promoCode;
  final int? restaurantsPage;
  final int? restaurantsPageSize;

  SubscriptionSummaryRequestEntity copyWith({
    bool? includeFriday,
    int? durationDays,
    String? tier,
    String? bundleId,
    String? programId,
    String? startDate,
    String? promoCode,
    bool clearPromoCode = false,
    int? restaurantsPage,
    int? restaurantsPageSize,
  }) {
    return SubscriptionSummaryRequestEntity(
      includeFriday: includeFriday ?? this.includeFriday,
      durationDays: durationDays ?? this.durationDays,
      tier: tier ?? this.tier,
      bundleId: bundleId ?? this.bundleId,
      programId: programId ?? this.programId,
      startDate: startDate ?? this.startDate,
      promoCode: clearPromoCode ? null : (promoCode ?? this.promoCode),
      restaurantsPage: restaurantsPage ?? this.restaurantsPage,
      restaurantsPageSize: restaurantsPageSize ?? this.restaurantsPageSize,
    );
  }
}
