import 'package:json_annotation/json_annotation.dart';

part 'resend_phone_otp_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ResendPhoneOtpRequestDto {
  const ResendPhoneOtpRequestDto({
    required this.phone,
    required this.countryCode,
  });

  final String phone;
  final String countryCode;

  Map<String, dynamic> toJson() => _$ResendPhoneOtpRequestDtoToJson(this);
}
