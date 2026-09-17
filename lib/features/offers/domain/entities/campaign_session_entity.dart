class CampaignSessionEntity {
  const CampaignSessionEntity({
    required this.sessionId,
    required this.campaignId,
    required this.bundleId,
    required this.customerId,
    required this.durationDays,
    required this.finalCustomerPrice,
    required this.currency,
    this.expiresAtUtc,
    required this.status,
  });

  final String sessionId;
  final String campaignId;
  final String bundleId;
  final String customerId;
  final int durationDays;
  final double finalCustomerPrice;
  final String currency;
  final DateTime? expiresAtUtc;
  final String status;

  bool get isExpired {
    if (expiresAtUtc == null) return false;
    return DateTime.now().toUtc().isAfter(expiresAtUtc!);
  }
}
