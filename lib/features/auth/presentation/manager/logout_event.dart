sealed class LogoutEvent {
  const LogoutEvent();
}

class RequestLogoutEvent extends LogoutEvent {
  const RequestLogoutEvent({this.invalidateBiometrics = false});

  final bool invalidateBiometrics;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestLogoutEvent &&
          runtimeType == other.runtimeType &&
          invalidateBiometrics == other.invalidateBiometrics;

  @override
  int get hashCode => invalidateBiometrics.hashCode;
}

class ClearLogoutFeedbackEvent extends LogoutEvent {
  const ClearLogoutFeedbackEvent();
}
