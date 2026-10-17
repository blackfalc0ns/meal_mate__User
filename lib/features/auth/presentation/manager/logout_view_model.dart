import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/biometric/biometric_service.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/logout_usecase.dart';
import 'package:meal_meat_user/features/calendar/data/services/customer_delivery_realtime_service.dart';
import 'logout_event.dart';
import 'logout_state.dart';

@injectable
class LogoutViewModel extends Bloc<LogoutEvent, LogoutState> {
  LogoutViewModel(
    this._logoutUseCase,
    this._tokenService,
    this._biometricService, [
    this._deliveryRealtimeService,
  ]) : super(const LogoutState()) {
    on<RequestLogoutEvent>(_onRequestLogout);
    on<ClearLogoutFeedbackEvent>(_onClearFeedback);
  }

  final LogoutUseCase _logoutUseCase;
  final TokenService _tokenService;
  final BiometricService _biometricService;
  final CustomerDeliveryRealtimeService? _deliveryRealtimeService;

  bool _inFlight = false;

  Future<void> _onRequestLogout(
    RequestLogoutEvent event,
    Emitter<LogoutState> emit,
  ) async {
    if (_inFlight || state.isLoading) return;

    _inFlight = true;
    emit(
      state.copyWith(
        isLoading: true,
        outcome: LogoutOutcome.idle,
        failure: () => null,
      ),
    );

    try {
      final refreshToken = await _tokenService.getRefreshToken() ?? '';
      final result = await _logoutUseCase(
        LogoutRequestEntity(refreshToken: refreshToken),
      );

      if (event.invalidateBiometrics) {
        await _biometricService.disableBiometric();
      }

      await _deliveryRealtimeService?.disconnect();

      // Guarantee local session clear even if network/remote fails
      await _tokenService.clearSession();

      if (isClosed) return;

      switch (result) {
        case ApiSuccessResult():
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LogoutOutcome.success,
              isServerRevoked: true,
              failure: () => null,
            ),
          );
        case ApiErrorResult():
          // Local logout succeeded, but server revocation returned an error
          emit(
            state.copyWith(
              isLoading: false,
              outcome: LogoutOutcome.success,
              isServerRevoked: false,
              failure: () => result.failure,
            ),
          );
      }
    } catch (_) {
      // Always guarantee local cleanup on exceptions
      await _deliveryRealtimeService?.disconnect();
      await _tokenService.clearSession();
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            outcome: LogoutOutcome.success,
            isServerRevoked: false,
          ),
        );
      }
    } finally {
      _inFlight = false;
    }
  }

  void _onClearFeedback(
    ClearLogoutFeedbackEvent event,
    Emitter<LogoutState> emit,
  ) {
    emit(state.copyWith(outcome: LogoutOutcome.idle, failure: () => null));
  }
}
