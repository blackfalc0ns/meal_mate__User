class FamilyMemberPlanRequestEntity {
  const FamilyMemberPlanRequestEntity({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final int tier;
  final int durationDays;
  final bool includeFriday;
}
