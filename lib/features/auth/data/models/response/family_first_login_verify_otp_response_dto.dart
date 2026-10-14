import 'package:json_annotation/json_annotation.dart';

part 'family_first_login_verify_otp_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyFirstLoginVerifyOtpResponseDto {
  const FamilyFirstLoginVerifyOtpResponseDto({
    this.nextStep,
    this.loginChallengeToken,
    this.loginChallengeExpiresAtUtc,
  });

  final String? nextStep;
  final String? loginChallengeToken;
  final String? loginChallengeExpiresAtUtc;

  factory FamilyFirstLoginVerifyOtpResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyFirstLoginVerifyOtpResponseDtoFromJson(json);
}
