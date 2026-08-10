import 'package:meal_meat_user/features/auth/data/models/request/login_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/login_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';

extension LoginRequestEntityMapper on LoginRequestEntity {
  LoginRequestDto toDto() {
    return LoginRequestDto(
      phone: phone,
      password: password,
      countryCode: countryCode,
    );
  }
}

extension LoginResponseDtoMapper on LoginResponseDto {
  LoginEntity toEntity() {
    return LoginEntity(
      userId: userId ?? '',
      email: email,
      phoneNumber: phoneNumber ?? '',
      fullName: fullName ?? '',
      userType: userType ?? 0,
      accountStatus: accountStatus ?? 0,
      restaurantId: restaurantId,
      roles: roles ?? const [],
      permissions: permissions ?? const [],
      accessToken: accessToken ?? '',
      accessTokenExpiresAtUtc: accessTokenExpiresAtUtc ?? '',
      refreshToken: refreshToken ?? '',
      refreshTokenExpiresAtUtc: refreshTokenExpiresAtUtc ?? '',
      nextStep: nextStep,
      loginChallengeToken: loginChallengeToken,
      loginChallengeExpiresAtUtc: loginChallengeExpiresAtUtc,
      recoveryCodes: recoveryCodes ?? const [],
      isAuthenticated: isAuthenticated ?? false,
    );
  }
}
