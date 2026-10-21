class CampaignQuoteRequestEntity {
  const CampaignQuoteRequestEntity({
    required this.campaignId,
    required this.programId,
    required this.campaignBundleId,
    required this.durationDays,
    required this.startDate,
    required this.addressId,
    this.promoCode,
  });
  final String campaignId;
  final String programId;
  final String campaignBundleId;
  final int durationDays;
  final String startDate;
  final String addressId;
  final String? promoCode;
}
