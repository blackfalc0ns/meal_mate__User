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
    this.lifecycleStatus,
    this.checkoutSelected = false,
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
  final String? lifecycleStatus;
  final bool checkoutSelected;

  bool get isManager => role == 1;
  bool get hasPlan => subscriptionId?.isNotEmpty == true;
  bool get isUnsubscribed =>
      (lifecycleStatus?.toLowerCase() == 'unsubscribed') ||
      (!hasPlan && setupStatus == 0);
  bool get isSetupIncomplete =>
      (lifecycleStatus?.toLowerCase() == 'setupincomplete') ||
      (!hasPlan && setupStatus == 1);
  bool get isReadyToPay =>
      (lifecycleStatus?.toLowerCase() == 'readytopay') ||
      (!hasPlan && setupStatus == 2);
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
    this.currentSubscriptionId,
    this.upcomingSubscriptionId,
    this.relationshipCode,
    this.phoneNumber,
    this.startDate,
    this.endDate,
    this.renewalPath,
    this.todayNutrition,
    this.hasSeparateAccount = false,
    this.lifecycleStatus,
    this.checkoutSelected = false,
  });

  final String memberId;
  final String displayName;
  final int role;
  final int? ageYears;
  final bool isPaused;
  final String? subscriptionId;
  final String? currentSubscriptionId;
  final String? upcomingSubscriptionId;
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
  final String? lifecycleStatus;
  final bool checkoutSelected;

  bool get hasPlan => (subscriptionId?.isNotEmpty == true) || (currentSubscriptionId?.isNotEmpty == true);
  bool get hasUpcomingSubscription => upcomingSubscriptionId?.isNotEmpty == true;
  bool get isManager => role == 1;
  bool get isUnsubscribed =>
      (lifecycleStatus?.toLowerCase() == 'unsubscribed') ||
      (!hasPlan && setupStatus == 0);
  bool get isSetupIncomplete =>
      (lifecycleStatus?.toLowerCase() == 'setupincomplete') ||
      (!hasPlan && setupStatus == 1);
  bool get isReadyToPay =>
      (lifecycleStatus?.toLowerCase() == 'readytopay') ||
      (!hasPlan && setupStatus == 2);

  /// Returns true if current service remains active through its inclusive end date.
  bool isServiceActive({DateTime? atDate}) {
    if (endDate == null) return hasPlan;
    final checkDate = atDate ?? DateTime.now();
    final endOfDay = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
    return !checkDate.isAfter(endOfDay);
  }

  /// Evaluates whether an upcoming subscription has officially begun.
  /// Current subscription remains the authoritative active service until upcoming starts.
  bool isUpcomingActive({DateTime? atDate, DateTime? upcomingStartDate}) {
    if (!hasUpcomingSubscription || upcomingStartDate == null) return false;
    final checkDate = atDate ?? DateTime.now();
    return !checkDate.isBefore(upcomingStartDate);
  }
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
    this.version,
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
  final int? version;

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
        version: version,
      );
}

class FamilyMemberPermissionsEntity {
  const FamilyMemberPermissionsEntity({
    required this.memberId,
    required this.values,
    required this.groups,
    this.version,
  });
  final String memberId;
  final Map<String, bool> values;
  final List<FamilyPermissionGroupEntity> groups;
  final int? version;
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
