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

  bool get hasPlan =>
      (subscriptionId?.isNotEmpty == true) ||
      (currentSubscriptionId?.isNotEmpty == true);
  bool get hasUpcomingSubscription =>
      upcomingSubscriptionId?.isNotEmpty == true;
  bool get isManager => role == 1;

  String? get effectiveSubscriptionId =>
      (currentSubscriptionId?.isNotEmpty == true)
          ? currentSubscriptionId
          : (subscriptionId?.isNotEmpty == true
              ? subscriptionId
              : upcomingSubscriptionId);

  bool get isUnsubscribed =>
      (lifecycleStatus?.toLowerCase() == 'unsubscribed') ||
      (!hasPlan && setupStatus == 0);
  bool get isSetupIncomplete =>
      (lifecycleStatus?.toLowerCase() == 'setupincomplete') ||
      (!hasPlan && setupStatus == 1);
  bool get isReadyToPay =>
      (lifecycleStatus?.toLowerCase() == 'readytopay') ||
      (!hasPlan && setupStatus == 2);

  bool isServiceActive({DateTime? atDate}) {
    if (endDate == null) return hasPlan;
    final checkDate = atDate ?? DateTime.now();
    final endOfDay =
        DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
    return !checkDate.isAfter(endOfDay);
  }

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
