import 'package:json_annotation/json_annotation.dart';

part 'family_first_login_verify_otp_request_dto.g.dart';

@JsonSerializable()
class FamilyFirstLoginVerifyOtpRequestDto {
  const FamilyFirstLoginVerifyOtpRequestDto({
    required this.loginChallengeToken,
    required this.otpCode,
  });

  final String loginChallengeToken;
  final String otpCode;

  factory FamilyFirstLoginVerifyOtpRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyFirstLoginVerifyOtpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyFirstLoginVerifyOtpRequestDtoToJson(this);
}
