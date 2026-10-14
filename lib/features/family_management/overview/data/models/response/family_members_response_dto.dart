import 'package:meal_meat_user/features/family_management/overview/data/models/response/family_home_response_dto.dart';

class FamilyMemberListItemDto {
  const FamilyMemberListItemDto({
    required this.memberId,
    required this.displayName,
    required this.role,
    this.ageYears = 0,
    this.isPaused = false,
    this.memberSubscriptionId,
    this.programNameAr,
    this.programNameEn,
    this.remainingDays = 0,
    required this.setupStatus,
    this.lifecycle,
    this.upcomingSubscriptionId,
    this.upcomingStartDate,
  });

  final String memberId;
  final String displayName;
  final String role;
  final int ageYears;
  final bool isPaused;
  final String? memberSubscriptionId;
  final String? programNameAr;
  final String? programNameEn;
  final int remainingDays;
  final String setupStatus;
  final FamilyMemberLifecycleDto? lifecycle;
  final String? upcomingSubscriptionId;
  final String? upcomingStartDate;

  bool get isManager => role.toLowerCase() == 'manager';

  factory FamilyMemberListItemDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberListItemDto(
      memberId: json['memberId']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Member',
      ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
      isPaused: json['isPaused'] as bool? ?? false,
      memberSubscriptionId: json['memberSubscriptionId']?.toString(),
      programNameAr: json['programNameAr']?.toString(),
      programNameEn: json['programNameEn']?.toString(),
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 0,
      setupStatus: json['setupStatus']?.toString() ?? 'NotStarted',
      lifecycle: json['lifecycle'] is Map<String, dynamic>
          ? FamilyMemberLifecycleDto.fromJson(
              json['lifecycle'] as Map<String, dynamic>,
            )
          : null,
      upcomingSubscriptionId: json['upcomingSubscriptionId']?.toString(),
      upcomingStartDate: json['upcomingStartDate']?.toString(),
    );
  }
}
