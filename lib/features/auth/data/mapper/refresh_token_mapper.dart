import 'package:meal_meat_user/features/auth/data/models/request/refresh_token_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/refresh_token_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';

extension RefreshTokenRequestEntityMapper on RefreshTokenRequestEntity {
  RefreshTokenRequestDto toDto() {
    return RefreshTokenRequestDto(refreshToken: refreshToken);
  }
}

extension RefreshTokenResponseDtoMapper on RefreshTokenResponseDto {
  RefreshTokenEntity toEntity() {
    return RefreshTokenEntity(
      userId: userId ?? '',
      email: email,
      phoneNumber: phoneNumber ?? '',
      fullName: fullName ?? '',
      userType: userType?.toString() ?? '',
      accountStatus: accountStatus?.toString() ?? '',
      restaurantId: restaurantId,
      roles: roles ?? const [],
      permissions: permissions ?? const [],
      accessToken: accessToken ?? '',
      accessTokenExpiresAtUtc: accessTokenExpiresAtUtc ?? '',
      refreshToken: refreshToken ?? '',
      refreshTokenExpiresAtUtc: refreshTokenExpiresAtUtc ?? '',
      nextStep: nextStep,
    );
  }
}
