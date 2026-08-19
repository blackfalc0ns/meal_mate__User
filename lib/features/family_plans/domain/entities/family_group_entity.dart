enum FamilyGroupStatus {
  draft(1),
  checkoutPending(2),
  active(3),
  frozen(4),
  dispute(5),
  pendingDetach(6),
  cancelled(7);

  const FamilyGroupStatus(this.value);
  final int value;

  static FamilyGroupStatus fromValue(int? value) {
    switch (value) {
      case 1:
        return FamilyGroupStatus.draft;
      case 2:
        return FamilyGroupStatus.checkoutPending;
      case 3:
        return FamilyGroupStatus.active;
      case 4:
        return FamilyGroupStatus.frozen;
      case 5:
        return FamilyGroupStatus.dispute;
      case 6:
        return FamilyGroupStatus.pendingDetach;
      case 7:
        return FamilyGroupStatus.cancelled;
      default:
        return FamilyGroupStatus.draft;
    }
  }
}

enum FamilyMemberRole {
  manager(1),
  member(2);

  const FamilyMemberRole(this.value);
  final int value;

  static FamilyMemberRole fromValue(int? value) {
    switch (value) {
      case 1:
        return FamilyMemberRole.manager;
      case 2:
        return FamilyMemberRole.member;
      default:
        return FamilyMemberRole.member;
    }
  }
}

enum FamilyMemberSetupStatus {
  notStarted(1),
  inProgress(2),
  ready(3);

  const FamilyMemberSetupStatus(this.value);
  final int value;

  static FamilyMemberSetupStatus fromValue(int? value) {
    switch (value) {
      case 1:
        return FamilyMemberSetupStatus.notStarted;
      case 2:
        return FamilyMemberSetupStatus.inProgress;
      case 3:
        return FamilyMemberSetupStatus.ready;
      default:
        return FamilyMemberSetupStatus.notStarted;
    }
  }
}

enum FamilyGender {
  male(1),
  female(2);

  const FamilyGender(this.value);
  final int value;

  static FamilyGender fromValue(int? value) {
    switch (value) {
      case 1:
        return FamilyGender.male;
      case 2:
        return FamilyGender.female;
      default:
        return FamilyGender.male;
    }
  }
}

enum FamilyActivityLevel {
  sedentary(1),
  moderate(2),
  active(3);

  const FamilyActivityLevel(this.value);
  final int value;

  static FamilyActivityLevel fromValue(int? value) {
    switch (value) {
      case 1:
        return FamilyActivityLevel.sedentary;
      case 2:
        return FamilyActivityLevel.moderate;
      case 3:
        return FamilyActivityLevel.active;
      default:
        return FamilyActivityLevel.sedentary;
    }
  }
}

enum FamilyTier {
  basic(1),
  platinum(2),
  elite(3);

  const FamilyTier(this.value);
  final int value;

  static FamilyTier fromValue(int? value) {
    switch (value) {
      case 1:
        return FamilyTier.basic;
      case 2:
        return FamilyTier.platinum;
      case 3:
        return FamilyTier.elite;
      default:
        return FamilyTier.basic;
    }
  }
}

class FamilyGroupEntity {
  const FamilyGroupEntity({
    required this.familyGroupId,
    required this.name,
    required this.status,
    required this.maxMembers,
    required this.discountPercent,
    required this.currentStep,
    required this.members,
  });

  final String familyGroupId;
  final String name;
  final FamilyGroupStatus status;
  final int maxMembers;
  final double discountPercent;
  final int currentStep;
  final List<FamilyGroupMemberEntity> members;
}

class FamilyGroupMemberEntity {
  const FamilyGroupMemberEntity({
    required this.memberId,
    required this.role,
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    required this.nutritionalGoalCode,
    required this.activityLevel,
    required this.deliveryAddressId,
    required this.setupStatus,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    this.includeFriday = false,
  });

  final String memberId;
  final FamilyMemberRole role;
  final String displayName;
  final String relationshipCode;
  final FamilyGender gender;
  final int ageYears;
  final String nutritionalGoalCode;
  final FamilyActivityLevel activityLevel;
  final String deliveryAddressId;
  final FamilyMemberSetupStatus setupStatus;
  final String? programId;
  final String? bundleId;
  final FamilyTier? selectedTier;
  final int? durationDays;
  final bool includeFriday;

  bool get isManager => role == FamilyMemberRole.manager;
  bool get isReady => setupStatus == FamilyMemberSetupStatus.ready;
}
