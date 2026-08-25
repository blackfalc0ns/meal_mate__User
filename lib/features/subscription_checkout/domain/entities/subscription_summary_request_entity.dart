class SubscriptionSummaryRequestEntity {
  const SubscriptionSummaryRequestEntity({
    required this.includeFriday,
    required this.durationDays,
    required this.tier,
    required this.bundleId,
    required this.programId,
    this.startDate = '',
  });

  final bool includeFriday;
  final int durationDays;
  final String tier;
  final String bundleId;
  final String programId;
  final String startDate;

  SubscriptionSummaryRequestEntity copyWith({
    bool? includeFriday,
    int? durationDays,
    String? tier,
    String? bundleId,
    String? programId,
    String? startDate,
  }) {
    return SubscriptionSummaryRequestEntity(
      includeFriday: includeFriday ?? this.includeFriday,
      durationDays: durationDays ?? this.durationDays,
      tier: tier ?? this.tier,
      bundleId: bundleId ?? this.bundleId,
      programId: programId ?? this.programId,
      startDate: startDate ?? this.startDate,
    );
  }
}
