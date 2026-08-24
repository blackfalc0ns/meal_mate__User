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
  bool get hasProgram => programId != null && programId!.isNotEmpty;
  bool get isPlanCompleted =>
      hasProgram &&
      (bundleId != null && bundleId!.isNotEmpty) &&
      selectedTier != null &&
      (durationDays != null && durationDays! > 0);

  bool get isReady => setupStatus == 3 || isPlanCompleted;

  FamilyMemberEntity copyWith({
    String? memberId,
    int? role,
    String? displayName,
    String? relationshipCode,
    int? gender,
    int? ageYears,
    String? deliveryAddressId,
    int? setupStatus,
    String? programId,
    String? bundleId,
    int? selectedTier,
    int? durationDays,
    bool? includeFriday,
    bool? isCurrentUser,
    bool clearProgramId = false,
    bool clearBundleId = false,
    bool clearSelectedTier = false,
    bool clearDurationDays = false,
  }) {
    return FamilyMemberEntity(
      memberId: memberId ?? this.memberId,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      relationshipCode: relationshipCode ?? this.relationshipCode,
      gender: gender ?? this.gender,
      ageYears: ageYears ?? this.ageYears,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      setupStatus: setupStatus ?? this.setupStatus,
      programId: clearProgramId ? null : (programId ?? this.programId),
      bundleId: clearBundleId ? null : (bundleId ?? this.bundleId),
      selectedTier: clearSelectedTier
          ? null
          : (selectedTier ?? this.selectedTier),
      durationDays: clearDurationDays
          ? null
          : (durationDays ?? this.durationDays),
      includeFriday: includeFriday ?? this.includeFriday,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
