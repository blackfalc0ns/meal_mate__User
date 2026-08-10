import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ResetPasswordResponseDto {
  const ResetPasswordResponseDto({
    this.success,
    this.passwordReset,
    this.nextStep,
  });

  final bool? success;
  final bool? passwordReset;
  final String? nextStep;

  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseDtoFromJson(json);
}
