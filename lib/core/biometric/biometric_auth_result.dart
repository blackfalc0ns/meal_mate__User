enum BiometricAuthStatus {
  success,
  canceled,
  notAvailable,
  notEnrolled,
  passcodeNotSet,
  lockedOut,
  permanentlyLockedOut,
  failed,
  error,
}

enum BiometricTypeEnum {
  face,
  fingerprint,
  iris,
  generic,
  none,
}

class BiometricAuthResult {
  const BiometricAuthResult({
    required this.status,
    this.errorMessage,
  });

  const BiometricAuthResult.success()
      : status = BiometricAuthStatus.success,
        errorMessage = null;

  const BiometricAuthResult.canceled()
      : status = BiometricAuthStatus.canceled,
        errorMessage = null;

  const BiometricAuthResult.failure(this.status, [this.errorMessage]);

  final BiometricAuthStatus status;
  final String? errorMessage;

  bool get isSuccess => status == BiometricAuthStatus.success;
  bool get isCanceled => status == BiometricAuthStatus.canceled;
}
