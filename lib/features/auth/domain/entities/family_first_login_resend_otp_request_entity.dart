import 'package:meal_meat_user/features/auth/data/models/request/family_first_login_resend_otp_request_dto.dart';

class FamilyFirstLoginResendOtpRequestEntity {
  const FamilyFirstLoginResendOtpRequestEntity({
    required this.loginChallengeToken,
  });

  final String loginChallengeToken;

  FamilyFirstLoginResendOtpRequestDto toDto() =>
      FamilyFirstLoginResendOtpRequestDto(
        loginChallengeToken: loginChallengeToken,
      );
}
