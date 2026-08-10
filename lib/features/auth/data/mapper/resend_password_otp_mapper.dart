import 'package:meal_meat_user/features/auth/data/models/request/resend_password_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/resend_password_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';

extension ResendPasswordOtpRequestEntityMapper
    on ResendPasswordOtpRequestEntity {
  ResendPasswordOtpRequestDto toDto() {
    return ResendPasswordOtpRequestDto(phone: phone, countryCode: countryCode);
  }
}

extension ResendPasswordOtpResponseDtoMapper on ResendPasswordOtpResponseDto {
  ResendPasswordOtpEntity toEntity() {
    return ResendPasswordOtpEntity(
      success: success ?? false,
      otpSent: otpSent ?? false,
      nextStep: nextStep ?? '',
    );
  }
}
