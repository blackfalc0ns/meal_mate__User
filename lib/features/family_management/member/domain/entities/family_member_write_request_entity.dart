class FamilyMemberWriteRequestEntity {
  const FamilyMemberWriteRequestEntity({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
    this.phone,
    this.occupation,
  });

  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
  final String? phone;
  final String? occupation;
}
