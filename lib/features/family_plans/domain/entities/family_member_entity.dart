class FamilyMemberEntity {
  final String memberId;
  final int role;
  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
  final int setupStatus;
  final String? programId;
  final String? bundleId;
  final int? selectedTier;
  final int? durationDays;
  final bool includeFriday;
  final bool isCurrentUser;

  const FamilyMemberEntity({
    required this.memberId,
    required this.role,
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
    required this.setupStatus,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    required this.includeFriday,
    required this.isCurrentUser,
  });

  bool get isManager => role == 1 || isCurrentUser;
  bool get isReady => setupStatus == 3;
}
