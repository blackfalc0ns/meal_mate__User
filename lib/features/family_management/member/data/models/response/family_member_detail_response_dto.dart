import 'package:meal_meat_user/features/family_management/overview/data/models/response/family_home_response_dto.dart';

class FamilyMemberDetailResponseDto {
  const FamilyMemberDetailResponseDto({
    required this.memberId,
    required this.displayName,
    required this.role,
    required this.relationshipCode,
    this.gender = '',
    this.ageYears = 0,
    this.nutritionalGoalCode,
    this.activityLevel,
    required this.setupStatus,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    this.includeFriday = false,
    this.memberSubscriptionId,
    this.programNameAr,
    this.programNameEn,
    this.isPaused = false,
    this.hasSeparateAccount = false,
    this.linkedCustomerUserId,
    this.phoneNumber,
    this.remainingDays = 0,
    this.startDate,
    this.endDate,
    this.canRenew = false,
    this.renewalPath,
    this.todayNutrition,
    this.countryCode,
    this.nationalPhoneNumber,
    this.lifecycle,
    this.upcomingSubscriptionId,
    this.upcomingStartDate,
  });

  final String memberId;
  final String displayName;
  final String role;
  final String relationshipCode;
  final String gender;
  final int ageYears;
  final String? nutritionalGoalCode;
  final String? activityLevel;
  final String setupStatus;
  final String? programId;
  final String? bundleId;
  final String? selectedTier;
  final int? durationDays;
  final bool includeFriday;
  final String? memberSubscriptionId;
  final String? programNameAr;
  final String? programNameEn;
  final bool isPaused;
  final bool hasSeparateAccount;
  final String? linkedCustomerUserId;
  final String? phoneNumber;
  final int remainingDays;
  final String? startDate;
  final String? endDate;
  final bool canRenew;
  final String? renewalPath;
  final FamilyNutritionDto? todayNutrition;
  final String? countryCode;
  final String? nationalPhoneNumber;
  final FamilyMemberLifecycleDto? lifecycle;
  final String? upcomingSubscriptionId;
  final String? upcomingStartDate;

  bool get isManager => role.toLowerCase() == 'manager';

  factory FamilyMemberDetailResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDetailResponseDto(
      memberId: json['memberId']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Member',
      relationshipCode: json['relationshipCode']?.toString() ?? 'other',
      gender: json['gender']?.toString() ?? '',
      ageYears: (json['ageYears'] as num?)?.toInt() ?? 0,
      nutritionalGoalCode: json['nutritionalGoalCode']?.toString(),
      activityLevel: json['activityLevel']?.toString(),
      setupStatus: json['setupStatus']?.toString() ?? 'NotStarted',
      programId: json['programId']?.toString(),
      bundleId: json['bundleId']?.toString(),
      selectedTier: json['selectedTier']?.toString(),
      durationDays: (json['durationDays'] as num?)?.toInt(),
      includeFriday: json['includeFriday'] as bool? ?? false,
      memberSubscriptionId: json['memberSubscriptionId']?.toString(),
      programNameAr: json['programNameAr']?.toString(),
      programNameEn: json['programNameEn']?.toString(),
      isPaused: json['isPaused'] as bool? ?? false,
      hasSeparateAccount: json['hasSeparateAccount'] as bool? ?? false,
      linkedCustomerUserId: json['linkedCustomerUserId']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 0,
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      canRenew: json['canRenew'] as bool? ?? false,
      renewalPath: json['renewalPath']?.toString(),
      todayNutrition: json['todayNutrition'] is Map<String, dynamic>
          ? FamilyNutritionDto.fromJson(
              json['todayNutrition'] as Map<String, dynamic>)
          : null,
      countryCode: json['countryCode']?.toString(),
      nationalPhoneNumber: json['nationalPhoneNumber']?.toString(),
      lifecycle: json['lifecycle'] is Map<String, dynamic>
          ? FamilyMemberLifecycleDto.fromJson(
              json['lifecycle'] as Map<String, dynamic>)
          : null,
      upcomingSubscriptionId: json['upcomingSubscriptionId']?.toString(),
      upcomingStartDate: json['upcomingStartDate']?.toString(),
    );
  }
}

class FamilyNutritionDto {
  const FamilyNutritionDto({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
  });

  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  factory FamilyNutritionDto.fromJson(Map<String, dynamic> json) {
    return FamilyNutritionDto(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      proteinG: (json['proteinG'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['carbsG'] as num?)?.toDouble() ?? 0.0,
      fatG: (json['fatG'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
