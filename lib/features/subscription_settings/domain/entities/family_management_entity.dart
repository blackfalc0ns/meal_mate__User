class FamilyHomeEntity {
  const FamilyHomeEntity({
    required this.groupId,
    required this.name,
    required this.status,
    required this.packageName,
    required this.price,
    required this.currencyCode,
    required this.walletAvailable,
    required this.shortcuts,
    required this.members,
    required this.todaySchedule,
  });

  final String groupId;
  final String name;
  final int status;
  final String packageName;
  final double price;
  final String currencyCode;
  final bool walletAvailable;
  final List<FamilyShortcutEntity> shortcuts;
  final List<FamilyMemberSummaryEntity> members;
  final List<FamilyMemberSummaryEntity> todaySchedule;
}

class FamilyShortcutEntity {
  const FamilyShortcutEntity({required this.code, required this.enabled});
  final String code;
  final bool enabled;
}

class FamilyMemberSummaryEntity {
  const FamilyMemberSummaryEntity({
    required this.memberId,
    required this.displayName,
    required this.role,
    required this.ageYears,
    required this.isPaused,
    required this.subscriptionId,
    required this.programName,
    required this.remainingDays,
    required this.setupStatus,
    this.todayUiStatus,
    this.todayFilledCount = 0,
    this.todayRequiredCount = 0,
  });

  final String memberId;
  final String displayName;
  final int role;
  final int? ageYears;
  final bool isPaused;
  final String? subscriptionId;
  final String programName;
  final int remainingDays;
  final int setupStatus;
  final String? todayUiStatus;
  final int todayFilledCount;
  final int todayRequiredCount;

  bool get isManager => role == 1;
  bool get hasPlan => subscriptionId?.isNotEmpty == true;
}

class FamilyMemberDetailEntity {
  const FamilyMemberDetailEntity({
    required this.memberId,
    required this.displayName,
    required this.role,
    required this.ageYears,
    required this.isPaused,
    required this.subscriptionId,
    required this.programName,
    required this.remainingDays,
    required this.setupStatus,
    required this.canRenew,
    this.relationshipCode,
    this.phoneNumber,
    this.startDate,
    this.endDate,
    this.renewalPath,
    this.todayNutrition,
    this.hasSeparateAccount = false,
  });

  final String memberId;
  final String displayName;
  final int role;
  final int? ageYears;
  final bool isPaused;
  final String? subscriptionId;
  final String programName;
  final int remainingDays;
  final int setupStatus;
  final bool canRenew;
  final String? relationshipCode;
  final String? phoneNumber;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? renewalPath;
  final FamilyNutritionEntity? todayNutrition;
  final bool hasSeparateAccount;

  bool get hasPlan => subscriptionId?.isNotEmpty == true;
  bool get isManager => role == 1;
}

class FamilyNutritionEntity {
  const FamilyNutritionEntity({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

class FamilyMemberAccessEntityV2 {
  const FamilyMemberAccessEntityV2({
    required this.memberId,
    required this.hasSeparateAccount,
    required this.isPaused,
    required this.hasExistingLogin,
    this.linkedCustomerUserId,
    this.pausedAtUtc,
    this.removedAtUtc,
    this.inviteDeepLink,
    this.inviteExpiresAtUtc,
    this.phoneNumber,
    this.generatedPassword,
  });
  final String memberId;
  final bool hasSeparateAccount;
  final bool isPaused;
  final bool hasExistingLogin;
  final String? linkedCustomerUserId;
  final DateTime? pausedAtUtc;
  final DateTime? removedAtUtc;
  final String? inviteDeepLink;
  final DateTime? inviteExpiresAtUtc;
  final String? phoneNumber;
  final String? generatedPassword;

  FamilyMemberAccessEntityV2 clearGeneratedPassword() =>
      FamilyMemberAccessEntityV2(
        memberId: memberId,
        hasSeparateAccount: hasSeparateAccount,
        isPaused: isPaused,
        hasExistingLogin: hasExistingLogin,
        linkedCustomerUserId: linkedCustomerUserId,
        pausedAtUtc: pausedAtUtc,
        removedAtUtc: removedAtUtc,
        inviteDeepLink: inviteDeepLink,
        inviteExpiresAtUtc: inviteExpiresAtUtc,
        phoneNumber: phoneNumber,
      );
}

class FamilyMemberPermissionsEntity {
  const FamilyMemberPermissionsEntity({
    required this.memberId,
    required this.values,
    required this.groups,
  });
  final String memberId;
  final Map<String, bool> values;
  final List<FamilyPermissionGroupEntity> groups;
}

class FamilyPermissionGroupEntity {
  const FamilyPermissionGroupEntity({
    required this.code,
    required this.label,
    required this.permissions,
  });
  final String code;
  final String label;
  final List<FamilyPermissionItemEntity> permissions;
}

class FamilyPermissionItemEntity {
  const FamilyPermissionItemEntity({
    required this.key,
    required this.label,
    required this.value,
  });
  final String key;
  final String label;
  final bool value;
}
