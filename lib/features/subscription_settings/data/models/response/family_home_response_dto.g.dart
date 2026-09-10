// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_home_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyHomeResponseDto _$FamilyHomeResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyHomeResponseDto(
  groupId: json['groupId'] as String?,
  name: json['name'] as String?,
  status: json['status'],
  packageLabelAr: json['packageLabelAr'] as String?,
  packageLabelEn: json['packageLabelEn'] as String?,
  quotedFinalPrice: (json['quotedFinalPrice'] as num?)?.toDouble(),
  currencyCode: json['currencyCode'] as String?,
  wallet: json['wallet'] == null
      ? null
      : FamilyWalletResponseDto.fromJson(
          json['wallet'] as Map<String, dynamic>,
        ),
  shortcuts: (json['shortcuts'] as List<dynamic>?)
      ?.map(
        (e) => FamilyShortcutResponseDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  members: (json['members'] as List<dynamic>?)
      ?.map(
        (e) =>
            FamilyMemberSummaryResponseDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  todaySchedule: (json['todaySchedule'] as List<dynamic>?)
      ?.map(
        (e) =>
            FamilyMemberSummaryResponseDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$FamilyHomeResponseDtoToJson(
  FamilyHomeResponseDto instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'name': instance.name,
  'status': instance.status,
  'packageLabelAr': instance.packageLabelAr,
  'packageLabelEn': instance.packageLabelEn,
  'quotedFinalPrice': instance.quotedFinalPrice,
  'currencyCode': instance.currencyCode,
  'wallet': instance.wallet,
  'shortcuts': instance.shortcuts,
  'members': instance.members,
  'todaySchedule': instance.todaySchedule,
};

FamilyWalletResponseDto _$FamilyWalletResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyWalletResponseDto(
  available: json['available'] as bool?,
  unavailableReason: json['unavailableReason'] as String?,
);

Map<String, dynamic> _$FamilyWalletResponseDtoToJson(
  FamilyWalletResponseDto instance,
) => <String, dynamic>{
  'available': instance.available,
  'unavailableReason': instance.unavailableReason,
};

FamilyShortcutResponseDto _$FamilyShortcutResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyShortcutResponseDto(
  code: json['code'] as String?,
  enabled: json['enabled'] as bool?,
  unavailableReason: json['unavailableReason'] as String?,
);

Map<String, dynamic> _$FamilyShortcutResponseDtoToJson(
  FamilyShortcutResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'enabled': instance.enabled,
  'unavailableReason': instance.unavailableReason,
};
