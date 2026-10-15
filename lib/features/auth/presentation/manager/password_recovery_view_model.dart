import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_password_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_password_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/reset_password_usecase.dart';
import 'password_recovery_event.dart';
import 'password_recovery_state.dart';

@injectable
class PasswordRecoveryViewModel extends Cubit<PasswordRecoveryState> {
  PasswordRecoveryViewModel(
    this._forgotPasswordUseCase,
    this._resendPasswordOtpUseCase,
    this._resetPasswordUseCase,
    this._tokenService,
  ) : super(const PasswordRecoveryState());

  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResendPasswordOtpUseCase _resendPasswordOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final TokenService _tokenService;

  bool _inFlight = false;

  void doIntent(PasswordRecoveryEvent event) {
    switch (event) {
      case RequestRecoveryOtpEvent(:final phone, :final countryCode):
        unawaited(_requestOtp(phone: phone, countryCode: countryCode));
      case SaveRecoveryOtpEvent(:final code):
        _saveOtp(code);
      case ResendRecoveryOtpEvent():
        unawaited(_resendOtp());
      case SubmitResetPasswordEvent(:final newPassword):
        unawaited(_submitReset(newPassword: newPassword));
      case ClearRecoveryFeedbackEvent():
        _clearFeedback();
      case ResetRecoveryFlowEvent():
        _resetFlow();
    }
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        outcome: PasswordRecoveryOutcome.idle,
        failure: () => null,
        resendOtpSent: false,
      ),
    );
  }

  void _resetFlow() {
    emit(const PasswordRecoveryState());
  }

  void _saveOtp(String code) {
    emit(
      state.copyWith(
        otpCode: () => code,
        outcome: PasswordRecoveryOutcome.otpCodeReady,
        failure: () => null,
      ),
    );
  }

  Future<void> _requestOtp({
    required String phone,
    required String countryCode,
  }) async {
    if (_inFlight || state.isLoading) return;
    _inFlight = true;

    emit(
      state.copyWith(
        isLoading: true,
        outcome: PasswordRecoveryOutcome.idle,
        failure: () => null,
        snapshotPhone: () => phone,
        snapshotCountryCode: () => countryCode,
      ),
    );

    try {
      final result = await _forgotPasswordUseCase(
        ForgotPasswordRequestEntity(phone: phone, countryCode: countryCode),
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          if (!result.data.otpSent) {
            emit(
              state.copyWith(
                isLoading: false,
                outcome: PasswordRecoveryOutcome.failure,
                failure: () => ServerFailure(
                  errorMessage: 'Failed to send recovery code',
                  exception: const ApiException(
                    errorType: ApiErrorType.badRequest,
                    message: 'Failed to send recovery code',
                  ),
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                outcome: PasswordRecoveryOutcome.otpSentSuccess,
                retryAvailableAtUtc: () =>
                    DateTime.now().toUtc().add(const Duration(seconds: 60)),
              ),
            );
          }
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: PasswordRecoveryOutcome.failure,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: PasswordRecoveryOutcome.failure,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _resendOtp() async {
    if (_inFlight || state.isResending) return;

    if (!state.hasActiveRecovery) {
      emit(
        state.copyWith(
          outcome: PasswordRecoveryOutcome.failure,
          failure: () => ServerFailure(
            errorMessage: 'Recovery snapshot missing',
            exception: const ApiException(
              errorType: ApiErrorType.badRequest,
              message: 'Recovery snapshot missing',
            ),
          ),
        ),
      );
      return;
    }

    _inFlight = true;
    emit(
      state.copyWith(
        isResending: true,
        failure: () => null,
        resendOtpSent: false,
      ),
    );

    try {
      final result = await _resendPasswordOtpUseCase(
        ResendPasswordOtpRequestEntity(
          phone: state.snapshotPhone!,
          countryCode: state.snapshotCountryCode!,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          emit(
            state.copyWith(
              isResending: false,
              resendOtpSent: result.data.otpSent,
              retryAvailableAtUtc: result.data.otpSent
                  ? () =>
                        DateTime.now().toUtc().add(const Duration(seconds: 60))
                  : null,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(isResending: false, failure: () => result.failure),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(isResending: false));
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _submitReset({required String newPassword}) async {
    if (_inFlight || state.isLoading) return;

    if (!state.hasActiveRecovery || state.otpCode == null) {
      emit(
        state.copyWith(
          outcome: PasswordRecoveryOutcome.failure,
          failure: () => ServerFailure(
            errorMessage: 'Recovery data or OTP missing',
            exception: const ApiException(
              errorType: ApiErrorType.badRequest,
              message: 'Recovery data or OTP missing',
            ),
          ),
        ),
      );
      return;
    }

    _inFlight = true;
    emit(
      state.copyWith(
        isLoading: true,
        outcome: PasswordRecoveryOutcome.idle,
        failure: () => null,
      ),
    );

    try {
      final result = await _resetPasswordUseCase(
        ResetPasswordRequestEntity(
          phone: state.snapshotPhone!,
          otpCode: state.otpCode!,
          newPassword: newPassword,
          countryCode: state.snapshotCountryCode!,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          // Spec: invalidate old biometric credentials on password reset
          await _tokenService.deleteBiometricCredentials();
          if (isClosed) return;

          emit(
            state.copyWith(
              isLoading: false,
              outcome: PasswordRecoveryOutcome.resetSuccess,
              otpCode: () => null,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: PasswordRecoveryOutcome.failure,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: PasswordRecoveryOutcome.failure,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }
}
