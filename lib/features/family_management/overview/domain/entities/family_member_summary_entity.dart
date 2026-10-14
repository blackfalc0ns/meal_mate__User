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
    this.upcomingSubscriptionId,
    this.upcomingStartDate,
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
  final String? upcomingSubscriptionId;
  final String? upcomingStartDate;

  bool get isManager => role == 1;
  bool get hasPlan => subscriptionId?.isNotEmpty == true;
  String? get effectiveSubscriptionId =>
      (subscriptionId != null && subscriptionId!.isNotEmpty)
      ? subscriptionId
      : upcomingSubscriptionId;

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
