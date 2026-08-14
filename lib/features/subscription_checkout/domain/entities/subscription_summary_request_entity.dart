class SubscriptionSummaryRequestEntity {
  const SubscriptionSummaryRequestEntity({
    required this.includeFriday,
    required this.durationDays,
    required this.tier,
    required this.bundleId,
    required this.programId,
  });

  final bool includeFriday;
  final int durationDays;
  final String tier;
  final String bundleId;
  final String programId;
}
