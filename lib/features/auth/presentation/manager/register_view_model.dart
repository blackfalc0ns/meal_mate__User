import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/resend_phone_otp_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/register_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/resend_phone_otp_usecase.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/verify_phone_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

@injectable
class RegisterViewModel extends Cubit<RegisterState> {
  RegisterViewModel(
    this._registerUseCase,
    this._verifyPhoneUseCase,
    this._resendPhoneOtpUseCase,
  ) : super(const RegisterState());

  final RegisterUseCase _registerUseCase;
  final VerifyPhoneUseCase _verifyPhoneUseCase;
  final ResendPhoneOtpUseCase _resendPhoneOtpUseCase;

  bool _inFlight = false;

  void doIntent(RegisterEvent event) {
    switch (event) {
      case SubmitRegisterEvent(:final request):
        unawaited(_submitRegister(request));
      case VerifyRegisterPhoneEvent(:final code):
        unawaited(_verifyPhone(code));
      case ResendRegisterOtpEvent():
        unawaited(_resendOtp());
      case ClearRegisterFeedbackEvent():
        _clearFeedback();
      case ResetRegisterFlowEvent():
        _resetFlow();
    }
  }

  void _clearFeedback() {
    emit(
      state.copyWith(
        outcome: RegisterOutcome.idle,
        failure: () => null,
        resendOtpSent: false,
      ),
    );
  }

  void _resetFlow() {
    emit(const RegisterState());
  }

  Future<void> _submitRegister(RegisterRequestEntity request) async {
    if (_inFlight || state.isLoading) return;
    _inFlight = true;

    emit(
      state.copyWith(
        isLoading: true,
        outcome: RegisterOutcome.idle,
        failure: () => null,
        snapshotPhone: () => request.phone,
        snapshotCountryCode: () => request.countryCode,
        snapshotFullName: () => request.fullName,
      ),
    );

    try {
      final result = await _registerUseCase(request);
      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          if (!result.data.otpSent) {
            emit(
              state.copyWith(
                isLoading: false,
                outcome: RegisterOutcome.failure,
                failure: () => ServerFailure(
                  errorMessage: 'Failed to send verification code',
                  exception: const ApiException(
                    errorType: ApiErrorType.badRequest,
                    message: 'Failed to send verification code',
                  ),
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                outcome: RegisterOutcome.registrationSuccess,
                userId: () => result.data.userId,
                retryAvailableAtUtc: () =>
                    DateTime.now().toUtc().add(const Duration(seconds: 60)),
              ),
            );
          }
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: RegisterOutcome.failure,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: RegisterOutcome.failure,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _verifyPhone(String code) async {
    if (_inFlight || state.isLoading) return;

    if (!state.hasActiveVerification) {
      emit(
        state.copyWith(
          outcome: RegisterOutcome.failure,
          failure: () => ServerFailure(
            errorMessage: 'Phone number snapshot missing',
            exception: const ApiException(
              errorType: ApiErrorType.badRequest,
              message: 'Phone number snapshot missing',
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
        outcome: RegisterOutcome.idle,
        failure: () => null,
      ),
    );

    try {
      final result = await _verifyPhoneUseCase(
        VerifyPhoneRequestEntity(
          phone: state.snapshotPhone!,
          code: code,
          countryCode: state.snapshotCountryCode!,
        ),
      );

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: RegisterOutcome.phoneVerifiedSuccess,
              userId: () => result.data.userId,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: RegisterOutcome.failure,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: RegisterOutcome.failure,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _resendOtp() async {
    if (_inFlight || state.isResending) return;

    if (!state.hasActiveVerification) {
      emit(
        state.copyWith(
          outcome: RegisterOutcome.failure,
          failure: () => ServerFailure(
            errorMessage: 'Phone number snapshot missing',
            exception: const ApiException(
              errorType: ApiErrorType.badRequest,
              message: 'Phone number snapshot missing',
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
      final result = await _resendPhoneOtpUseCase(
        ResendPhoneOtpRequestEntity(
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
            state.copyWith(
              isResending: false,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isResending: false,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }
}
