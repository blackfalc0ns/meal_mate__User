sealed class BiometricEvent {
  const BiometricEvent();
}

class InitBiometricEvent extends BiometricEvent {
  const InitBiometricEvent();
}

class ToggleBiometricEvent extends BiometricEvent {
  const ToggleBiometricEvent({
    required this.enable,
    required this.localizedReason,
  });

  final bool enable;
  final String localizedReason;
}

class ClearBiometricFeedbackEvent extends BiometricEvent {
  const ClearBiometricFeedbackEvent();
}

class DeferBiometricEvent extends BiometricEvent {
  const DeferBiometricEvent();
}
