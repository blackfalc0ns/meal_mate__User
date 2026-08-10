import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
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

class RefreshTokenEvent extends AuthEvent {
  const RefreshTokenEvent(this.request);

  final RefreshTokenRequestEntity request;
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent(this.request);

  final LogoutRequestEntity request;
}
