// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_permissions_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberPermissionsRequestDto _$FamilyMemberPermissionsRequestDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberPermissionsRequestDto(
  editDailyMeals: json['editDailyMeals'] as bool,
  changeDeliveryTime: json['changeDeliveryTime'] as bool,
  viewProgram: json['viewProgram'] as bool,
  changeProgram: json['changeProgram'] as bool,
  editMealsAndDays: json['editMealsAndDays'] as bool,
  editAddress: json['editAddress'] as bool,
  unitExchange: json['unitExchange'] as bool,
  changePassword: json['changePassword'] as bool,
);

Map<String, dynamic> _$FamilyMemberPermissionsRequestDtoToJson(
  FamilyMemberPermissionsRequestDto instance,
) => <String, dynamic>{
  'editDailyMeals': instance.editDailyMeals,
  'changeDeliveryTime': instance.changeDeliveryTime,
  'viewProgram': instance.viewProgram,
  'changeProgram': instance.changeProgram,
  'editMealsAndDays': instance.editMealsAndDays,
  'editAddress': instance.editAddress,
  'unitExchange': instance.unitExchange,
  'changePassword': instance.changePassword,
};
