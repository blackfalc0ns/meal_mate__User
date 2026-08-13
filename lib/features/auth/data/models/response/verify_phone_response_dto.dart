import 'package:json_annotation/json_annotation.dart';

part 'verify_phone_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class VerifyPhoneResponseDto {
  const VerifyPhoneResponseDto({
    this.userId,
    this.email,
    this.phoneNumber,
    this.fullName,
    this.userType,
    this.accountStatus,
    this.restaurantId,
    this.roles,
    this.permissions,
    this.accessToken,
    this.accessTokenExpiresAtUtc,
    this.refreshToken,
    this.refreshTokenExpiresAtUtc,
    this.nextStep,
  });

  final String? userId;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final Object? userType;
  final Object? accountStatus;
  final String? restaurantId;
  final List<String>? roles;
  final List<String>? permissions;
  final String? accessToken;
  final String? accessTokenExpiresAtUtc;
  final String? refreshToken;
  final String? refreshTokenExpiresAtUtc;
  final String? nextStep;

  factory VerifyPhoneResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyPhoneResponseDtoFromJson(json);
}
