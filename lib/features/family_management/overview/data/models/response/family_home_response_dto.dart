class FamilyHomeResponseDto {
  const FamilyHomeResponseDto({
    required this.groupId,
    required this.name,
    required this.status,
    this.packageLabelAr,
    this.packageLabelEn,
    required this.quotedFinalPrice,
    required this.currencyCode,
    this.members = const [],
    this.todaySchedule = const [],
    this.shortcuts = const [],
    this.wallet,
  });

  final String groupId;
  final String name;
  final String status;
  final String? packageLabelAr;
  final String? packageLabelEn;
  final double quotedFinalPrice;
  final String currencyCode;
  final List<FamilyHomeMemberDto> members;
  final List<FamilyHomeMemberDto> todaySchedule;
  final List<FamilyShortcutDto> shortcuts;
  final FamilyWalletDto? wallet;

  factory FamilyHomeResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyHomeResponseDto(
      groupId: json['groupId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      packageLabelAr: json['packageLabelAr']?.toString(),
      packageLabelEn: json['packageLabelEn']?.toString(),
      quotedFinalPrice: (json['quotedFinalPrice'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currencyCode']?.toString() ?? 'KWD',
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => FamilyHomeMemberDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      todaySchedule: (json['todaySchedule'] as List<dynamic>?)
              ?.map((e) => FamilyHomeMemberDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shortcuts: (json['shortcuts'] as List<dynamic>?)
              ?.map((e) => FamilyShortcutDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      wallet: json['wallet'] is Map<String, dynamic>
          ? FamilyWalletDto.fromJson(json['wallet'] as Map<String, dynamic>)
          : null,
    );
  }
}

class FamilyHomeMemberDto {
  const FamilyHomeMemberDto({
    required this.memberId,
    required this.displayName,
    required this.role,
    this.isPaused = false,
    this.memberSubscriptionId,
    this.programLabelAr,
    this.programLabelEn,
    this.todayUiStatus,
    this.todayFilledCount = 0,
    this.todayRequiredCount = 0,
    this.remainingDays = 0,
    this.lifecycle,
    this.upcomingSubscriptionId,
    this.upcomingStartDate,
  });

  final String memberId;
  final String displayName;
  final String role;
  final bool isPaused;
  final String? memberSubscriptionId;
  final String? programLabelAr;
  final String? programLabelEn;
  final String? todayUiStatus;
  final int todayFilledCount;
  final int todayRequiredCount;
  final int remainingDays;
  final FamilyMemberLifecycleDto? lifecycle;
  final String? upcomingSubscriptionId;
  final String? upcomingStartDate;

  bool get isManager => role.toLowerCase() == 'manager';

  factory FamilyHomeMemberDto.fromJson(Map<String, dynamic> json) {
    return FamilyHomeMemberDto(
      memberId: json['memberId']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Member',
      isPaused: json['isPaused'] as bool? ?? false,
      memberSubscriptionId: json['memberSubscriptionId']?.toString(),
      programLabelAr: json['programLabelAr']?.toString(),
      programLabelEn: json['programLabelEn']?.toString(),
      todayUiStatus: json['todayUiStatus']?.toString(),
      todayFilledCount: (json['todayFilledCount'] as num?)?.toInt() ?? 0,
      todayRequiredCount: (json['todayRequiredCount'] as num?)?.toInt() ?? 0,
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 0,
      lifecycle: json['lifecycle'] is Map<String, dynamic>
          ? FamilyMemberLifecycleDto.fromJson(
              json['lifecycle'] as Map<String, dynamic>)
          : null,
      upcomingSubscriptionId: json['upcomingSubscriptionId']?.toString(),
      upcomingStartDate: json['upcomingStartDate']?.toString(),
    );
  }
}

class FamilyShortcutDto {
  const FamilyShortcutDto({
    required this.code,
    required this.enabled,
    this.unavailableReason,
  });

  final String code;
  final bool enabled;
  final String? unavailableReason;

  factory FamilyShortcutDto.fromJson(Map<String, dynamic> json) {
    return FamilyShortcutDto(
      code: json['code']?.toString() ?? '',
      enabled: json['enabled'] as bool? ?? false,
      unavailableReason: json['unavailableReason']?.toString(),
    );
  }
}

class FamilyWalletDto {
  const FamilyWalletDto({
    this.available = false,
    this.unavailableReason,
  });

  final bool available;
  final String? unavailableReason;

  factory FamilyWalletDto.fromJson(Map<String, dynamic> json) {
    return FamilyWalletDto(
      available: json['available'] as bool? ?? false,
      unavailableReason: json['unavailableReason']?.toString(),
    );
  }
}

class FamilyMemberLifecycleDto {
  const FamilyMemberLifecycleDto({
    this.setupStatus,
    this.checkoutSelected = false,
    this.paymentStatus,
    this.fulfillmentStatus,
    this.serviceStatus,
    this.accessStatus,
    this.displayStatus,
  });

  final String? setupStatus;
  final bool checkoutSelected;
  final String? paymentStatus;
  final String? fulfillmentStatus;
  final String? serviceStatus;
  final String? accessStatus;
  final String? displayStatus;

  factory FamilyMemberLifecycleDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberLifecycleDto(
      setupStatus: json['setupStatus']?.toString(),
      checkoutSelected: json['checkoutSelected'] as bool? ?? false,
      paymentStatus: json['paymentStatus']?.toString(),
      fulfillmentStatus: json['fulfillmentStatus']?.toString(),
      serviceStatus: json['serviceStatus']?.toString(),
      accessStatus: json['accessStatus']?.toString(),
      displayStatus: json['displayStatus']?.toString(),
    );
  }
}
