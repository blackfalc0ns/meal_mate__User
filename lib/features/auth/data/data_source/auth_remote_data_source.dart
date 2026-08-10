import 'package:meal_meat_user/features/auth/data/models/request/login_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/logout_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/refresh_token_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/register_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/forgot_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/resend_password_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/resend_phone_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/reset_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/verify_phone_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/calling_code_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/forgot_password_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/login_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/refresh_token_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/register_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/resend_password_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/resend_phone_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/reset_password_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/verify_phone_response_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseDto> login(LoginRequestDto request);

  Future<RegisterResponseDto> register(RegisterRequestDto request);

  Future<VerifyPhoneResponseDto> verifyPhone(VerifyPhoneRequestDto request);

  Future<ResendPhoneOtpResponseDto> resendPhoneOtp(
    ResendPhoneOtpRequestDto request,
  );

  Future<ForgotPasswordResponseDto> forgotPassword(
    ForgotPasswordRequestDto request,
  );

  Future<ResetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto request,
  );

  Future<ResendPasswordOtpResponseDto> resendPasswordOtp(
    ResendPasswordOtpRequestDto request,
  );

  Future<RefreshTokenResponseDto> refreshToken(RefreshTokenRequestDto request);

  Future<void> logout(LogoutRequestDto request);

  Future<List<CallingCodeResponseDto>> getCallingCodes();
}
