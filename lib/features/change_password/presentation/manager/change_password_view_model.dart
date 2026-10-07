import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/change_password/domain/usecase/change_customer_password_usecase.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

@injectable
class ChangePasswordViewModel
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordViewModel(
    this._changeCustomerPasswordUseCase,
    this._tokenService,
  ) : super(const ChangePasswordState()) {
    on<SubmitChangePasswordEvent>(_onSubmit);
    on<ClearChangePasswordFeedbackEvent>(_onClearFeedback);
  }

  final ChangeCustomerPasswordUseCase _changeCustomerPasswordUseCase;
  final TokenService _tokenService;

  bool _inFlight = false;

  Future<void> _onSubmit(
    SubmitChangePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (_inFlight || state.isLoading) return;

    _inFlight = true;
    emit(
      state.copyWith(
        isLoading: true,
        outcome: ChangePasswordOutcome.idle,
        failure: () => null,
      ),
    );

    try {
      final result = await _changeCustomerPasswordUseCase(event.request);

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          // Spec: invalidate old biometric credentials upon successful password change
          await _tokenService.deleteBiometricCredentials();
          if (isClosed) return;

          emit(
            state.copyWith(
              isLoading: false,
              outcome: ChangePasswordOutcome.success,
              failure: () => null,
            ),
          );
        case ApiErrorResult():
          // Spec: do not invalidate biometric credentials on failure
          emit(
            state.copyWith(
              isLoading: false,
              outcome: ChangePasswordOutcome.failure,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: ChangePasswordOutcome.failure,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  void _onClearFeedback(
    ClearChangePasswordFeedbackEvent event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(
      state.copyWith(outcome: ChangePasswordOutcome.idle, failure: () => null),
    );
  }
}
