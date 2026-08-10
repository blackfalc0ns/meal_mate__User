import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class RegisterCustomerEvent extends AuthEvent {
  const RegisterCustomerEvent(this.request);

  final RegisterRequestEntity request;
}

class GetCallingCodesEvent extends AuthEvent {
  const GetCallingCodesEvent();
}

class SelectCallingCodeEvent extends AuthEvent {
  const SelectCallingCodeEvent(this.callingCode);

  final CallingCodeEntity callingCode;
}
