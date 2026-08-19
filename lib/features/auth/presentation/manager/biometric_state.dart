import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';

class BiometricState {
  const BiometricState({
    this.isSupported = false,
    this.isEnabled = false,
    this.canRestoreSession = false,
    this.biometricType = BiometricTypeEnum.none,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.authStatus,
  });

  final bool isSupported;
  final bool isEnabled;
  final bool canRestoreSession;
  final BiometricTypeEnum biometricType;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final BiometricAuthStatus? authStatus;

  BiometricState copyWith({
    bool? isSupported,
    bool? isEnabled,
    bool? canRestoreSession,
    BiometricTypeEnum? biometricType,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
    BiometricAuthStatus? authStatus,
    bool clearAuthStatus = false,
  }) {
    return BiometricState(
      isSupported: isSupported ?? this.isSupported,
      isEnabled: isEnabled ?? this.isEnabled,
      canRestoreSession: canRestoreSession ?? this.canRestoreSession,
      biometricType: biometricType ?? this.biometricType,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      authStatus:
          clearAuthStatus ? null : (authStatus ?? this.authStatus),
    );
  }
}
