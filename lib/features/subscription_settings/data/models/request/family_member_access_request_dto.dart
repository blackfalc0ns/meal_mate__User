import 'package:json_annotation/json_annotation.dart';

part 'family_member_access_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class FamilyMemberAccessRequestDto {
  const FamilyMemberAccessRequestDto({
    this.hasSeparateAccount,
    this.isPaused,
    this.remove,
  });
  final bool? hasSeparateAccount;
  final bool? isPaused;
  final bool? remove;
  factory FamilyMemberAccessRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberAccessRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberAccessRequestDtoToJson(this);
}
