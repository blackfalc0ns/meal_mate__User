class FamilyMemberRequestEntity {
  const FamilyMemberRequestEntity({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    required this.nutritionalGoalCode,
    required this.activityLevel,
    required this.deliveryAddressId,
  });

  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String nutritionalGoalCode;
  final int activityLevel;
  final String deliveryAddressId;
}
