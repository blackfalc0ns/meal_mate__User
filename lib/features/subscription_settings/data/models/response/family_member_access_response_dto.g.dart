// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_access_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberAccessResponseDto _$FamilyMemberAccessResponseDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberAccessResponseDto(
  memberId: json['memberId'] as String?,
  hasSeparateAccount: json['hasSeparateAccount'] as bool?,
  linkedCustomerUserId: json['linkedCustomerUserId'] as String?,
  isPaused: json['isPaused'] as bool?,
  pausedAtUtc: json['pausedAtUtc'] as String?,
  removedAtUtc: json['removedAtUtc'] as String?,
  inviteDeepLink: json['inviteDeepLink'] as String?,
  inviteExpiresAtUtc: json['inviteExpiresAtUtc'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  hasExistingLogin: json['hasExistingLogin'] as bool?,
  generatedPassword: json['generatedPassword'] as String?,
  version: (_readAccessVersion(json, 'version') as num?)?.toInt(),
);

Map<String, dynamic> _$FamilyMemberAccessResponseDtoToJson(
  FamilyMemberAccessResponseDto instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'hasSeparateAccount': instance.hasSeparateAccount,
  'linkedCustomerUserId': instance.linkedCustomerUserId,
  'isPaused': instance.isPaused,
  'pausedAtUtc': instance.pausedAtUtc,
  'removedAtUtc': instance.removedAtUtc,
  'inviteDeepLink': instance.inviteDeepLink,
  'inviteExpiresAtUtc': instance.inviteExpiresAtUtc,
  'phoneNumber': instance.phoneNumber,
  'hasExistingLogin': instance.hasExistingLogin,
  'generatedPassword': instance.generatedPassword,
  'version': instance.version,
};
