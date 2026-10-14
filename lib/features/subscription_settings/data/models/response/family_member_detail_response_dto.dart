import 'package:json_annotation/json_annotation.dart';

part 'family_member_detail_response_dto.g.dart';

@JsonSerializable()
class FamilyMemberDetailResponseDto {
  const FamilyMemberDetailResponseDto({
    this.memberId,
    this.displayName,
    this.role,
    this.relationshipCode,
    this.ageYears,
    this.setupStatus,
    this.memberSubscriptionId,
    this.currentSubscriptionId,
    this.upcomingSubscriptionId,
    this.programNameAr,
    this.programNameEn,
    this.programName,
    this.isPaused,
    this.hasSeparateAccount,
    this.phoneNumber,
    this.remainingDays,
    this.startDate,
    this.endDate,
    this.canRenew,
    this.renewalPath,
    this.todayNutrition,
    this.lifecycle,
  });
  final String? memberId;
  final String? displayName;
  final Object? role;
  final String? relationshipCode;
  final int? ageYears;
  final Object? setupStatus;
  final String? memberSubscriptionId;
  final String? currentSubscriptionId;
  final String? upcomingSubscriptionId;
  final String? programNameAr;
  final String? programNameEn;
  final String? programName;
  final bool? isPaused;
  final bool? hasSeparateAccount;
  final String? phoneNumber;
  final int? remainingDays;
  final String? startDate;
  final String? endDate;
  final bool? canRenew;
  final String? renewalPath;
  final FamilyNutritionResponseDto? todayNutrition;
  final FamilyMemberLifecycleResponseDto? lifecycle;
  factory FamilyMemberDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberDetailResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberDetailResponseDtoToJson(this);
}

@JsonSerializable()
class FamilyMemberLifecycleResponseDto {
  const FamilyMemberLifecycleResponseDto({
    this.status,
    this.checkoutSelected,
    this.paymentStatus,
    this.fulfillmentStatus,
    this.serviceStatus,
    this.accessStatus,
    this.displayStatus,
  });

  final String? status;
  final bool? checkoutSelected;
  final String? paymentStatus;
  final String? fulfillmentStatus;
  final String? serviceStatus;
  final String? accessStatus;
  final String? displayStatus;

  factory FamilyMemberLifecycleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberLifecycleResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberLifecycleResponseDtoToJson(this);
}

@JsonSerializable()
class FamilyNutritionResponseDto {
  const FamilyNutritionResponseDto({
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
  });
  final double? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  factory FamilyNutritionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyNutritionResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyNutritionResponseDtoToJson(this);
}
