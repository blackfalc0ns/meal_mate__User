sealed class PasswordRecoveryEvent {
  const PasswordRecoveryEvent();
}

class RequestRecoveryOtpEvent extends PasswordRecoveryEvent {
  const RequestRecoveryOtpEvent({
    required this.phone,
    required this.countryCode,
  });
  final String phone;
  final String countryCode;
}

class SaveRecoveryOtpEvent extends PasswordRecoveryEvent {
  const SaveRecoveryOtpEvent(this.code);
  final String code;
}

class ResendRecoveryOtpEvent extends PasswordRecoveryEvent {
  const ResendRecoveryOtpEvent();
}

class SubmitResetPasswordEvent extends PasswordRecoveryEvent {
  const SubmitResetPasswordEvent({required this.newPassword});
  final String newPassword;
}

class ClearRecoveryFeedbackEvent extends PasswordRecoveryEvent {
  const ClearRecoveryFeedbackEvent();
}

class ResetRecoveryFlowEvent extends PasswordRecoveryEvent {
  const ResetRecoveryFlowEvent();
}
