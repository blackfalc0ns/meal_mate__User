import 'package:json_annotation/json_annotation.dart';

part 'resend_phone_otp_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ResendPhoneOtpResponseDto {
  const ResendPhoneOtpResponseDto({this.success, this.otpSent, this.nextStep});

  final bool? success;
  final bool? otpSent;
  final String? nextStep;

  factory ResendPhoneOtpResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResendPhoneOtpResponseDtoFromJson(json);
}
