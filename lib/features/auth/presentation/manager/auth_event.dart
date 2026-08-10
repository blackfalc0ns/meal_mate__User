import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class RegisterCustomerEvent extends AuthEvent {
  const RegisterCustomerEvent(this.request);

  final RegisterRequestEntity request;
}

class LoginCustomerEvent extends AuthEvent {
  const LoginCustomerEvent(this.request);

  final LoginRequestEntity request;
}

class GetCallingCodesEvent extends AuthEvent {
  const GetCallingCodesEvent();
}

class SelectCallingCodeEvent extends AuthEvent {
  const SelectCallingCodeEvent(this.callingCode);

  final CallingCodeEntity callingCode;
}

class VerifyPhoneEvent extends AuthEvent {
  const VerifyPhoneEvent(this.request);

  final VerifyPhoneRequestEntity request;
}

class ResendPhoneOtpEvent extends AuthEvent {
  const ResendPhoneOtpEvent(this.request);

  final ResendPhoneOtpRequestEntity request;
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent(this.request);

  final ForgotPasswordRequestEntity request;
}

class SaveResetPasswordOtpCodeEvent extends AuthEvent {
  const SaveResetPasswordOtpCodeEvent(this.otpCode);

  final String otpCode;
}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent(this.request);

  final ResetPasswordRequestEntity request;
}

class ResendPasswordOtpEvent extends AuthEvent {
  const ResendPasswordOtpEvent(this.request);

  final ResendPasswordOtpRequestEntity request;
}

class RefreshTokenEvent extends AuthEvent {
  const RefreshTokenEvent(this.request);

  final RefreshTokenRequestEntity request;
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent(this.request);

  final LogoutRequestEntity request;
}
