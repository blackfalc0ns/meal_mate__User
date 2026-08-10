import 'package:json_annotation/json_annotation.dart';

part 'register_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponseDto {
  const RegisterResponseDto({
    this.userId,
    this.phone,
    this.otpSent,
    this.nextStep,
  });

  final String? userId;
  final String? phone;
  final bool? otpSent;
  final String? nextStep;

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);
}
