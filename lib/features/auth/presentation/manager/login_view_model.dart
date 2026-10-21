import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_event.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/biometric/biometric_auth_result.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_set_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_verify_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/login_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/entities/family_first_login_resend_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_family_first_login_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/set_family_first_login_password_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/verify_family_first_login_otp_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(
    this._loginUseCase,
    this._biometricService, {
    this.verifyFamilyFirstLoginOtpUseCase,
    this.setFamilyFirstLoginPasswordUseCase,
    this.resendFamilyFirstLoginOtpUseCase,
    this.getCurrentCustomerSubscriptionUseCase,
    this.getMyFamilyContextsUseCase,
    this.sharedPrefHelper,
  }) : super(const LoginState());

  final LoginUseCase _loginUseCase;
  final BiometricService _biometricService;
  final VerifyFamilyFirstLoginOtpUseCase? verifyFamilyFirstLoginOtpUseCase;
  final SetFamilyFirstLoginPasswordUseCase? setFamilyFirstLoginPasswordUseCase;
  final ResendFamilyFirstLoginOtpUseCase? resendFamilyFirstLoginOtpUseCase;
  final GetCurrentCustomerSubscriptionUseCase?
  getCurrentCustomerSubscriptionUseCase;
  final GetMyFamilyContextsUseCase? getMyFamilyContextsUseCase;
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
      case VerifyFamilyFirstLoginOtpEvent(:final otpCode):
        unawaited(_verifyFamilyFirstLoginOtp(otpCode));
      case SetFamilyFirstLoginPasswordEvent(:final newPassword):
        unawaited(_setFamilyFirstLoginPassword(newPassword));
      case ResendFamilyFirstLoginOtpEvent():
        unawaited(_resendFamilyFirstLoginOtp());
      case ResetFamilyFirstLoginFlowEvent():
        _resetFamilyFirstLoginFlow();
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
          final loginEntity = result.data;
          if (loginEntity.isPendingFamilyFirstLogin) {
            emit(
              state.copyWith(
                isLoading: false,
                outcome: LoginOutcome.familyVerifyOtpPending,
                familyChallengeToken: () => loginEntity.loginChallengeToken,
                familyChallengeExpiresAtUtc: () =>
                    loginEntity.loginChallengeExpiresAtUtc,
                familyNextStep: () => loginEntity.nextStep,
                loginEntity: () => loginEntity,
                requiresFreshLogin: false,
              ),
            );
            return;
          }
          await _syncSubscriptionCache();
          await _refreshFamilyContexts();
          if (isClosed) return;
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.success,
              loginEntity: () => loginEntity,
              familyChallengeToken: () => null,
              familyChallengeExpiresAtUtc: () => null,
              familyNextStep: () => null,
              requiresFreshLogin: false,
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

  Future<void> _verifyFamilyFirstLoginOtp(String otpCode) async {
    if (_inFlight || state.isLoading) return;
    final challengeToken = state.familyChallengeToken;
    if (challengeToken == null ||
        challengeToken.isEmpty ||
        state.isChallengeExpired) {
      emit(
        state.copyWith(
          outcome: LoginOutcome.failure,
          requiresFreshLogin: true,
          familyChallengeToken: () => null,
          familyChallengeExpiresAtUtc: () => null,
          familyNextStep: () => null,
          failure: () => Failure(
            errorMessage: 'auth_family_challenge_expired',
            code: 'auth.challenge_expired',
          ),
        ),
      );
      return;
    }

    _inFlight = true;
    emit(
      state.copyWith(
        isLoading: true,
        outcome: LoginOutcome.idle,
        failure: () => null,
      ),
    );

    try {
      final useCase = verifyFamilyFirstLoginOtpUseCase;
      if (useCase == null) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: LoginOutcome.failure,
            failure: () => Failure(
              errorMessage: 'Verify OTP use case not registered',
              code: 'NOT_REGISTERED',
            ),
          ),
        );
        return;
      }

      final result = await useCase(
        FamilyFirstLoginVerifyOtpRequestEntity(
          loginChallengeToken: challengeToken,
          otpCode: otpCode,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult(:final data):
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.familySetPasswordPending,
              familyChallengeToken: () => data.loginChallengeToken,
              familyChallengeExpiresAtUtc: () =>
                  data.loginChallengeExpiresAtUtc,
              familyNextStep: () => data.nextStep,
              requiresFreshLogin: false,
            ),
          );
        case ApiErrorResult(:final failure):
          final isExpiredOrInvalid =
              failure.code == 'auth.challenge_expired' ||
              failure.code == 'family.challenge_expired' ||
              failure.code == 'auth.family_state_invalid' ||
              failure.code == 'family.member_disabled' ||
              failure.code == 'family.group_inactive';
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.failure,
              failure: () => failure,
              requiresFreshLogin: isExpiredOrInvalid,
              familyChallengeToken: isExpiredOrInvalid ? () => null : null,
              familyChallengeExpiresAtUtc: isExpiredOrInvalid
                  ? () => null
                  : null,
              familyNextStep: isExpiredOrInvalid ? () => null : null,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: LoginOutcome.failure,
            failure: () =>
                Failure(errorMessage: 'error_server', code: 'SERVER_ERROR'),
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _setFamilyFirstLoginPassword(String newPassword) async {
    if (_inFlight || state.isLoading) return;
    final challengeToken = state.familyChallengeToken;
    if (challengeToken == null ||
        challengeToken.isEmpty ||
        state.isChallengeExpired) {
      emit(
        state.copyWith(
          outcome: LoginOutcome.failure,
          requiresFreshLogin: true,
          familyChallengeToken: () => null,
          familyChallengeExpiresAtUtc: () => null,
          familyNextStep: () => null,
          failure: () => Failure(
            errorMessage: 'auth_family_challenge_expired',
            code: 'auth.challenge_expired',
          ),
        ),
      );
      return;
    }

    _inFlight = true;
    emit(
      state.copyWith(
        isLoading: true,
        outcome: LoginOutcome.idle,
        failure: () => null,
      ),
    );

    try {
      final useCase = setFamilyFirstLoginPasswordUseCase;
      if (useCase == null) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: LoginOutcome.failure,
            failure: () => Failure(
              errorMessage: 'Set password use case not registered',
              code: 'NOT_REGISTERED',
            ),
          ),
        );
        return;
      }

      final persistence = state.rememberMe
          ? SessionPersistence.remembered
          : SessionPersistence.currentRun;

      final result = await useCase(
        FamilyFirstLoginSetPasswordRequestEntity(
          loginChallengeToken: challengeToken,
          newPassword: newPassword,
        ),
        persistence: persistence,
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult(:final data):
          await _syncSubscriptionCache();
          await _refreshFamilyContexts();
          if (isClosed) return;
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.success,
              loginEntity: () => data,
              familyChallengeToken: () => null,
              familyChallengeExpiresAtUtc: () => null,
              familyNextStep: () => null,
              requiresFreshLogin: false,
            ),
          );
        case ApiErrorResult(:final failure):
          final isExpiredOrInvalid =
              failure.code == 'auth.challenge_expired' ||
              failure.code == 'family.challenge_expired' ||
              failure.code == 'auth.family_state_invalid' ||
              failure.code == 'family.member_disabled' ||
              failure.code == 'family.group_inactive';
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LoginOutcome.failure,
              failure: () => failure,
              requiresFreshLogin: isExpiredOrInvalid,
              familyChallengeToken: isExpiredOrInvalid ? () => null : null,
              familyChallengeExpiresAtUtc: isExpiredOrInvalid
                  ? () => null
                  : null,
              familyNextStep: isExpiredOrInvalid ? () => null : null,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: LoginOutcome.failure,
            failure: () =>
                Failure(errorMessage: 'error_server', code: 'SERVER_ERROR'),
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _resendFamilyFirstLoginOtp() async {
    if (_inFlight || state.isLoading || state.isResending) return;
    final challengeToken = state.familyChallengeToken;
    if (challengeToken == null ||
        challengeToken.isEmpty ||
        state.isChallengeExpired) {
      emit(
        state.copyWith(
          outcome: LoginOutcome.failure,
          requiresFreshLogin: true,
          familyChallengeToken: () => null,
          familyChallengeExpiresAtUtc: () => null,
          familyNextStep: () => null,
          failure: () => Failure(
            errorMessage: 'auth_family_challenge_expired',
            code: 'auth.challenge_expired',
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isResending: true,
        resendOtpSent: false,
        failure: () => null,
      ),
    );

    try {
      final useCase = resendFamilyFirstLoginOtpUseCase;
      if (useCase == null) {
        emit(
          state.copyWith(
            isResending: false,
            outcome: LoginOutcome.failure,
            failure: () => Failure(
              errorMessage: 'Resend OTP use case not registered',
              code: 'NOT_REGISTERED',
            ),
          ),
        );
        return;
      }

      final result = await useCase(
        FamilyFirstLoginResendOtpRequestEntity(
          loginChallengeToken: challengeToken,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult(:final data):
          emit(
            state.copyWith(
              isResending: false,
              resendOtpSent: true,
              familyChallengeToken: () => data.loginChallengeToken,
              familyChallengeExpiresAtUtc: () =>
                  data.loginChallengeExpiresAtUtc,
              familyNextStep: () => data.nextStep,
              requiresFreshLogin: false,
            ),
          );
        case ApiErrorResult(:final failure):
          final isExpiredOrInvalid =
              failure.code == 'auth.challenge_expired' ||
              failure.code == 'family.challenge_expired' ||
              failure.code == 'auth.family_state_invalid' ||
              failure.code == 'family.member_disabled' ||
              failure.code == 'family.group_inactive';
          emit(
            state.copyWith(
              isResending: false,
              outcome: LoginOutcome.failure,
              failure: () => failure,
              requiresFreshLogin: isExpiredOrInvalid,
              familyChallengeToken: isExpiredOrInvalid ? () => null : null,
              familyChallengeExpiresAtUtc: isExpiredOrInvalid
                  ? () => null
                  : null,
              familyNextStep: isExpiredOrInvalid ? () => null : null,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isResending: false,
            outcome: LoginOutcome.failure,
            failure: () =>
                Failure(errorMessage: 'error_server', code: 'SERVER_ERROR'),
          ),
        );
      }
    }
  }

  void _resetFamilyFirstLoginFlow() {
    emit(
      state.copyWith(
        familyChallengeToken: () => null,
        familyChallengeExpiresAtUtc: () => null,
        familyNextStep: () => null,
        requiresFreshLogin: false,
        outcome: LoginOutcome.idle,
      ),
    );
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

  Future<void> _refreshFamilyContexts() async {
    if (getIt.isRegistered<FamilyContextViewModel>()) {
      final context = getIt<FamilyContextViewModel>();
      context.doIntent(const ClearFamilyContextsEvent());
      context.loadFamilyContext();
    } else {
      final useCase = getMyFamilyContextsUseCase;
      if (useCase == null) return;
      await useCase();
    }
  }
}
