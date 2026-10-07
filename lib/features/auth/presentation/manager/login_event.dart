import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';

sealed class LoginEvent {
  const LoginEvent();
}

class SubmitLoginEvent extends LoginEvent {
  const SubmitLoginEvent(this.request, {required this.rememberMe});
  final LoginRequestEntity request;
  final bool rememberMe;
}

class RememberMeChangedEvent extends LoginEvent {
  const RememberMeChangedEvent(this.value);
  final bool value;
}

class LoginWithBiometricsEvent extends LoginEvent {
  const LoginWithBiometricsEvent({this.localizedReason});
  final String? localizedReason;
}

class CheckBiometricReadinessEvent extends LoginEvent {
  const CheckBiometricReadinessEvent();
}

class ClearLoginFeedbackEvent extends LoginEvent {
  const ClearLoginFeedbackEvent();
}
