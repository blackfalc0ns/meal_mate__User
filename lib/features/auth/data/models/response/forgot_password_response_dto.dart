import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ForgotPasswordResponseDto {
  const ForgotPasswordResponseDto({this.success, this.otpSent, this.nextStep});

  final bool? success;
  final bool? otpSent;
  final String? nextStep;

  factory ForgotPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseDtoFromJson(json);
}
