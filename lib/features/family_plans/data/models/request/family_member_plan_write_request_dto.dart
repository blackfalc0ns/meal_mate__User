class FamilyMemberPlanWriteRequestDto {
  final String programId;
  final String bundleId;
  final int tier;
  final int durationDays;
  final bool includeFriday;

  FamilyMemberPlanWriteRequestDto({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.includeFriday,
  });

  Map<String, dynamic> toJson() => {
        'programId': programId,
        'bundleId': bundleId,
        'tier': tier,
        'durationDays': durationDays,
        'includeFriday': includeFriday,
      };
}
