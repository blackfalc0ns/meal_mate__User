import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_credentials.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'biometric_state.dart';

@injectable
class BiometricCubit extends Cubit<BiometricState> {
  BiometricCubit(this._biometricService) : super(const BiometricState());

  final BiometricService _biometricService;

  /// Initializes and checks device biometric capabilities and user preferences.
  Future<void> init() async {
    final isSupported = await _biometricService.isDeviceSupported();
    final biometricType = await _biometricService.getPrimaryBiometricType();
    final isEnabled = _biometricService.isBiometricEnabled();
    final canRestoreSession = await _biometricService.canOfferBiometricLogin();
    final savedCreds = await _biometricService.getSavedCredentials();

    emit(
      state.copyWith(
        isSupported: isSupported,
        biometricType: biometricType,
        isEnabled: isEnabled,
        canRestoreSession: canRestoreSession,
        savedCredentials: savedCreds,
      ),
    );
  }

  /// Toggles biometric login on or off. When enabling, prompts authentication first.
  Future<bool> toggleBiometric({
    required bool enable,
    required String localizedReason,
    String? notSupportedMessage,
    String? notEnrolledMessage,
    String? lockedOutMessage,
    String? genericErrorMessage,
  }) async {
    if (!enable) {
      await _biometricService.disableBiometric();
      emit(
        state.copyWith(
          isEnabled: false,
          canRestoreSession: false,
          isSuccess: true,
          clearError: true,
          clearAuthStatus: true,
        ),
      );
      return true;
    }

    emit(state.copyWith(isLoading: true, clearError: true, clearAuthStatus: true));

    final supported = await _biometricService.isDeviceSupported();
    if (!supported) {
      emit(
        state.copyWith(
          isLoading: false,
          isEnabled: false,
          authStatus: BiometricAuthStatus.notAvailable,
          errorMessage: notSupportedMessage ?? 'Biometrics not supported on this device.',
        ),
      );
      return false;
    }

    final result = await _biometricService.authenticate(
      localizedReason: localizedReason,
    );

    if (result.isSuccess) {
      await _biometricService.setBiometricEnabled(true);
      final canRestore = _biometricService.canRestoreSession();
      emit(
        state.copyWith(
          isLoading: false,
          isEnabled: true,
          canRestoreSession: canRestore,
          isSuccess: true,
          authStatus: BiometricAuthStatus.success,
          clearError: true,
        ),
      );
      return true;
    } else {
      String? message;
      switch (result.status) {
        case BiometricAuthStatus.notEnrolled:
          message = notEnrolledMessage ?? 'No biometrics enrolled.';
          break;
        case BiometricAuthStatus.lockedOut:
        case BiometricAuthStatus.permanentlyLockedOut:
          message = lockedOutMessage ?? 'Biometric authentication is locked.';
          break;
        case BiometricAuthStatus.canceled:
          message = null;
          break;
        default:
          message = genericErrorMessage ?? result.errorMessage ?? 'Biometric authentication failed.';
      }

      emit(
        state.copyWith(
          isLoading: false,
          isEnabled: false,
          isSuccess: false,
          authStatus: result.status,
          errorMessage: message,
        ),
      );
      return false;
    }
  }

  /// Attempts biometric authentication to login or restore existing session.
  Future<BiometricCredentials?> authenticateForLogin({
    required String localizedReason,
    String? lockedOutMessage,
    String? permanentlyLockedOutMessage,
    String? notEnrolledMessage,
    String? genericErrorMessage,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearAuthStatus: true));

    final result = await _biometricService.authenticate(
      localizedReason: localizedReason,
    );

    if (result.isSuccess) {
      final savedCreds = await _biometricService.getSavedCredentials();
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          authStatus: BiometricAuthStatus.success,
          savedCredentials: savedCreds,
          clearError: true,
        ),
      );
      return savedCreds;
    } else {
      String? message;
      if (result.status == BiometricAuthStatus.lockedOut) {
        message = lockedOutMessage ?? 'Biometric authentication is temporarily locked.';
      } else if (result.status == BiometricAuthStatus.permanentlyLockedOut) {
        message = permanentlyLockedOutMessage ??
            lockedOutMessage ??
            'Biometric authentication is permanently locked.';
      } else if (result.status == BiometricAuthStatus.notEnrolled) {
        message = notEnrolledMessage ?? 'No biometrics enrolled on this device.';
      } else if (result.status != BiometricAuthStatus.canceled) {
        message = genericErrorMessage ?? result.errorMessage ?? 'Authentication failed.';
      }

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          authStatus: result.status,
          errorMessage: message,
        ),
      );
      return null;
    }
  }

  void resetState() {
    emit(state.copyWith(clearError: true, clearAuthStatus: true, isSuccess: false));
  }
}
