import 'package:meal_meat_user/features/auth/data/models/request/resend_phone_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/resend_phone_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';

extension ResendPhoneOtpRequestEntityMapper on ResendPhoneOtpRequestEntity {
  ResendPhoneOtpRequestDto toDto() {
    return ResendPhoneOtpRequestDto(phone: phone, countryCode: countryCode);
  }
}

extension ResendPhoneOtpResponseDtoMapper on ResendPhoneOtpResponseDto {
  ResendPhoneOtpEntity toEntity() {
    return ResendPhoneOtpEntity(
      success: success ?? false,
      otpSent: otpSent ?? false,
      nextStep: nextStep ?? '',
    );
  }
}
