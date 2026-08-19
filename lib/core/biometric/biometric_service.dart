import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/token_service.dart';
import '../utils/constants.dart';
import 'biometric_auth_result.dart';

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

  /// Checks if the device hardware supports biometrics and can check biometrics.
  Future<bool> isDeviceSupported() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) return false;
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
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
    try {
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        return BiometricTypeEnum.none;
      }

      final biometrics = await getAvailableBiometrics();
      if (biometrics.contains(BiometricType.face)) {
        return BiometricTypeEnum.face;
      }
      if (biometrics.contains(BiometricType.fingerprint) ||
          biometrics.contains(BiometricType.strong) ||
          biometrics.contains(BiometricType.weak)) {
        return BiometricTypeEnum.fingerprint;
      }
      if (biometrics.contains(BiometricType.iris)) {
        return BiometricTypeEnum.iris;
      }
      if (biometrics.isNotEmpty) {
        return BiometricTypeEnum.generic;
      }
      return BiometricTypeEnum.generic;
    } catch (_) {
      return BiometricTypeEnum.none;
    }
  }

  /// Performs biometric authentication using system dialog.
  Future<BiometricAuthResult> authenticate({
    required String localizedReason,
    bool biometricOnly = true,
  }) async {
    try {
      final supported = await isDeviceSupported();
      if (!supported) {
        return const BiometricAuthResult.failure(
          BiometricAuthStatus.notAvailable,
          'Biometric authentication is not supported on this device.',
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
      case 'UserCanceled':
      case 'user_canceled':
      case 'Canceled':
      case 'canceled':
      case 'auth_in_progress':
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

  /// Checks if user has a stored session and has enabled biometric login.
  bool canRestoreSession() {
    return isBiometricEnabled() &&
        (_tokenService.isAccessTokenSaved || _tokenService.isRefreshTokenSaved);
  }

  /// Safely disables biometric login (e.g. on manual logout or user preference).
  Future<void> disableBiometric() async {
    await setBiometricEnabled(false);
  }
}
