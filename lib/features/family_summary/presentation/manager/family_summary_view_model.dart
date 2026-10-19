import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/save_family_member_start_date_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/checkout_family_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/get_family_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/get_family_summary_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/select_family_member_summary_usecase.dart';
import 'package:meal_meat_user/features/family_summary/domain/usecase/retry_family_subscription_payment_usecase.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';

@injectable
class FamilySummaryViewModel extends Cubit<FamilySummaryState> {
  FamilySummaryViewModel(
    this._getFamilyFlowCurrentUseCase,
    this._getFamilySummaryUseCase,
    this._getFamilyPaymentMethodsUseCase,
    this._checkoutFamilySubscriptionUseCase,
    this._selectFamilyMemberSummaryUseCase,
    this._saveFamilyMemberStartDateUseCase, [
    this._retryFamilySubscriptionPaymentUseCase,
  ]) : super(const FamilySummaryState());

  final GetFamilyFlowCurrentUseCase _getFamilyFlowCurrentUseCase;
  final GetFamilySummaryUseCase _getFamilySummaryUseCase;
  final GetFamilyPaymentMethodsUseCase _getFamilyPaymentMethodsUseCase;
  final CheckoutFamilySubscriptionUseCase _checkoutFamilySubscriptionUseCase;
  final SelectFamilyMemberSummaryUseCase _selectFamilyMemberSummaryUseCase;
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
  int _memberSelectionRequestId = 0;
  int _startDateRequestId = 0;
  int _couponRequestId = 0;

  void _invalidateQuoteAndIdempotency() {
    _lastIdempotencyKey = null;
    _lastIntentSignature = null;
  }

  String _getOrCreateIdempotencyKey({
    required String? batchId,
    required int? batchVersion,
    required double amount,
    required int? paymentMethodId,
    String? promoCode,
  }) {
    final intentSignature =
        '$batchId-$batchVersion-$amount-$paymentMethodId-$promoCode';
    if (_lastIdempotencyKey != null &&
        _lastIntentSignature == intentSignature) {
      return _lastIdempotencyKey!;
    }
    _lastIntentSignature = intentSignature;
    _lastIdempotencyKey = 'fam-idemp-${DateTime.now().microsecondsSinceEpoch}';
    return _lastIdempotencyKey!;
  }

