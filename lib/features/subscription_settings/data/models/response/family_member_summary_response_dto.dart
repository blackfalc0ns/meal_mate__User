import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';

part 'family_member_summary_response_dto.g.dart';

@JsonSerializable()
class FamilyMemberSummaryResponseDto {
  const FamilyMemberSummaryResponseDto({
    this.memberId,
    this.displayName,
    this.role,
    this.ageYears,
    this.isPaused,
    this.memberSubscriptionId,
    this.upcomingSubscriptionId,
    this.upcomingStartDate,
    this.programNameAr,
    this.programNameEn,
    this.programName,
    this.programLabelAr,
    this.programLabelEn,
    this.programLabel,
    this.remainingDays,
    this.setupStatus,
    this.todayUiStatus,
    this.todayFilledCount,
    this.todayRequiredCount,
    this.lifecycle,
  });
  final String? memberId;
  final String? displayName;
  final Object? role;
  final int? ageYears;
  final bool? isPaused;
  final String? memberSubscriptionId;
  final String? upcomingSubscriptionId;
  final String? upcomingStartDate;
  final String? programNameAr;
  final String? programNameEn;
  final String? programName;
  final String? programLabelAr;
  final String? programLabelEn;
  final String? programLabel;
  final int? remainingDays;
  final Object? setupStatus;
  final String? todayUiStatus;
  final int? todayFilledCount;
  final int? todayRequiredCount;
  final FamilyMemberLifecycleResponseDto? lifecycle;

  factory FamilyMemberSummaryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberSummaryResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberSummaryResponseDtoToJson(this);
}
