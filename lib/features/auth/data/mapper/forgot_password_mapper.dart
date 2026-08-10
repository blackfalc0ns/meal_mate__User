import 'package:meal_meat_user/features/auth/data/models/request/forgot_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/forgot_password_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';

extension ForgotPasswordRequestEntityMapper on ForgotPasswordRequestEntity {
  ForgotPasswordRequestDto toDto() {
    return ForgotPasswordRequestDto(phone: phone, countryCode: countryCode);
  }
}

extension ForgotPasswordResponseDtoMapper on ForgotPasswordResponseDto {
  ForgotPasswordEntity toEntity(ForgotPasswordRequestEntity request) {
    return ForgotPasswordEntity(
      success: success ?? false,
      otpSent: otpSent ?? false,
      nextStep: nextStep ?? '',
      phone: request.phone,
      countryCode: request.countryCode,
    );
  }
}
