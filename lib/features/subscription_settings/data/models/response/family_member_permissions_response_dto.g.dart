// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_permissions_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberPermissionsResponseDto _$FamilyMemberPermissionsResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberPermissionsResponseDto(
  memberId: json['memberId'] as String?,
  editDailyMeals: json['editDailyMeals'] as bool?,
  changeDeliveryTime: json['changeDeliveryTime'] as bool?,
  viewProgram: json['viewProgram'] as bool?,
  changeProgram: json['changeProgram'] as bool?,
  editMealsAndDays: json['editMealsAndDays'] as bool?,
  editAddress: json['editAddress'] as bool?,
  unitExchange: json['unitExchange'] as bool?,
  changePassword: json['changePassword'] as bool?,
  groups: (json['groups'] as List<dynamic>?)
      ?.map(
        (e) => FamilyPermissionGroupResponseDto.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  version: (_readVersion(json, 'version') as num?)?.toInt(),
);

Map<String, dynamic> _$FamilyMemberPermissionsResponseDtoToJson(
  FamilyMemberPermissionsResponseDto instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'editDailyMeals': instance.editDailyMeals,
  'changeDeliveryTime': instance.changeDeliveryTime,
  'viewProgram': instance.viewProgram,
  'changeProgram': instance.changeProgram,
  'editMealsAndDays': instance.editMealsAndDays,
  'editAddress': instance.editAddress,
  'unitExchange': instance.unitExchange,
  'changePassword': instance.changePassword,
  'groups': instance.groups,
  'version': instance.version,
};

FamilyPermissionGroupResponseDto _$FamilyPermissionGroupResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyPermissionGroupResponseDto(
  code: json['code'] as String?,
  labelAr: json['labelAr'] as String?,
  labelEn: json['labelEn'] as String?,
  permissions: (json['permissions'] as List<dynamic>?)
      ?.map(
        (e) =>
            FamilyPermissionItemResponseDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$FamilyPermissionGroupResponseDtoToJson(
  FamilyPermissionGroupResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'labelAr': instance.labelAr,
  'labelEn': instance.labelEn,
  'permissions': instance.permissions,
};

FamilyPermissionItemResponseDto _$FamilyPermissionItemResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyPermissionItemResponseDto(
  key: json['key'] as String?,
  labelAr: json['labelAr'] as String?,
  labelEn: json['labelEn'] as String?,
  descriptionAr: json['descriptionAr'] as String?,
  descriptionEn: json['descriptionEn'] as String?,
  value: json['value'] as bool?,
  isSupported: json['isSupported'] as bool?,
  isManagerConfigurable: json['isManagerConfigurable'] as bool?,
  requiredPermissions: (json['requiredPermissions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FamilyPermissionItemResponseDtoToJson(
  FamilyPermissionItemResponseDto instance,
) => <String, dynamic>{
  'key': instance.key,
  'labelAr': instance.labelAr,
  'labelEn': instance.labelEn,
  'descriptionAr': instance.descriptionAr,
  'descriptionEn': instance.descriptionEn,
  'value': instance.value,
  'isSupported': instance.isSupported,
  'isManagerConfigurable': instance.isManagerConfigurable,
  'requiredPermissions': instance.requiredPermissions,
};
