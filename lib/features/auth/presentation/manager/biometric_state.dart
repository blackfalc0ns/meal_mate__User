import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class BiometricState {
  const BiometricState({
    this.isSupported = false,
    this.hasEnrollment = false,
    this.isEnabled = false,
    this.canRestoreSession = false,
    this.biometricType = BiometricTypeEnum.none,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.authStatus,
  });

  final bool isSupported;
  final bool hasEnrollment;
  final bool isEnabled;
  final bool canRestoreSession;
  final BiometricTypeEnum biometricType;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final BiometricAuthStatus? authStatus;

  IconData get biometricIcon => switch (biometricType) {
    BiometricTypeEnum.face => Icons.face_rounded,
    BiometricTypeEnum.fingerprint => Icons.fingerprint_rounded,
    _ => Icons.fingerprint_rounded,
  };

  String getBiometricButtonText(AppLocalizations l10n) =>
      switch (biometricType) {
        BiometricTypeEnum.face =>
          '${l10n.biometric_quick_login} (${l10n.biometric_face_id})',
        BiometricTypeEnum.fingerprint =>
          '${l10n.biometric_quick_login} (${l10n.biometric_fingerprint})',
        _ => l10n.biometric_quick_login,
      };

  BiometricState copyWith({
    bool? isSupported,
    bool? hasEnrollment,
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
      hasEnrollment: hasEnrollment ?? this.hasEnrollment,
      isEnabled: isEnabled ?? this.isEnabled,
      canRestoreSession: canRestoreSession ?? this.canRestoreSession,
      biometricType: biometricType ?? this.biometricType,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      authStatus: clearAuthStatus ? null : (authStatus ?? this.authStatus),
    );
  }
}
