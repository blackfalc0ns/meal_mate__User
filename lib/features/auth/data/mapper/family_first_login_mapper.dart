import 'package:meal_meat_user/features/auth/data/models/request/family_first_login_set_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/family_first_login_verify_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/family_first_login_verify_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_set_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_step_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_verify_otp_request_entity.dart';

extension FamilyFirstLoginVerifyOtpRequestEntityMapper
    on FamilyFirstLoginVerifyOtpRequestEntity {
  FamilyFirstLoginVerifyOtpRequestDto toDto() {
    return FamilyFirstLoginVerifyOtpRequestDto(
      loginChallengeToken: loginChallengeToken,
      otpCode: otpCode,
    );
  }
}

extension FamilyFirstLoginSetPasswordRequestEntityMapper
    on FamilyFirstLoginSetPasswordRequestEntity {
  FamilyFirstLoginSetPasswordRequestDto toDto() {
    return FamilyFirstLoginSetPasswordRequestDto(
      loginChallengeToken: loginChallengeToken,
      newPassword: newPassword,
    );
  }
}

extension FamilyFirstLoginVerifyOtpResponseDtoMapper
    on FamilyFirstLoginVerifyOtpResponseDto {
  FamilyFirstLoginStepEntity toEntity() {
    return FamilyFirstLoginStepEntity(
      nextStep: nextStep ?? '',
      loginChallengeToken: loginChallengeToken ?? '',
      loginChallengeExpiresAtUtc: loginChallengeExpiresAtUtc,
    );
  }
}
