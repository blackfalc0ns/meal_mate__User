// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_access_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberAccessRequestDto _$FamilyMemberAccessRequestDtoFromJson(
  Map<String, dynamic> json,
) => FamilyMemberAccessRequestDto(
  hasSeparateAccount: json['hasSeparateAccount'] as bool?,
  isPaused: json['isPaused'] as bool?,
  remove: json['remove'] as bool?,
  expectedVersion: (json['expectedVersion'] as num?)?.toInt(),
);

Map<String, dynamic> _$FamilyMemberAccessRequestDtoToJson(
  FamilyMemberAccessRequestDto instance,
) => <String, dynamic>{
  'hasSeparateAccount': ?instance.hasSeparateAccount,
  'isPaused': ?instance.isPaused,
  'remove': ?instance.remove,
  'expectedVersion': ?instance.expectedVersion,
};
