class FamilyMemberLookupEntity {
  const FamilyMemberLookupEntity({
    required this.found,
    this.displayName,
    this.ageYears,
    this.gender,
  });

  final bool found;
  final String? displayName;
  final int? ageYears;
  final int? gender;
}
