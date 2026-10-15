import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/offers/domain/entities/start_campaign_payment_request_entity.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/get_campaign_payment_status_usecase.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/start_campaign_payment_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/campaign_payment_state.dart';

@injectable
class CampaignPaymentViewModel extends Cubit<CampaignPaymentState> {
  CampaignPaymentViewModel(
    this._startCampaignPaymentUseCase,
    this._getCampaignPaymentStatusUseCase,
  ) : backoffScheduleOverride = null,
      super(const CampaignPaymentState());

  @visibleForTesting
  CampaignPaymentViewModel.withSchedule(
    this._startCampaignPaymentUseCase,
    this._getCampaignPaymentStatusUseCase, {
    this.backoffScheduleOverride,
  }) : super(const CampaignPaymentState());

  final StartCampaignPaymentUseCase _startCampaignPaymentUseCase;
  final GetCampaignPaymentStatusUseCase _getCampaignPaymentStatusUseCase;
  final Iterable<Duration> Function()? backoffScheduleOverride;

  bool _isCancelled = false;
  int _activePollGeneration = 0;

  void doIntent(CampaignPaymentEvent event) {
    switch (event) {
      case StartPaymentIntent():
        unawaited(_startPayment(event));
      case HandleReturnIntent():
        unawaited(_handleReturn(event));
      case ReadStatusIntent():
        unawaited(_readStatus(event.sessionId));
      case RetryPaymentIntent():
        unawaited(_retryPayment());
      case ResetPaymentFlowIntent():
        _resetFlow();
    }
  }

  Future<void> _startPayment(StartPaymentIntent intent) async {
    if (state.isLoading || state.isPolling) return;

    final stableKey =
        (state.sessionId == intent.sessionId &&
            state.idempotencyKey != null &&
            state.idempotencyKey!.isNotEmpty)
        ? state.idempotencyKey!
        : 'cp-${intent.sessionId}-${DateTime.now().millisecondsSinceEpoch}';

    emit(
      state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearServerErrorCode: true,
        sessionId: intent.sessionId,
        paymentMethodId: intent.paymentMethodId,
        idempotencyKey: stableKey,
      ),
    );

    final request = StartCampaignPaymentRequestEntity(
      sessionId: intent.sessionId,
      idempotencyKey: stableKey,
      callbackUrl: intent.callbackUrl,
      errorUrl: intent.errorUrl,
      paymentMethodId: intent.paymentMethodId,
    );

    final result = await _startCampaignPaymentUseCase(request);

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            paymentId: data.paymentId,
            paymentUrl: data.paymentUrl,
            amount: data.amount,
            currency: data.currency,
            status: data.status,
            rawStatus: data.rawStatus,
            expiresAtUtc: data.expiresAtUtc,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            isLoading: false,
            failure: failure,
            serverErrorCode: failure.code,
          ),
        );
    }
  }

  Future<void> _retryPayment() async {
    final sessionId = state.sessionId;
    if (sessionId == null || sessionId.isEmpty) return;
    if (state.isLoading || state.isPolling) return;

    await _startPayment(
      StartPaymentIntent(
        sessionId: sessionId,
        paymentMethodId: state.paymentMethodId,
      ),
    );
  }

  Future<void> _handleReturn(HandleReturnIntent intent) async {
    final effectiveSessionId = intent.sessionId.isNotEmpty
        ? intent.sessionId
        : (state.sessionId ?? '');
    if (effectiveSessionId.isEmpty) return;

    emit(
      state.copyWith(
        sessionId: effectiveSessionId,
        paymentId: intent.paymentId ?? state.paymentId,
      ),
    );

    await _pollStatus(effectiveSessionId);
  }

  Future<void> _readStatus(String sessionId) async {
    final effectiveSessionId = sessionId.isNotEmpty
        ? sessionId
        : (state.sessionId ?? '');
    if (effectiveSessionId.isEmpty) return;

    await _pollStatus(effectiveSessionId);
  }

  Future<void> _pollStatus(String sessionId) async {
    if (state.isPolling) return;

    _activePollGeneration++;
    final currentGen = _activePollGeneration;

    emit(
      state.copyWith(
        isPolling: true,
        clearFailure: true,
        clearServerErrorCode: true,
      ),
    );

    final schedule = backoffScheduleOverride != null
        ? backoffScheduleOverride!()
        : const [
            Duration(seconds: 1),
            Duration(seconds: 2),
            Duration(seconds: 4),
            Duration(seconds: 8),
            Duration(seconds: 16),
            Duration(seconds: 30),
          ];

    for (final delay in schedule) {
      if (isClosed || _isCancelled || _activePollGeneration != currentGen) {
        return;
      }

      final result = await _getCampaignPaymentStatusUseCase(sessionId);

      if (isClosed || _isCancelled || _activePollGeneration != currentGen) {
        return;
      }

      switch (result) {
        case ApiSuccessResult(:final data):
          emit(
            state.copyWith(
              status: data.status,
              rawStatus: data.rawStatus,
              subscriptionId: data.subscriptionId ?? state.subscriptionId,
              amount: data.amount ?? state.amount,
              currency: data.currency,
              expiresAtUtc: data.expiresAtUtc ?? state.expiresAtUtc,
              paymentId: data.paymentId ?? state.paymentId,
              paymentUrl: data.paymentUrl ?? state.paymentUrl,
              pollAttemptCount: state.pollAttemptCount + 1,
            ),
          );

          if (data.isTerminal) {
            emit(state.copyWith(isPolling: false));
            return;
          }
        case ApiErrorResult(:final failure):
          final statusCode = failure.exception.statusCode;
          // Stop polling on 404 (not found / ownership), 409 (conflict/expired), or validation error 422
          if (statusCode == 404 || statusCode == 409 || statusCode == 422) {
            emit(
              state.copyWith(
                isPolling: false,
                failure: failure,
                serverErrorCode: failure.code,
              ),
            );
            return;
          }
          // On transient network or 503, preserve code and continue backoff loop
          emit(
            state.copyWith(
              failure: failure,
              serverErrorCode: failure.code,
              pollAttemptCount: state.pollAttemptCount + 1,
            ),
          );
      }

      if (delay > Duration.zero) {
        await Future<void>.delayed(delay);
      }
    }

    if (!isClosed && _activePollGeneration == currentGen) {
      emit(state.copyWith(isPolling: false));
    }
  }

  void _resetFlow() {
    _activePollGeneration++;
    emit(const CampaignPaymentState());
  }

  @override
  Future<void> close() {
    _isCancelled = true;
    _activePollGeneration++;
    return super.close();
  }
}
