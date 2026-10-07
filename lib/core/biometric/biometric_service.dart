import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/token_service.dart';
import '../utils/constants.dart';
import 'biometric_auth_result.dart';
import 'biometric_capabilities.dart';
import 'biometric_credentials.dart';

@lazySingleton
class BiometricService {
  BiometricService(
    this._localAuth,
    this._sharedPreferences,
    this._tokenService,
  );

  final LocalAuthentication _localAuth;
  final SharedPreferences _sharedPreferences;
  final TokenService _tokenService;
  bool _isAuthenticating = false;

  /// Retrieves the detailed biometric hardware and enrollment capabilities of the device.
  Future<BiometricCapabilities> getCapabilities() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final biometrics = await getAvailableBiometrics();
      final supportsBiometrics = canCheck || biometrics.isNotEmpty;
      final hasEnrollment = biometrics.isNotEmpty;

      final presentationType = _determinePresentationType(
        biometrics: biometrics,
        supportsBiometrics: supportsBiometrics,
      );

      return BiometricCapabilities(
        supportsBiometrics: supportsBiometrics,
        hasEnrollment: hasEnrollment,
        presentationType: presentationType,
      );
    } catch (_) {
      return BiometricCapabilities.unsupported;
    }
  }

  BiometricTypeEnum _determinePresentationType({
    required List<BiometricType> biometrics,
    required bool supportsBiometrics,
  }) {
    if (!supportsBiometrics) {
      return BiometricTypeEnum.none;
    }
    if (biometrics.contains(BiometricType.face)) {
      return BiometricTypeEnum.face;
    }
    if (biometrics.contains(BiometricType.fingerprint)) {
      return BiometricTypeEnum.fingerprint;
    }
    if (biometrics.contains(BiometricType.iris)) {
      return BiometricTypeEnum.iris;
    }
    if (biometrics.contains(BiometricType.strong) ||
        biometrics.contains(BiometricType.weak)) {
      return BiometricTypeEnum.generic;
    }
    if (biometrics.isNotEmpty) {
      return BiometricTypeEnum.generic;
    }
    return BiometricTypeEnum.none;
  }

  /// Checks if the device hardware supports biometrics and can check biometrics.
  Future<bool> isDeviceSupported() async {
    final caps = await getCapabilities();
    return caps.supportsBiometrics;
  }

  /// Returns the list of available/enrolled biometrics on the device.
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  /// Determines the primary biometric type for localized UI presentation.
  Future<BiometricTypeEnum> getPrimaryBiometricType() async {
    final caps = await getCapabilities();
    return caps.presentationType;
  }

  /// Cancels any active system biometric prompt and resets the authenticating guard.
  Future<bool> cancelAuthentication() async {
    try {
      final stopped = await _localAuth.stopAuthentication();
      _isAuthenticating = false;
      return stopped;
    } catch (_) {
      _isAuthenticating = false;
      return false;
    }
  }

  /// Performs biometric authentication using system dialog.
  Future<BiometricAuthResult> authenticate({
    required String localizedReason,
    bool biometricOnly = false,
  }) async {
    if (_isAuthenticating) {
      return const BiometricAuthResult.busy();
    }
    _isAuthenticating = true;
    try {
      final caps = await getCapabilities();
      if (!caps.supportsBiometrics) {
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.notAvailable,
          'Biometric authentication is not supported on this device.',
        );
      }
      if (!caps.hasEnrollment) {
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.notEnrolled,
          'No biometrics enrolled on this device.',
        );
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          useErrorDialogs: false,
        ),
      );

      if (authenticated) {
        return const BiometricAuthResult.success();
      }

      return const BiometricAuthResult.failure(BiometricAuthStatus.failed);
    } on PlatformException catch (e) {
      return _mapPlatformException(e);
    } catch (e) {
      return BiometricAuthResult.failure(
        BiometricAuthStatus.error,
        e.toString(),
      );
    } finally {
      _isAuthenticating = false;
    }
  }

  /// Maps native platform exceptions to structured BiometricAuthResult.
  BiometricAuthResult _mapPlatformException(PlatformException exception) {
    switch (exception.code) {
      case auth_error.notAvailable:
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.notAvailable,
          'Biometrics not available on device.',
        );
      case auth_error.notEnrolled:
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.notEnrolled,
          'No biometrics enrolled on this device.',
        );
      case auth_error.passcodeNotSet:
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.passcodeNotSet,
          'Device security/passcode is not set.',
        );
      case auth_error.lockedOut:
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.lockedOut,
          'Biometric authentication is temporarily locked out due to too many attempts.',
        );
      case auth_error.permanentlyLockedOut:
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.permanentlyLockedOut,
          'Biometric authentication is permanently locked out. Unlock with passcode.',
        );
      case 'auth_in_progress':
        return const BiometricAuthResult.busy();
      case 'UserCanceled':
      case 'user_canceled':
      case 'Canceled':
      case 'canceled':
        return const BiometricAuthResult.canceled();
      default:
        return BiometricAuthResult.failure(
          BiometricAuthStatus.error,
          exception.message ?? exception.code,
        );
    }
  }

  /// Whether user has enabled biometric login in settings.
  bool isBiometricEnabled() {
    return _sharedPreferences.getBool(AppConstants.biometricEnabled) ?? false;
  }

  /// Saves user biometric preference flag.
  Future<void> setBiometricEnabled(bool enabled) async {
    await _sharedPreferences.setBool(AppConstants.biometricEnabled, enabled);
  }

  /// Whether user has deferred biometric setup.
  bool isBiometricDeferred() {
    return _sharedPreferences.getBool(AppConstants.biometricDeferred) ?? false;
  }

  /// Saves user deferral preference flag.
  Future<void> setBiometricDeferred(bool deferred) async {
    await _sharedPreferences.setBool(AppConstants.biometricDeferred, deferred);
  }

  /// Checks if user has a stored session and has enabled biometric login.
  bool canRestoreSession() {
    return isBiometricEnabled() &&
        (_tokenService.isAccessTokenSaved || _tokenService.isRefreshTokenSaved);
  }

  /// Checks if biometric login can be offered to the user on the login screen.
  Future<bool> canOfferBiometricLogin() async {
    try {
      final caps = await getCapabilities();
      if (!caps.supportsBiometrics || !caps.hasEnrollment) {
        return false;
      }
      final hasCreds = await _tokenService.hasBiometricCredentials();
      return isBiometricEnabled() && hasCreds;
    } catch (_) {
      return false;
    }
  }

  /// Retrieves saved credentials for biometric login if available.
  Future<BiometricCredentials?> getSavedCredentials() {
    return _tokenService.getBiometricCredentials();
  }

  /// Saves user credentials securely for seamless biometric re-authentication.
  Future<void> saveBiometricCredentials({
    required String phone,
    required String password,
    required String countryCode,
  }) {
    return _tokenService.saveBiometricCredentials(
      phone: phone,
      password: password,
      countryCode: countryCode,
    );
  }

  /// Clears stored biometric credentials.
  Future<void> clearBiometricCredentials() {
    return _tokenService.deleteBiometricCredentials();
  }

  /// Safely disables biometric login (e.g. on manual logout or user preference).
  Future<void> disableBiometric() async {
    await setBiometricEnabled(false);
    await _tokenService.deleteBiometricCredentials();
  }
}
