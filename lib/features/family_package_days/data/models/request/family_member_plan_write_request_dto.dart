class FamilyMemberPlanWriteRequestDto {
  final String? programId;
  final String? bundleId;
  final int? tier;
  final int? durationDays;
  final bool? includeFriday;

  FamilyMemberPlanWriteRequestDto({
    this.programId,
    this.bundleId,
    this.tier,
    this.durationDays,
    this.includeFriday,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (programId != null) map['programId'] = programId;
    if (bundleId != null) map['bundleId'] = bundleId;
    if (tier != null) map['tier'] = tier;
    if (durationDays != null) map['durationDays'] = durationDays;
    if (includeFriday != null) map['includeFriday'] = includeFriday;
    return map;
  }
}
