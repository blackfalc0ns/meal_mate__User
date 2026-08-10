import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ResetPasswordRequestDto {
  const ResetPasswordRequestDto({
    required this.phone,
    required this.otpCode,
    required this.newPassword,
    required this.countryCode,
  });

  final String phone;
  final String otpCode;
  final String newPassword;
  final String countryCode;

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
