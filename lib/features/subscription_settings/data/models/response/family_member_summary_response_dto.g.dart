// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_summary_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberSummaryResponseDto _$FamilyMemberSummaryResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberSummaryResponseDto(
  memberId: json['memberId'] as String?,
  displayName: json['displayName'] as String?,
  role: json['role'],
  ageYears: (json['ageYears'] as num?)?.toInt(),
  isPaused: json['isPaused'] as bool?,
  memberSubscriptionId: json['memberSubscriptionId'] as String?,
  programNameAr: json['programNameAr'] as String?,
  programNameEn: json['programNameEn'] as String?,
  programName: json['programName'] as String?,
  programLabelAr: json['programLabelAr'] as String?,
  programLabelEn: json['programLabelEn'] as String?,
  programLabel: json['programLabel'] as String?,
  remainingDays: (json['remainingDays'] as num?)?.toInt(),
  setupStatus: json['setupStatus'],
  todayUiStatus: json['todayUiStatus'] as String?,
  todayFilledCount: (json['todayFilledCount'] as num?)?.toInt(),
  todayRequiredCount: (json['todayRequiredCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$FamilyMemberSummaryResponseDtoToJson(
  FamilyMemberSummaryResponseDto instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'displayName': instance.displayName,
  'role': instance.role,
  'ageYears': instance.ageYears,
  'isPaused': instance.isPaused,
  'memberSubscriptionId': instance.memberSubscriptionId,
  'programNameAr': instance.programNameAr,
  'programNameEn': instance.programNameEn,
  'programName': instance.programName,
  'programLabelAr': instance.programLabelAr,
  'programLabelEn': instance.programLabelEn,
  'programLabel': instance.programLabel,
  'remainingDays': instance.remainingDays,
  'setupStatus': instance.setupStatus,
  'todayUiStatus': instance.todayUiStatus,
  'todayFilledCount': instance.todayFilledCount,
  'todayRequiredCount': instance.todayRequiredCount,
};
