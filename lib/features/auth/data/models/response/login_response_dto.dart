import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class LoginResponseDto {
  const LoginResponseDto({
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
    this.loginChallengeToken,
    this.loginChallengeExpiresAtUtc,
    this.recoveryCodes,
    this.isAuthenticated,
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
  final String? loginChallengeToken;
  final String? loginChallengeExpiresAtUtc;
  final List<String>? recoveryCodes;
  final bool? isAuthenticated;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
