import 'package:json_annotation/json_annotation.dart';

part 'family_member_access_response_dto.g.dart';

@JsonSerializable()
class FamilyMemberAccessResponseDto {
  const FamilyMemberAccessResponseDto({
    this.memberId,
    this.hasSeparateAccount,
    this.linkedCustomerUserId,
    this.isPaused,
    this.pausedAtUtc,
    this.removedAtUtc,
    this.inviteDeepLink,
    this.inviteExpiresAtUtc,
    this.phoneNumber,
    this.hasExistingLogin,
    this.generatedPassword,
    this.version,
  });
  final String? memberId;
  final bool? hasSeparateAccount;
  final String? linkedCustomerUserId;
  final bool? isPaused;
  final String? pausedAtUtc;
  final String? removedAtUtc;
  final String? inviteDeepLink;
  final String? inviteExpiresAtUtc;
  final String? phoneNumber;
  final bool? hasExistingLogin;
  final String? generatedPassword;
  @JsonKey(readValue: _readAccessVersion)
  final int? version;
  factory FamilyMemberAccessResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberAccessResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberAccessResponseDtoToJson(this);
}

Object? _readAccessVersion(Map json, String key) {
  return json['version'] ?? json['currentVersion'];
}
