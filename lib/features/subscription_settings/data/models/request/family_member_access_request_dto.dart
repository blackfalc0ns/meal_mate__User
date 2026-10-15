import 'package:json_annotation/json_annotation.dart';

part 'family_member_access_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class FamilyMemberAccessRequestDto {
  const FamilyMemberAccessRequestDto({
    this.hasSeparateAccount,
    this.isPaused,
    this.remove,
    this.expectedVersion,
    this.generateTemporaryPassword,
    this.credentialOperationKey,
  });
  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool? remove;
  final int? expectedVersion;
  final bool? generateTemporaryPassword;
  final String? credentialOperationKey;
  factory FamilyMemberAccessRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberAccessRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => {
    ..._$FamilyMemberAccessRequestDtoToJson(this),
    if (expectedVersion != null) 'expectedVersion': expectedVersion,
    if (credentialOperationKey != null)
      'credentialOperationKey': credentialOperationKey,
  };
}
