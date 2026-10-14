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

class VerifyFamilyFirstLoginOtpEvent extends LoginEvent {
  const VerifyFamilyFirstLoginOtpEvent(this.otpCode);
  final String otpCode;
}

class SetFamilyFirstLoginPasswordEvent extends LoginEvent {
  const SetFamilyFirstLoginPasswordEvent(this.newPassword);
  final String newPassword;
}

class ResetFamilyFirstLoginFlowEvent extends LoginEvent {
  const ResetFamilyFirstLoginFlowEvent();
}
