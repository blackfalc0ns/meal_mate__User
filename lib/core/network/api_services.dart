import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/services/token_interceptor.dart';
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
import 'package:retrofit/retrofit.dart';
part 'api_services.g.dart';

@RestApi()
@injectable
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(Dio dio) = _ApiServices;

  @POST(EndPoints.login)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);

  @POST(EndPoints.register)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  @POST(EndPoints.verifyPhone)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<VerifyPhoneResponseDto> verifyPhone(
    @Body() VerifyPhoneRequestDto request,
  );

  @POST(EndPoints.resendPhoneOtp)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ResendPhoneOtpResponseDto> resendPhoneOtp(
    @Body() ResendPhoneOtpRequestDto request,
  );

  @POST(EndPoints.forgotPassword)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ForgotPasswordResponseDto> forgotPassword(
    @Body() ForgotPasswordRequestDto request,
  );

  @POST(EndPoints.resetPassword)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );

  @POST(EndPoints.resendPasswordOtp)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ResendPasswordOtpResponseDto> resendPasswordOtp(
    @Body() ResendPasswordOtpRequestDto request,
  );

  @POST(EndPoints.refresh)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<RefreshTokenResponseDto> refreshToken(
    @Body() RefreshTokenRequestDto request,
  );

  @POST(EndPoints.logout)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<void> logout(@Body() LogoutRequestDto request);

  @GET(EndPoints.callingCodes)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<List<CallingCodeResponseDto>> getCallingCodes();
}
