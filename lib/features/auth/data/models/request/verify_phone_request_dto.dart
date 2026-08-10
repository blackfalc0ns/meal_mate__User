import 'package:json_annotation/json_annotation.dart';

part 'verify_phone_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class VerifyPhoneRequestDto {
  const VerifyPhoneRequestDto({
    required this.phone,
    required this.code,
    required this.countryCode,
  });

  final String phone;
  final String code;
  final String countryCode;

  Map<String, dynamic> toJson() => _$VerifyPhoneRequestDtoToJson(this);
}
