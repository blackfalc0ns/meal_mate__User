import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class LoginRequestDto {
  const LoginRequestDto({
    required this.phone,
    required this.password,
    required this.countryCode,
  });

  final String phone;
  final String password;
  final String countryCode;

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
