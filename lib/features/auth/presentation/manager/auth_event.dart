import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class RegisterCustomerEvent extends AuthEvent {
  const RegisterCustomerEvent(this.request);

  final RegisterRequestEntity request;
}
