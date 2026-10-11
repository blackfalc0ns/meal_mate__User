import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/login_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(
    this._loginUseCase,
    this._biometricService, {
    this.getCurrentCustomerSubscriptionUseCase,
    this.sharedPrefHelper,
  }) : super(const LoginState());

  final LoginUseCase _loginUseCase;
  final BiometricService _biometricService;
  final GetCurrentCustomerSubscriptionUseCase?
  getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper? sharedPrefHelper;

  bool _inFlight = false;

  void doIntent(LoginEvent event) {
    switch (event) {
      case SubmitLoginEvent(:final request, :final rememberMe):
        unawaited(_submitLogin(request, rememberMe: rememberMe));
      case RememberMeChangedEvent(:final value):
        _onRememberMeChanged(value);
      case LoginWithBiometricsEvent(:final localizedReason):
        unawaited(_loginWithBiometrics(localizedReason));
      case CheckBiometricReadinessEvent():
        unawaited(_checkBiometricReadiness());
      case ClearLoginFeedbackEvent():
        _clearFeedback();
    }
  }

  void _onRememberMeChanged(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        outcome: LoginOutcome.idle,
        failure: () => null,
        biometricErrorMessage: () => null,
        biometricStatus: () => null,
      ),
    );
  }

  Future<void> _checkBiometricReadiness() async {
    try {
      final canOffer = await _biometricService.canOfferBiometricLogin();
      if (isClosed) return;
      emit(state.copyWith(isBiometricReady: canOffer));
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isBiometricReady: false));
      }
    }
  }

  Future<void> _submitLogin(
    LoginRequestEntity request, {
    required bool rememberMe,
  }) async {
    if (_inFlight || state.isLoading) return;
    _inFlight = true;

    emit(
      state.copyWith(
        isLoading: true,
        outcome: LoginOutcome.idle,
        rememberMe: rememberMe,
        failure: () => null,
        biometricErrorMessage: () => null,
        lastSubmittedRequestPhone: () => request.phone,
        lastSubmittedRequestCountryCode: () => request.countryCode,
      ),
    );

    try {
      final persistence = rememberMe
          ? SessionPersistence.remembered
          : SessionPersistence.currentRun;
      final result = await _loginUseCase(request, persistence: persistence);

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          await _syncSubscriptionCache();
          if (isClosed) return;
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.success,
              loginEntity: () => result.data,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.failure,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, outcome: LoginOutcome.failure));
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _loginWithBiometrics(String? localizedReason) async {
    if (_inFlight || state.isLoading) return;
    _inFlight = true;

    emit(
      state.copyWith(
        isLoading: true,
        outcome: LoginOutcome.idle,
        failure: () => null,
        biometricErrorMessage: () => null,
      ),
    );

    try {
      final creds = await _biometricService.getSavedCredentials();
      if (creds == null) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.failure,
              biometricErrorMessage: () =>
                  'No saved biometric credentials on this device',
            ),
          );
        }
        return;
      }

      final authResult = await _biometricService.authenticate(
        localizedReason: localizedReason ?? 'Log in with biometrics',
        biometricOnly: true,
      );

      if (isClosed) return;

      if (!authResult.isSuccess) {
        if (authResult.status == BiometricAuthStatus.canceled) {
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.idle,
              biometricStatus: () => BiometricAuthStatus.canceled,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.failure,
              biometricStatus: () => authResult.status,
              biometricErrorMessage: () =>
                  authResult.errorMessage ?? 'Biometric authentication failed',
            ),
          );
        }
        return;
      }

      final persistence = state.rememberMe
          ? SessionPersistence.remembered
          : SessionPersistence.currentRun;

      final loginResult = await _loginUseCase(
        LoginRequestEntity(
          phone: creds.phone,
          password: creds.password,
          countryCode: creds.countryCode,
        ),
        persistence: persistence,
      );

      if (isClosed) return;

      switch (loginResult) {
        case ApiSuccessResult():
          await _syncSubscriptionCache();
          if (isClosed) return;
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.success,
              loginEntity: () => loginResult.data,
              lastSubmittedRequestPhone: () => creds.phone,
              lastSubmittedRequestCountryCode: () => creds.countryCode,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.failure,
              failure: () => loginResult.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, outcome: LoginOutcome.failure));
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _syncSubscriptionCache() async {
    final useCase = getCurrentCustomerSubscriptionUseCase;
    final prefHelper = sharedPrefHelper;
    if (useCase == null || prefHelper == null) return;

    try {
      final result = await useCase();
      switch (result) {
        case ApiSuccessResult():
          final subscriptionId = result.data.subscription?.subscriptionId ?? '';
          if (subscriptionId.isEmpty) {
            await prefHelper.removeData(key: StorageKeys.currentSubscriptionId);
          } else {
            await prefHelper.saveData(
              key: StorageKeys.currentSubscriptionId,
              val: subscriptionId,
            );
          }
        case ApiErrorResult():
          await prefHelper.removeData(key: StorageKeys.currentSubscriptionId);
      }
    } catch (_) {
      // Non-blocking auxiliary sync
    }
  }
}
