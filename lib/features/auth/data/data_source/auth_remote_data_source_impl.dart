import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/auth/data/data_source/auth_remote_data_source.dart';
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

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) {
    return _apiServices.login(request);
  }

  @override
  Future<RegisterResponseDto> register(RegisterRequestDto request) {
    return _apiServices.register(request);
  }

  @override
  Future<VerifyPhoneResponseDto> verifyPhone(VerifyPhoneRequestDto request) {
    return _apiServices.verifyPhone(request);
  }

  @override
  Future<ResendPhoneOtpResponseDto> resendPhoneOtp(
    ResendPhoneOtpRequestDto request,
  ) {
    return _apiServices.resendPhoneOtp(request);
  }

  @override
  Future<ForgotPasswordResponseDto> forgotPassword(
    ForgotPasswordRequestDto request,
  ) {
    return _apiServices.forgotPassword(request);
  }

  @override
  Future<ResetPasswordResponseDto> resetPassword(
    ResetPasswordRequestDto request,
  ) {
    return _apiServices.resetPassword(request);
  }

  @override
  Future<ResendPasswordOtpResponseDto> resendPasswordOtp(
    ResendPasswordOtpRequestDto request,
  ) {
    return _apiServices.resendPasswordOtp(request);
  }

  @override
  Future<RefreshTokenResponseDto> refreshToken(RefreshTokenRequestDto request) {
    return _apiServices.refreshToken(request);
  }

  @override
  Future<void> logout(LogoutRequestDto request) {
    return _apiServices.logout(request);
  }

  @override
  Future<List<CallingCodeResponseDto>> getCallingCodes() {
    return _apiServices.getCallingCodes();
  }
}
