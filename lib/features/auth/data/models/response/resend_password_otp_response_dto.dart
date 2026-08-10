import 'package:json_annotation/json_annotation.dart';

part 'resend_password_otp_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ResendPasswordOtpResponseDto {
  const ResendPasswordOtpResponseDto({
    this.success,
    this.otpSent,
    this.nextStep,
  });

  final bool? success;
  final bool? otpSent;
  final String? nextStep;

  factory ResendPasswordOtpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResendPasswordOtpResponseDtoFromJson(json);
}
