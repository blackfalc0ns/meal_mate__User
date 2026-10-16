import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/save_family_member_start_date_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/select_family_member_checkout_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/domain/usecase/retry_family_subscription_payment_usecase.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilyCheckoutViewModel extends Cubit<FamilyCheckoutState> {
  FamilyCheckoutViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._getFamilySummaryUseCase,
    this._getFamilyPaymentMethodsUseCase,
    this._checkoutFamilySubscriptionUseCase,
    this._selectFamilyMemberCheckoutUseCase,
    this._saveFamilyMemberStartDateUseCase, [
    this._retryFamilySubscriptionPaymentUseCase,
  ]) : super(const FamilyCheckoutState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilySummaryUseCase _getFamilySummaryUseCase;
  final GetFamilyPaymentMethodsUseCase _getFamilyPaymentMethodsUseCase;
  final CheckoutFamilySubscriptionUseCase _checkoutFamilySubscriptionUseCase;
  final SelectFamilyMemberCheckoutUseCase _selectFamilyMemberCheckoutUseCase;
  final SaveFamilyMemberStartDateUseCase _saveFamilyMemberStartDateUseCase;
  final RetryFamilySubscriptionPaymentUseCase?
  _retryFamilySubscriptionPaymentUseCase;
  final String correlationId =
      'family-pay-${DateTime.now().microsecondsSinceEpoch}';

  String? _lastIdempotencyKey;
  String? _lastIntentSignature;
  int _summaryRequestId = 0;
  int _paymentMethodsRequestId = 0;
  int _currentFlowRequestId = 0;

  void _invalidateQuoteAndIdempotency() {
    _lastIdempotencyKey = null;
    _lastIntentSignature = null;
  }

  String _getOrCreateIdempotencyKey({
    required String? batchId,
    required int? batchVersion,
    required double amount,
    required int paymentMethodId,
  }) {
    final intentSignature = '$batchId-$batchVersion-$amount-$paymentMethodId';
    if (_lastIdempotencyKey != null &&
        _lastIntentSignature == intentSignature) {
      return _lastIdempotencyKey!;
    }
    _lastIntentSignature = intentSignature;
    _lastIdempotencyKey = 'fam-idemp-${DateTime.now().microsecondsSinceEpoch}';
    return _lastIdempotencyKey!;
  }

  void doIntent(FamilyCheckoutEvent event) {
    switch (event) {
      case GetFamilySubscriptionCurrentEvent():
        unawaited(_getFamilySubscriptionCurrent());
      case GetFamilySummaryEvent():
        unawaited(_getFamilySummary(memberId: event.memberId));
      case SelectFamilyMemberCheckoutEvent():
        unawaited(_selectMemberForCheckout(event.memberId, event.subscribeNow));
      case SelectFamilyPaymentMethodEvent():
        emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
      case CheckoutFamilySubscriptionEvent():
        unawaited(
          _checkoutFamilySubscription(
            callbackUrl: event.callbackUrl,
            errorUrl: event.errorUrl,
            correlationId: event.correlationId,
            paymentMethodId: event.paymentMethodId,
          ),
        );
      case RetryFamilySubscriptionPaymentEvent():
        unawaited(_retryFamilyPayment(event));
      case UpdateMemberStartDateEvent():
        unawaited(_updateMemberStartDate(event.memberId, event.startDate));
    }
  }

  Future<void> _retryFamilyPayment(
    RetryFamilySubscriptionPaymentEvent event,
  ) async {
    if (state.isCheckoutLoading) return;
    final summary = state.summary;
    final retryUseCase = _retryFamilySubscriptionPaymentUseCase;
    if (retryUseCase == null) return;
    final batchId = summary?.batchId;
    final batchVersion = summary?.batchVersion;
    if (batchId == null || batchVersion == null) return;
    final key = _getOrCreateIdempotencyKey(
      batchId: batchId,
      batchVersion: batchVersion,
      amount: summary?.finalPrice ?? 0,
      paymentMethodId: event.paymentMethodId,
    );
    emit(state.copyWith(isRetryLoading: true, clearFailure: true));
    final result = await retryUseCase(
      callbackUrl: event.callbackUrl,
      errorUrl: event.errorUrl,
      correlationId: event.correlationId,
      paymentMethodId: event.paymentMethodId,
      batchId: batchId,
      batchVersion: batchVersion,
      idempotencyKey: key,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isRetryLoading: false, checkoutResult: result.data),
        );
        await _refreshAfterPaymentAttempt();
      case ApiErrorResult():
        emit(state.copyWith(isRetryLoading: false, failure: result.failure));
        await _refreshAfterPaymentAttempt();
    }
  }

  Future<void> _updateMemberStartDate(String memberId, String startDate) async {
    _invalidateQuoteAndIdempotency();
    final updatedMembers = state.members.map((m) {
      if (m.memberId == memberId) {
        return m.copyWith(startDate: startDate);
      }
      return m;
    }).toList();
    final updatedFlow = state.currentFlow?.copyWith(members: updatedMembers);

    emit(
      state.copyWith(
        currentFlow: updatedFlow,
        isSummaryLoading: true,
        clearFailure: true,
      ),
    );

    final result = await _saveFamilyMemberStartDateUseCase(
      memberId: memberId,
      startDate: startDate,
    );
    switch (result) {
      case ApiSuccessResult():
        await _getFamilySummary(memberId: memberId);
      case ApiErrorResult():
        emit(state.copyWith(isSummaryLoading: false, failure: result.failure));
    }
  }

  Future<void> _selectMemberForCheckout(
    String memberId,
    bool subscribeNow,
  ) async {
    _invalidateQuoteAndIdempotency();
    emit(
      state.copyWith(
        isSummaryLoading: true,
        clearFailure: true,
        paymentMethods: const [],
        clearSelectedPaymentMethod: true,
      ),
    );
    final result = await _selectFamilyMemberCheckoutUseCase(
      memberId: memberId,
      subscribeNow: subscribeNow,
    );
    switch (result) {
      case ApiSuccessResult():
        await _getFamilySubscriptionCurrent();
        await _getFamilySummary(memberId: memberId);
      case ApiErrorResult():
        emit(state.copyWith(isSummaryLoading: false, failure: result.failure));
    }
  }

  Future<void> _getFamilySubscriptionCurrent() async {
    final reqId = ++_currentFlowRequestId;
    emit(state.copyWith(isCurrentFlowLoading: true, clearFailure: true));
    final result = await _getFamilyFlowCurrentUseCase();
    if (isClosed || reqId != _currentFlowRequestId) return;
    switch (result) {
      case ApiSuccessResult():
        if (result.data.status == 3) {
          FamilyConversionDraftSession.clearConvertedFamilyDraft();
        } else if (result.data.managerPrepaid) {
          FamilyConversionDraftSession.markConvertedFamilyDraft();
        } else {
          FamilyConversionDraftSession.clearConvertedFamilyDraft();
        }
        emit(
          state.copyWith(isCurrentFlowLoading: false, currentFlow: result.data),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isCurrentFlowLoading: false, failure: result.failure),
        );
    }
  }

  Future<void> _getFamilySummary({String? memberId}) async {
    final reqId = ++_summaryRequestId;
    emit(
      state.copyWith(
        isSummaryLoading: true,
        selectedSummaryMemberId: memberId ?? state.selectedSummaryMemberId,
        clearFailure: true,
      ),
    );
    final result = await _getFamilySummaryUseCase(memberId: memberId);
    if (isClosed || reqId != _summaryRequestId) return;
    switch (result) {
      case ApiSuccessResult():
        final summary = result.data;
        if (summary.managerPrepaid) {
          FamilyConversionDraftSession.markConvertedFamilyDraft();
        }
        final activeMemberId =
            memberId ??
            summary.selectedMemberId ??
            summary.selectedMember?.memberId ??
            state.selectedSummaryMemberId;
        emit(
          state.copyWith(
            isSummaryLoading: false,
            summary: summary,
            selectedSummaryMemberId: activeMemberId,
            paymentMethods: summary.canCheckout && summary.finalPrice > 0
                ? state.paymentMethods
                : const [],
            clearSelectedPaymentMethod:
                !summary.canCheckout || summary.finalPrice <= 0,
          ),
        );
        if (summary.canCheckout && summary.finalPrice > 0) {
          _getFamilyPaymentMethods();
        }
      case ApiErrorResult():
        emit(state.copyWith(isSummaryLoading: false, failure: result.failure));
    }
  }

  Future<void> _getFamilyPaymentMethods() async {
    final reqId = ++_paymentMethodsRequestId;
    final amount = state.summary?.finalPrice ?? 0.0;
    emit(state.copyWith(isPaymentMethodsLoading: true));
    final result = await _getFamilyPaymentMethodsUseCase(amount);
    if (isClosed || reqId != _paymentMethodsRequestId) return;
    switch (result) {
      case ApiSuccessResult():
        final selectedId = state.selectedPaymentMethod?.id;
        emit(
          state.copyWith(
            isPaymentMethodsLoading: false,
            paymentMethods: result.data,
            clearSelectedPaymentMethod: result.data.isEmpty,
            selectedPaymentMethod:
                result.data
                    .where((method) => method.id == selectedId)
                    .firstOrNull ??
                result.data.firstOrNull,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isPaymentMethodsLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _checkoutFamilySubscription({
    required String callbackUrl,
    required String errorUrl,
    required String correlationId,
    required int paymentMethodId,
  }) async {
    if (state.isCheckoutLoading) return;
    final summary = state.summary;
    if (summary != null && !summary.canCheckout) {
      return;
    }
    final key = _getOrCreateIdempotencyKey(
      batchId: summary?.batchId,
      batchVersion: summary?.batchVersion,
      amount: summary?.finalPrice ?? 0.0,
      paymentMethodId: paymentMethodId,
    );
    emit(state.copyWith(isCheckoutLoading: true, clearFailure: true));
    final result = await _checkoutFamilySubscriptionUseCase(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      correlationId: correlationId,
      paymentMethodId: paymentMethodId,
      batchId: summary?.batchId,
      batchVersion: summary?.batchVersion,
      idempotencyKey: key,
      clientContractVersion: 1,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCheckoutLoading: false, checkoutResult: result.data),
        );
      case ApiErrorResult():
        emit(state.copyWith(isCheckoutLoading: false, failure: result.failure));
        // A batch review or pending checkout is authoritative on the server.
        // Refresh current state only; never submit checkout again automatically.
        if (result.failure.code == 'family.batch_review_required' ||
            result.failure.code == 'family.checkout_pending' ||
            result.failure.code == 'family.batch_closed') {
          await _refreshAfterPaymentAttempt();
        }
        if (result.failure.code == 'payment.initialization_failed' ||
            result.failure.code == 'family.quote_changed' ||
            result.failure.code == 'family.delivery_version_changed' ||
            result.failure.code == 'family.permissions_changed' ||
            result.failure.code == 'family.idempotency_key_used') {
          _invalidateQuoteAndIdempotency();
          _getFamilySummary(memberId: state.selectedSummaryMemberId);
        }
    }
  }

  Future<void> _refreshAfterPaymentAttempt() async {
    await Future.wait([
      _getFamilySubscriptionCurrent(),
      _getFamilySummary(memberId: state.selectedSummaryMemberId),
    ]);
  }
}
