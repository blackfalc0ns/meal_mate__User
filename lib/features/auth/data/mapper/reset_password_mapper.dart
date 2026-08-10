import 'package:meal_meat_user/features/auth/data/models/request/reset_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/reset_password_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';

extension ResetPasswordRequestEntityMapper on ResetPasswordRequestEntity {
  ResetPasswordRequestDto toDto() {
    return ResetPasswordRequestDto(
      phone: phone,
      otpCode: otpCode,
      newPassword: newPassword,
      countryCode: countryCode,
    );
  }
}

extension ResetPasswordResponseDtoMapper on ResetPasswordResponseDto {
  ResetPasswordEntity toEntity() {
    return ResetPasswordEntity(
      success: success ?? false,
      passwordReset: passwordReset ?? false,
      nextStep: nextStep ?? '',
    );
  }
}
