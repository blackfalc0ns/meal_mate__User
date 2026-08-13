import 'package:meal_meat_user/features/auth/data/models/request/verify_phone_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/verify_phone_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';

extension VerifyPhoneRequestEntityMapper on VerifyPhoneRequestEntity {
  VerifyPhoneRequestDto toDto() {
    return VerifyPhoneRequestDto(
      phone: phone,
      code: code,
      countryCode: countryCode,
    );
  }
}

extension VerifyPhoneResponseDtoMapper on VerifyPhoneResponseDto {
  VerifyPhoneEntity toEntity() {
    return VerifyPhoneEntity(
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
      nextStep: nextStep ?? '',
    );
  }
}
