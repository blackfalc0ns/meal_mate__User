import 'package:json_annotation/json_annotation.dart';

part 'register_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequestDto {
  const RegisterRequestDto({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.countryCode,
  });

  final String fullName;
  final String phone;
  final String password;
  final String countryCode;

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
