import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ForgotPasswordRequestDto {
  const ForgotPasswordRequestDto({
    required this.phone,
    required this.countryCode,
  });

  final String phone;
  final String countryCode;

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestDtoToJson(this);
}
