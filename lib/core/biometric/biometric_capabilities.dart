import 'biometric_auth_result.dart';

class BiometricCapabilities {
  const BiometricCapabilities({
    required this.supportsBiometrics,
    required this.hasEnrollment,
    required this.presentationType,
  });

  final bool supportsBiometrics;
  final bool hasEnrollment;
  final BiometricTypeEnum presentationType;

  static const unsupported = BiometricCapabilities(
    supportsBiometrics: false,
    hasEnrollment: false,
    presentationType: BiometricTypeEnum.none,
  );
}
