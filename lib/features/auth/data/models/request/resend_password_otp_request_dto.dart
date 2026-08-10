import 'package:json_annotation/json_annotation.dart';

part 'resend_password_otp_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ResendPasswordOtpRequestDto {
  const ResendPasswordOtpRequestDto({
    required this.phone,
    required this.countryCode,
  });

  final String phone;
  final String countryCode;

  Map<String, dynamic> toJson() => _$ResendPasswordOtpRequestDtoToJson(this);
}
