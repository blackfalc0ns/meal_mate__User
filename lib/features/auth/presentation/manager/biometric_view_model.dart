import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'biometric_event.dart';
import 'biometric_state.dart';

@injectable
class BiometricViewModel extends Cubit<BiometricState> {
  BiometricViewModel(this._biometricService) : super(const BiometricState());

  final BiometricService _biometricService;
  bool _inFlight = false;

  void doIntent(BiometricEvent event) {
    switch (event) {
      case InitBiometricEvent():
        unawaited(_init());
      case ToggleBiometricEvent(:final enable, :final localizedReason):
        unawaited(_toggleBiometric(enable: enable, localizedReason: localizedReason));
      case ClearBiometricFeedbackEvent():
        _clearFeedback();
      case DeferBiometricEvent():
        unawaited(_deferBiometric());
    }
  }

  Future<void> _deferBiometric() async {
    await _biometricService.setBiometricDeferred(true);
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        clearError: true,
        clearAuthStatus: true,
        isSuccess: false,
      ),
    );
  }

  Future<void> _init() async {
    final caps = await _biometricService.getCapabilities();
    if (isClosed) return;
    final isEnabled = _biometricService.isBiometricEnabled();
    final canOffer = await _biometricService.canOfferBiometricLogin();
    if (isClosed) return;

    emit(
      state.copyWith(
        isSupported: caps.supportsBiometrics,
        hasEnrollment: caps.hasEnrollment,
        biometricType: caps.presentationType,
        isEnabled: isEnabled,
        canRestoreSession: canOffer,
      ),
    );
  }

  Future<void> _toggleBiometric({
    required bool enable,
    required String localizedReason,
  }) async {
    if (_inFlight) return;
    _inFlight = true;

    if (!enable) {
      try {
        await _biometricService.disableBiometric();
        if (isClosed) return;
        emit(
          state.copyWith(
            isEnabled: false,
            canRestoreSession: false,
            isSuccess: true,
            clearAuthStatus: true,
            clearError: true,
          ),
        );
      } finally {
        _inFlight = false;
      }
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        clearAuthStatus: true,
        clearError: true,
      ),
    );

    try {
      final caps = await _biometricService.getCapabilities();
      if (isClosed) return;
      if (!caps.supportsBiometrics) {
        emit(
          state.copyWith(
            isLoading: false,
            isEnabled: false,
            authStatus: BiometricAuthStatus.notAvailable,
          ),
        );
        return;
      }
      if (!caps.hasEnrollment) {
        emit(
          state.copyWith(
            isLoading: false,
            isEnabled: false,
            authStatus: BiometricAuthStatus.notEnrolled,
          ),
        );
        return;
      }

      final result = await _biometricService.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
      );
      if (isClosed) return;

      if (result.isSuccess) {
        await _biometricService.setBiometricEnabled(true);
        if (isClosed) return;
        final canRestore = await _biometricService.canOfferBiometricLogin();
        if (isClosed) return;

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
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            authStatus: result.status,
            errorMessage: result.errorMessage,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }
}
