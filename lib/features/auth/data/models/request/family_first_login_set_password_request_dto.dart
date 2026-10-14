import 'package:json_annotation/json_annotation.dart';

part 'family_first_login_set_password_request_dto.g.dart';

@JsonSerializable()
class FamilyFirstLoginSetPasswordRequestDto {
  const FamilyFirstLoginSetPasswordRequestDto({
    required this.loginChallengeToken,
    required this.newPassword,
  });

  final String loginChallengeToken;
  final String newPassword;

  factory FamilyFirstLoginSetPasswordRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyFirstLoginSetPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyFirstLoginSetPasswordRequestDtoToJson(this);
}
