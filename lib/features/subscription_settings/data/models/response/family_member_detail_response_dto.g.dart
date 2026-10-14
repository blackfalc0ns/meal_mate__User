// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_detail_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberDetailResponseDto _$FamilyMemberDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberDetailResponseDto(
  memberId: json['memberId'] as String?,
  displayName: json['displayName'] as String?,
  role: json['role'],
  relationshipCode: json['relationshipCode'] as String?,
  ageYears: (json['ageYears'] as num?)?.toInt(),
  setupStatus: json['setupStatus'],
  memberSubscriptionId: json['memberSubscriptionId'] as String?,
  currentSubscriptionId: json['currentSubscriptionId'] as String?,
  upcomingSubscriptionId: json['upcomingSubscriptionId'] as String?,
  programNameAr: json['programNameAr'] as String?,
  programNameEn: json['programNameEn'] as String?,
  programName: json['programName'] as String?,
  isPaused: json['isPaused'] as bool?,
  hasSeparateAccount: json['hasSeparateAccount'] as bool?,
  phoneNumber: json['phoneNumber'] as String?,
  remainingDays: (json['remainingDays'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  canRenew: json['canRenew'] as bool?,
  renewalPath: json['renewalPath'] as String?,
  todayNutrition: json['todayNutrition'] == null
      ? null
      : FamilyNutritionResponseDto.fromJson(
          json['todayNutrition'] as Map<String, dynamic>,
        ),
  lifecycle: json['lifecycle'] == null
      ? null
      : FamilyMemberLifecycleResponseDto.fromJson(
          json['lifecycle'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FamilyMemberDetailResponseDtoToJson(
  FamilyMemberDetailResponseDto instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'displayName': instance.displayName,
  'role': instance.role,
  'relationshipCode': instance.relationshipCode,
  'ageYears': instance.ageYears,
  'setupStatus': instance.setupStatus,
  'memberSubscriptionId': instance.memberSubscriptionId,
  'currentSubscriptionId': instance.currentSubscriptionId,
  'upcomingSubscriptionId': instance.upcomingSubscriptionId,
  'programNameAr': instance.programNameAr,
  'programNameEn': instance.programNameEn,
  'programName': instance.programName,
  'isPaused': instance.isPaused,
  'hasSeparateAccount': instance.hasSeparateAccount,
  'phoneNumber': instance.phoneNumber,
  'remainingDays': instance.remainingDays,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'canRenew': instance.canRenew,
  'renewalPath': instance.renewalPath,
  'todayNutrition': instance.todayNutrition,
  'lifecycle': instance.lifecycle,
};

FamilyMemberLifecycleResponseDto _$FamilyMemberLifecycleResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberLifecycleResponseDto(
  status: json['status'] as String?,
  checkoutSelected: json['checkoutSelected'] as bool?,
  paymentStatus: json['paymentStatus'] as String?,
  fulfillmentStatus: json['fulfillmentStatus'] as String?,
  serviceStatus: json['serviceStatus'] as String?,
  accessStatus: json['accessStatus'] as String?,
  displayStatus: json['displayStatus'] as String?,
);

Map<String, dynamic> _$FamilyMemberLifecycleResponseDtoToJson(
  FamilyMemberLifecycleResponseDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'checkoutSelected': instance.checkoutSelected,
  'paymentStatus': instance.paymentStatus,
  'fulfillmentStatus': instance.fulfillmentStatus,
  'serviceStatus': instance.serviceStatus,
  'accessStatus': instance.accessStatus,
  'displayStatus': instance.displayStatus,
};

FamilyNutritionResponseDto _$FamilyNutritionResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyNutritionResponseDto(
  calories: (json['calories'] as num?)?.toDouble(),
  proteinG: (json['proteinG'] as num?)?.toDouble(),
  carbsG: (json['carbsG'] as num?)?.toDouble(),
  fatG: (json['fatG'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FamilyNutritionResponseDtoToJson(
  FamilyNutritionResponseDto instance,
) => <String, dynamic>{
  'calories': instance.calories,
  'proteinG': instance.proteinG,
  'carbsG': instance.carbsG,
  'fatG': instance.fatG,
};
