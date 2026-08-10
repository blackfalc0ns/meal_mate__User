import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';

abstract interface class AuthRepository {
  Future<ApiResult<LoginEntity>> login(LoginRequestEntity request);

  Future<ApiResult<RegisterEntity>> register(RegisterRequestEntity request);

  Future<ApiResult<VerifyPhoneEntity>> verifyPhone(
    VerifyPhoneRequestEntity request,
  );

  Future<ApiResult<ResendPhoneOtpEntity>> resendPhoneOtp(
    ResendPhoneOtpRequestEntity request,
  );

  Future<ApiResult<ForgotPasswordEntity>> forgotPassword(
    ForgotPasswordRequestEntity request,
  );

  Future<ApiResult<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequestEntity request,
  );

  Future<ApiResult<ResendPasswordOtpEntity>> resendPasswordOtp(
    ResendPasswordOtpRequestEntity request,
  );

  Future<ApiResult<RefreshTokenEntity>> refreshToken(
    RefreshTokenRequestEntity request,
  );

  Future<ApiResult<LogoutEntity>> logout(LogoutRequestEntity request);

  Future<ApiResult<List<CallingCodeEntity>>> getCallingCodes();
}