  void doIntent(FamilySummaryEvent event) {
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
      case ApplyFamilyCouponEvent():
        unawaited(_applyCoupon(event.promoCode));
      case RemoveFamilyCouponEvent():
        unawaited(_removeCoupon());
    }
  }

  Future<void> _applyCoupon(String promoCode) async {
    final trimmed = promoCode.trim().toUpperCase();
    if (trimmed.isEmpty) return;
    _invalidateQuoteAndIdempotency();
    final reqId = ++_couponRequestId;
    emit(state.copyWith(isCouponLoading: true, clearFailure: true));
    await _getFamilySummary(
      memberId: state.selectedSummaryMemberId,
      promoCode: trimmed,
    );
    if (isClosed || reqId != _couponRequestId) return;
    if (state.failure == null &&
        (state.summary?.coupon == null ||
            state.summary?.coupon?.isValid == true)) {
      emit(state.copyWith(isCouponLoading: false, appliedPromoCode: trimmed));
    } else {
      emit(state.copyWith(isCouponLoading: false, clearAppliedPromoCode: true));
    }
  }

  Future<void> _removeCoupon() async {
    _invalidateQuoteAndIdempotency();
    final reqId = ++_couponRequestId;
    emit(
      state.copyWith(
        isCouponLoading: true,
        clearAppliedPromoCode: true,
        clearFailure: true,
      ),
    );
    await _getFamilySummary(
      memberId: state.selectedSummaryMemberId,
      promoCode: null,
      explicitClearCoupon: true,
    );
    if (isClosed || reqId != _couponRequestId) return;
    emit(state.copyWith(isCouponLoading: false));
  }

  Future<void> _retryFamilyPayment(
    RetryFamilySubscriptionPaymentEvent event,
  ) async {
    if (state.isCheckoutLoading || state.isRetryLoading) return;
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
      promoCode: state.appliedPromoCode,
    );
    emit(
      state.copyWith(
        isRetryLoading: true,
        clearFailure: true,
        clearCheckoutResult: true,
      ),
    );
    final result = await retryUseCase(
      callbackUrl: event.callbackUrl,
      errorUrl: event.errorUrl,
      correlationId: event.correlationId,
      paymentMethodId: event.paymentMethodId,
      batchId: batchId,
      batchVersion: batchVersion,
      idempotencyKey: key,
      promoCode: state.appliedPromoCode,
    );
    if (isClosed) return;
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
    if (state.isStartDateSaving) return;
    _invalidateQuoteAndIdempotency();
    final reqId = ++_startDateRequestId;
    final previousFlow = state.currentFlow;
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
        isStartDateSaving: true,
        clearSelectedPaymentMethod: true,
        clearFailure: true,
      ),
    );

    final result = await _saveFamilyMemberStartDateUseCase(
      memberId: memberId,
      startDate: startDate,
    );
    if (isClosed || reqId != _startDateRequestId) return;
    switch (result) {
      case ApiSuccessResult():
        final summaryReqId = ++_summaryRequestId;
        final summaryResult = await _getFamilySummaryUseCase(
          memberId: memberId,
          promoCode: state.appliedPromoCode,
        );
        if (isClosed ||
            reqId != _startDateRequestId ||
            summaryReqId != _summaryRequestId) {
          return;
        }
        switch (summaryResult) {
          case ApiSuccessResult():
            emit(
              state.copyWith(
                isStartDateSaving: false,
                summary: summaryResult.data,
                selectedSummaryMemberId: memberId,
              ),
            );
          case ApiErrorResult():
            emit(
              state.copyWith(
                isStartDateSaving: false,
                failure: summaryResult.failure,
              ),
            );
        }
      case ApiErrorResult():
        emit(
          state.copyWith(
            currentFlow: previousFlow,
            isStartDateSaving: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _selectMemberForCheckout(
    String memberId,
    bool subscribeNow,
  ) async {
    _invalidateQuoteAndIdempotency();
    final reqId = ++_memberSelectionRequestId;
    emit(
      state.copyWith(
        isSummaryLoading: true,
        clearFailure: true,
        paymentMethods: const [],
        clearSelectedPaymentMethod: true,
      ),
    );
    final result = await _selectFamilyMemberSummaryUseCase(
      memberId: memberId,
      subscribeNow: subscribeNow,
    );
    if (isClosed || reqId != _memberSelectionRequestId) return;
    switch (result) {
      case ApiSuccessResult():
        await _getFamilySubscriptionCurrent();
        if (isClosed || reqId != _memberSelectionRequestId) return;
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

  Future<void> _getFamilySummary({
    String? memberId,
    String? promoCode,
    bool explicitClearCoupon = false,
  }) async {
    final reqId = ++_summaryRequestId;
    final effectivePromo = explicitClearCoupon
        ? null
        : (promoCode ?? state.appliedPromoCode);
    emit(
      state.copyWith(
        isSummaryLoading: true,
        selectedSummaryMemberId: memberId ?? state.selectedSummaryMemberId,
        clearFailure: true,
      ),
    );
    final result = await _getFamilySummaryUseCase(
      memberId: memberId,
      promoCode: effectivePromo,
    );
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
    if (state.isCheckoutLoading || state.isRetryLoading) return;
    final summary = state.summary;
    if (summary == null || !summary.canCheckout) {
      return;
    }
    final key = _getOrCreateIdempotencyKey(
      batchId: summary.batchId,
      batchVersion: summary.batchVersion,
      amount: summary.finalPrice,
      paymentMethodId: paymentMethodId,
      promoCode: state.appliedPromoCode,
    );
    emit(
      state.copyWith(
        isCheckoutLoading: true,
        clearFailure: true,
        clearCheckoutResult: true,
      ),
    );
    final result = await _checkoutFamilySubscriptionUseCase(
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      correlationId: correlationId,
      paymentMethodId: paymentMethodId,
      batchId: summary.batchId,
      batchVersion: summary.batchVersion,
      idempotencyKey: key,
      promoCode: state.appliedPromoCode,
      clientContractVersion:
          FamilyCheckoutContractConstants.clientContractVersion,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(isCheckoutLoading: false, checkoutResult: result.data),
        );
      case ApiErrorResult():
        emit(state.copyWith(isCheckoutLoading: false, failure: result.failure));
        // A batch review or pending checkout is authoritative on the server.
        // Refresh current state only; never submit checkout again automatically.
        if (result.failure.code ==
                SubscriptionErrorCodes.familyBatchReviewRequired ||
            result.failure.code ==
                SubscriptionErrorCodes.familyCheckoutPending ||
            result.failure.code == SubscriptionErrorCodes.familyBatchClosed) {
          await _refreshAfterPaymentAttempt();
        }
        if (result.failure.code ==
                SubscriptionErrorCodes.paymentInitializationFailed ||
            result.failure.code == SubscriptionErrorCodes.familyQuoteChanged ||
            result.failure.code ==
                SubscriptionErrorCodes.familyDeliveryVersionChanged ||
            result.failure.code ==
                SubscriptionErrorCodes.familyPermissionsChanged ||
            result.failure.code ==
                SubscriptionErrorCodes.familyIdempotencyKeyUsed) {
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

typedef FamilyCheckoutViewModel = FamilySummaryViewModel;
