import 'package:meal_meat_user/features/subscription_settings/domain/usecase/resume_subscription_usecase.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_confirmation_usecase.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getSubscriptionPaymentStatusUseCase,
    this._getSubscriptionCalendarUseCase,
    this._sharedPrefHelper, {
    this._paymentAttemptStore,
    this._tokenService,
    this._getSubscriptionBillingUseCase,
    this._getSubscriptionConfirmationUseCase,
    this.resumeSubscriptionUseCase,
    this.pollingBackoffOverride,
  }) : super(const PaymentState());

  @factoryMethod
  factory PaymentViewModel.create(
    GetSubscriptionPaymentStatusUseCase getSubscriptionPaymentStatusUseCase,
    GetSubscriptionCalendarUseCase getSubscriptionCalendarUseCase,
    SharedPrefHelper sharedPrefHelper,
    PaymentAttemptStore paymentAttemptStore,
    TokenService tokenService,
    GetSubscriptionBillingUseCase getSubscriptionBillingUseCase,
    GetSubscriptionConfirmationUseCase getSubscriptionConfirmationUseCase,
    ResumeSubscriptionUseCase resumeSubscriptionUseCase,
  ) => PaymentViewModel(
    getSubscriptionPaymentStatusUseCase,
    getSubscriptionCalendarUseCase,
    sharedPrefHelper,
    paymentAttemptStore: paymentAttemptStore,
    tokenService: tokenService,
    getSubscriptionBillingUseCase: getSubscriptionBillingUseCase,
    getSubscriptionConfirmationUseCase: getSubscriptionConfirmationUseCase,
    resumeSubscriptionUseCase: resumeSubscriptionUseCase,
  );

  final ResumeSubscriptionUseCase? resumeSubscriptionUseCase;

  final Iterable<Duration> Function()? pollingBackoffOverride;

  final GetSubscriptionPaymentStatusUseCase
  _getSubscriptionPaymentStatusUseCase;
  final GetSubscriptionCalendarUseCase _getSubscriptionCalendarUseCase;
  final SharedPrefHelper _sharedPrefHelper;
  final PaymentAttemptStore? _paymentAttemptStore;
  final TokenService? _tokenService;
  final GetSubscriptionBillingUseCase? _getSubscriptionBillingUseCase;
  final GetSubscriptionConfirmationUseCase? _getSubscriptionConfirmationUseCase;

  bool _hasLaunchedPayment = false;
  int _fulfillmentGeneration = 0;

  void doIntent(PaymentEvent event) {
    switch (event) {
      case MarkPaymentLaunchedEvent():
        _hasLaunchedPayment = true;
      case RenewPaymentHoldEvent():
        unawaited(_renewHold());
      case InitCheckoutSessionEvent():
        unawaited(
          _initCheckoutSession(
            event.checkout,
            flowType: event.flowType,
            batchId: event.batchId,
            batchVersion: event.batchVersion,
          ),
        );
      case VerifyPaymentFulfillmentEvent():
        unawaited(_verifyFulfillment(event.subscriptionId));
      case MarkPaymentFailedEvent():
        final subId =
            state.checkout?.subscriptionId ?? state.pendingSubscriptionId;
        if (subId != null && subId.isNotEmpty) {
          unawaited(_verifyFulfillment(subId));
        } else {
          emit(
            state.copyWith(
              isPaymentFailed: true,
              isFulfillmentLoading: false,
              isCalendarLoading: false,
              isFulfillmentSuccess: false,
              isCalendarSuccess: false,
            ),
          );
        }
      case HandlePaymentReturnEvent():
        unawaited(_handlePaymentReturn(event.paymentReturn));
      case PollSubscriptionCalendarEvent():
        unawaited(_pollCalendar(event.subscriptionId));
    }
  }

  Future<void> _renewHold() async {
    final checkout = state.checkout;
    final resume = resumeSubscriptionUseCase;
    if (checkout == null ||
        checkout.subscriptionId.isEmpty ||
        (!state.isFamily && resume == null) ||
        state.isHoldRenewing ||
        state.isFulfillmentLoading ||
        state.isReviewRequired ||
        state.isPaidProcessing ||
        state.isPaymentPending ||
        state.isCalendarLoading ||
        state.isFulfillmentSuccess) {
      return;
    }
    if (state.isFamily && !_hasLaunchedPayment) return;
    emit(state.copyWith(isHoldRenewing: true, clearCheckoutFailure: true));
    if (_hasLaunchedPayment) {
      final verificationGeneration = _fulfillmentGeneration;
      final statusResult = await _getSubscriptionPaymentStatusUseCase(
        checkout.subscriptionId,
      );
      if (isClosed) return;
      if (verificationGeneration != _fulfillmentGeneration) {
        emit(state.copyWith(isHoldRenewing: false));
        return;
      }
      switch (statusResult) {
        case ApiErrorResult():
          emit(
            state.copyWith(
              isHoldRenewing: false,
              checkoutFailure: statusResult.failure,
            ),
          );
          return;
        case ApiSuccessResult():
          final status = statusResult.data;
          final normalized = status.paymentStatus.trim().toLowerCase();
          if (status.isPaid || normalized == 'paid') {
            emit(state.copyWith(isHoldRenewing: false));
            await _verifyFulfillment(checkout.subscriptionId);
            return;
          }
          final terminalFailure =
              status.isFailed ||
              normalized == 'paymentfailed' ||
              normalized == 'failed' ||
              normalized == 'expired' ||
              normalized == 'cancelled';
          if (!terminalFailure) {
            // Pending/unknown charges keep their original gateway and return callback alive.
            emit(state.copyWith(isHoldRenewing: false, paymentStatus: status));
            return;
          }
          _hasLaunchedPayment = false;
          if (state.isFamily) {
            emit(
              state.copyWith(
                isHoldRenewing: false,
                isPaymentFailed: true,
                paymentStatus: status,
              ),
            );
            return;
          }
      }
    }
    if (resume == null) {
      emit(state.copyWith(isHoldRenewing: false));
      return;
    }
    final result = await resume(subscriptionId: checkout.subscriptionId);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult():
        final renewed = result.data;
        if (renewed.holdExpiresAtUtc == null) {
          emit(
            state.copyWith(
              isHoldRenewing: false,
              checkoutFailure: Failure.fromException(
                const ApiException(
                  errorType: ApiErrorType.serverError,
                  message: '',
                ),
              ),
            ),
          );
          return;
        }
        final effectiveServerTime =
            renewed.serverTimeUtc ?? DateTime.now().toUtc();
        emit(
          state.copyWith(
            isHoldRenewing: false,
            checkout: PaymentCheckoutEntity(
              subscriptionId: renewed.subscriptionId.isEmpty
                  ? checkout.subscriptionId
                  : renewed.subscriptionId,
              paymentUrl: renewed.paymentUrl,
              holdExpiresAtUtc:
                  renewed.holdExpiresAtUtc?.toIso8601String() ?? '',
              serverTimeUtc: effectiveServerTime,
              chosenStartDate: checkout.chosenStartDate,
              startDate: checkout.startDate,
              finalPrice: renewed.finalPrice,
              priceSnapshotId: checkout.priceSnapshotId,
              restaurantPoolSnapshotId: checkout.restaurantPoolSnapshotId,
              paymentStatus: renewed.paymentStatus,
              paymentId: checkout.paymentId,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isHoldRenewing: false,
            checkoutFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _initCheckoutSession(
    PaymentCheckoutEntity checkout, {
    String flowType = 'individual',
    String? batchId,
    int? batchVersion,
  }) async {
    emit(
      state.copyWith(
        isSessionInitializing: true,
        isSessionReady: false,
        clearCheckoutFailure: true,
      ),
    );
    PaymentAttempt? attempt;
    try {
      final customerId = await _tokenService?.getCurrentUserId() ?? '';
      if (customerId.isNotEmpty) {
        final stored = await _paymentAttemptStore?.readForCustomer(customerId);
        final incomingPaymentId = checkout.paymentId ?? '';
        final matches =
            stored != null &&
            stored.flowType == flowType &&
            ((incomingPaymentId.isNotEmpty &&
                    stored.paymentId == incomingPaymentId) ||
                (incomingPaymentId.isEmpty &&
                    checkout.subscriptionId.isNotEmpty &&
                    stored.subscriptionId == checkout.subscriptionId));
        final previous = matches ? stored : null;
        final urlPaymentId = checkout.paymentUrl.isNotEmpty
            ? Uri.tryParse(checkout.paymentUrl)?.queryParameters['id'] ?? ''
            : '';
        final paymentId = incomingPaymentId.isNotEmpty
            ? incomingPaymentId
            : (urlPaymentId.isNotEmpty
                ? urlPaymentId
                : (previous?.paymentId.isNotEmpty == true
                    ? previous!.paymentId
                    : checkout.subscriptionId));
        if (paymentId.isNotEmpty &&
            (checkout.subscriptionId.isNotEmpty ||
                (batchId?.isNotEmpty ?? false))) {
          attempt = PaymentAttempt(
            ownerCustomerId: customerId,
            subscriptionId: checkout.subscriptionId,
            paymentId: paymentId,
            createdAtUtc: previous?.createdAtUtc ?? DateTime.now().toUtc(),
            reviewRequired: previous?.reviewRequired ?? false,
            lastPresentedFinalStatus: previous?.lastPresentedFinalStatus,
            flowType: flowType,
            batchId: batchId ?? previous?.batchId,
            batchVersion: batchVersion ?? previous?.batchVersion,
            idempotencyKey: previous?.idempotencyKey,
            state: flowType == 'family'
                ? 'redirected'
                : previous?.state ?? 'created',
          );
          await _paymentAttemptStore?.save(attempt);
        }
      }
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isSessionInitializing: false,
          isSessionReady: false,
          checkoutFailure: ServerFailure(
            code: 'checkout.attempt_persistence_failed',
            errorMessage:
                'Failed to prepare secure payment recovery record. Please verify your subscription status.',
            exception: const ApiException(
              message:
                  'Failed to prepare secure payment recovery record. Please verify your subscription status.',
              statusCode: 500,
              errorType: ApiErrorType.internalServerError,
            ),
          ),
        ),
      );
      return;
    }
    if (isClosed) return;
    final handle = checkout.paymentId?.isNotEmpty == true
        ? checkout.paymentId!
        : attempt?.paymentId ?? '';
    emit(
      state.copyWith(
        isSessionInitializing: false,
        isSessionReady: true,
        checkout: checkout,
        attemptHandle: handle.isNotEmpty ? handle : null,
        clearAttemptHandle: handle.isEmpty,
        isReviewRequired: attempt?.reviewRequired ?? false,
        flowType: flowType,
      ),
    );
    if (checkout.paymentUrl.isEmpty) {
      if (checkout.subscriptionId.isNotEmpty) {
        await _verifyFulfillment(checkout.subscriptionId);
      } else if (handle.isNotEmpty) {
        await _handlePaymentReturn(
          PaymentReturn(
            destination: PaymentReturnDestination.pending,
            paymentId: handle,
          ),
        );
      }
    }
  }

  Future<void> _handlePaymentReturn(PaymentReturn paymentReturn) async {
    emit(state.copyWith(attemptHandle: paymentReturn.paymentId));

    final customerId = await _tokenService?.getCurrentUserId() ?? '';
    PaymentAttempt? storedAttempt;
    if (customerId.isNotEmpty) {
      storedAttempt = await _paymentAttemptStore?.readForCustomer(customerId);
    }

    if (paymentReturn.destination == PaymentReturnDestination.review) {
      emit(
        state.copyWith(
          isReviewRequired: true,
          isFulfillmentLoading: false,
          isPaymentFailed: false,
          attemptHandle: paymentReturn.paymentId,
        ),
      );
      if (storedAttempt != null &&
          storedAttempt.paymentId == paymentReturn.paymentId &&
          storedAttempt.flowType == state.flowType) {
        await _paymentAttemptStore?.save(
          storedAttempt.copyWith(reviewRequired: true),
        );
      }
    }

    String? subId = state.checkout?.subscriptionId;
    if (subId == null || subId.isEmpty) {
      if (storedAttempt != null &&
          (storedAttempt.paymentId == paymentReturn.paymentId ||
              storedAttempt.paymentId.isEmpty)) {
        subId = storedAttempt.subscriptionId;
      }
    }

    if (subId == null || subId.isEmpty) {
      subId = state.pendingSubscriptionId;
    }

    if (subId != null && subId.isNotEmpty) {
      await _verifyFulfillment(subId);
    } else {
      await _recoverUnresolvedSubscription(paymentReturn);
    }
  }

  Future<void> _recoverUnresolvedSubscription(
    PaymentReturn paymentReturn,
  ) async {
    final customerId = await _tokenService?.getCurrentUserId() ?? '';
    final storedAttempt = customerId.isNotEmpty
        ? await _paymentAttemptStore?.readForCustomer(customerId)
        : null;

    if (storedAttempt?.isFamily == true || state.isFamily) {
      // Isolate family payments: individual subscription recovery must never be used as a silent family fallback.
      emit(
        state.copyWith(
          isFulfillmentLoading: false,
          isReviewRequired:
              paymentReturn.destination == PaymentReturnDestination.review,
          attemptHandle: paymentReturn.paymentId,
        ),
      );
      return;
    }

    final billingResult = await _getSubscriptionBillingUseCase?.call();
    if (billingResult is ApiSuccessResult<SubscriptionBillingEntity>) {
      final uncompleted = billingResult.data.uncompletedSubscriptions;
      if (uncompleted.length == 1) {
        await _verifyFulfillment(uncompleted.first.subscriptionId);
        return;
      }
      final currentSub = billingResult.data.current.subscription;
      if (currentSub != null && currentSub.subscriptionId.isNotEmpty) {
        await _verifyFulfillment(currentSub.subscriptionId);
        return;
      }
    }

    emit(
      state.copyWith(
        isFulfillmentLoading: false,
        isPaymentPending: true,
        attemptHandle: paymentReturn.paymentId,
      ),
    );
  }

  bool _matchesVerifiedAttempt(PaymentAttempt? attempt, String subscriptionId) {
    if (attempt == null ||
        attempt.subscriptionId != subscriptionId ||
        attempt.flowType != state.flowType) {
      return false;
    }
    final handle = state.attemptHandle;
    return handle == null || handle.isEmpty || attempt.paymentId == handle;
  }

  Future<void> _verifyFulfillment(String subscriptionId) async {
    if (subscriptionId.isEmpty) return;
    final currentGen = ++_fulfillmentGeneration;

    emit(
      state.copyWith(
        isFulfillmentLoading: true,
        isFulfillmentSuccess: false,
        isCalendarLoading: false,
        isCalendarSuccess: false,
        isPaymentFailed: false,
        isPaidProcessing: false,
        clearFulfillmentFailure: true,
        clearCalendarFailure: true,
      ),
    );

    PaymentStatusEntity? lastPaymentStatus;

    for (final delay in _pollingBackoff()) {
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }
      if (isClosed || currentGen != _fulfillmentGeneration) return;

      final result = await _getSubscriptionPaymentStatusUseCase(subscriptionId);
      if (isClosed || currentGen != _fulfillmentGeneration) return;

      switch (result) {
        case ApiSuccessResult():
          final status = result.data;
          lastPaymentStatus = status;

          final normalizedStatus = status.paymentStatus.trim().toLowerCase();

          if (normalizedStatus == 'suspendedforreview' ||
              normalizedStatus == 'reviewrequired' ||
              (state.isReviewRequired && !status.isPaid && !status.isFailed)) {
            final customerId = await _tokenService?.getCurrentUserId() ?? '';
            if (customerId.isNotEmpty) {
              final attempt = await _paymentAttemptStore?.readForCustomer(
                customerId,
              );
              if (_matchesVerifiedAttempt(attempt, subscriptionId)) {
                await _paymentAttemptStore?.save(
                  attempt!.copyWith(reviewRequired: true),
                );
              }
            }
            if (isClosed || currentGen != _fulfillmentGeneration) return;
            emit(
              state.copyWith(
                isFulfillmentLoading: false,
                isReviewRequired: true,
                isPaymentFailed: false,
                paymentStatus: status,
                clearFulfillmentFailure: true,
              ),
            );
            return;
          }

          if (normalizedStatus == 'paymentfailed' ||
              normalizedStatus == 'failed' ||
              normalizedStatus == 'expired' ||
              normalizedStatus == 'cancelled' ||
              normalizedStatus == 'refunded' ||
              normalizedStatus == 'partiallyrefunded' ||
              status.isFailed) {
            final customerId = await _tokenService?.getCurrentUserId() ?? '';
            if (customerId.isNotEmpty) {
              final attempt = await _paymentAttemptStore?.readForCustomer(
                customerId,
              );
              if (_matchesVerifiedAttempt(attempt, subscriptionId)) {
                await _paymentAttemptStore?.save(
                  attempt!.copyWith(
                    reviewRequired: false,
                    lastPresentedFinalStatus: normalizedStatus == 'expired'
                        ? 'expired'
                        : 'failed',
                  ),
                );
              }
            }
            if (isClosed || currentGen != _fulfillmentGeneration) return;
            emit(
              state.copyWith(
                isFulfillmentLoading: false,
                isFulfillmentSuccess: false,
                isPaymentFailed: true,
                isReviewRequired: false,
                paymentStatus: status,
                clearFulfillmentFailure: true,
              ),
            );
            return;
          }

          if (normalizedStatus == 'paid' || status.isPaid) {
            final isFulfillmentReady = status.isFulfillmentReady ?? false;
            SubscriptionConfirmationEntity? confirmation;
            if (_getSubscriptionConfirmationUseCase != null) {
              final confirmRes = await _getSubscriptionConfirmationUseCase(
                subscriptionId,
              );
              if (confirmRes
                  is ApiSuccessResult<SubscriptionConfirmationEntity>) {
                confirmation = confirmRes.data;
              }
            }
            if (state.isFamily) {
              if (isFulfillmentReady || status.isPaid) {
                final customerId =
                    await _tokenService?.getCurrentUserId() ?? '';
                if (customerId.isNotEmpty) {
                  final attempt = await _paymentAttemptStore?.readForCustomer(
                    customerId,
                  );
                  if (_matchesVerifiedAttempt(attempt, subscriptionId)) {
                    await _paymentAttemptStore?.save(
                      attempt!.copyWith(
                        reviewRequired: false,
                        lastPresentedFinalStatus: 'active',
                        state: 'active',
                      ),
                    );
                  }
                }
                FamilyConversionDraftSession.clearConvertedFamilyDraft();
                if (getIt.isRegistered<FamilyFlowSnapshotStore>()) {
                  getIt<FamilyFlowSnapshotStore>().invalidate();
                }
                await _sharedPrefHelper.saveData(
                  key: StorageKeys.currentSubscriptionId,
                  val: subscriptionId,
                );
                if (isClosed || currentGen != _fulfillmentGeneration) return;
                emit(
                  state.copyWith(
                    isFulfillmentLoading: false,
                    isFulfillmentSuccess: true,
                    isPaidProcessing: false,
                    isPaymentFailed: false,
                    isReviewRequired: false,
                    paymentStatus: status,
                    confirmation: confirmation ?? state.confirmation,
                    clearFulfillmentFailure: true,
                  ),
                );
                return;
              }
            } else {
              if (isFulfillmentReady || status.isPaid) {
                final customerId =
                    await _tokenService?.getCurrentUserId() ?? '';
                if (customerId.isNotEmpty) {
                  final attempt = await _paymentAttemptStore?.readForCustomer(
                    customerId,
                  );
                  if (_matchesVerifiedAttempt(attempt, subscriptionId)) {
                    await _paymentAttemptStore?.save(
                      attempt!.copyWith(
                        reviewRequired: false,
                        lastPresentedFinalStatus: 'active',
                      ),
                    );
                  }
                }
                await _sharedPrefHelper.saveData(
                  key: StorageKeys.currentSubscriptionId,
                  val: subscriptionId,
                );
                if (isClosed || currentGen != _fulfillmentGeneration) return;
                emit(
                  state.copyWith(
                    isFulfillmentLoading: false,
                    isFulfillmentSuccess: true,
                    isPaidProcessing: false,
                    isPaymentFailed: false,
                    isReviewRequired: false,
                    paymentStatus: status,
                    confirmation: confirmation ?? state.confirmation,
                    clearFulfillmentFailure: true,
                  ),
                );
                return;
              }
            }

            emit(
              state.copyWith(
                isFulfillmentLoading: true,
                isPaidProcessing: true,
                paymentStatus: status,
              ),
            );
            continue;
          }

          if (normalizedStatus == 'pendingpayment') {
            continue;
          }

          continue;

        case ApiErrorResult():
          if (isClosed || currentGen != _fulfillmentGeneration) return;
          if (_isRetryablePaymentFailure(result.failure)) {
            continue;
          }
          emit(
            state.copyWith(
              isFulfillmentLoading: false,
              fulfillmentFailure: result.failure,
            ),
          );
          return;
      }
    }

    if (isClosed || currentGen != _fulfillmentGeneration) return;
    emit(
      state.copyWith(
        isFulfillmentLoading: false,
        isPaymentPending: true,
        paymentStatus: lastPaymentStatus,
      ),
    );
  }

  int _calendarPollGeneration = 0;

  @override
  Future<void> close() {
    _calendarPollGeneration++;
    return super.close();
  }

  Future<void> _pollCalendar(String subscriptionId) async {
    if (subscriptionId.isEmpty) return;
    if (state.isCalendarLoading || state.isCalendarSuccess) return;

    final pollGeneration = ++_calendarPollGeneration;

    emit(
      state.copyWith(
        isCalendarLoading: true,
        isCalendarSuccess: false,
        clearCalendarFailure: true,
      ),
    );

    Failure? lastFailure;
    for (final delay in _pollingBackoff()) {
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }
      if (isClosed || pollGeneration != _calendarPollGeneration) return;

      final result = await _getSubscriptionCalendarUseCase(subscriptionId);
      if (isClosed || pollGeneration != _calendarPollGeneration) return;

      switch (result) {
        case ApiSuccessResult():
          final data = result.data;
          final isReady = (data is CalendarResponseDto)
              ? (data.isFulfillmentReady != false &&
                    data.days != null &&
                    data.days!.isNotEmpty)
              : true;
          if (!isReady) {
            continue;
          }
          await _sharedPrefHelper.saveData(
            key: StorageKeys.currentSubscriptionId,
            val: subscriptionId,
          );
          if (isClosed || pollGeneration != _calendarPollGeneration) return;
          emit(
            state.copyWith(
              isCalendarLoading: false,
              isCalendarSuccess: true,
              clearCalendarFailure: true,
            ),
          );
          return;
        case ApiErrorResult():
          lastFailure = result.failure;
          if (!_isCalendarFulfillmentNotReady(result.failure) &&
              !_isRetryableCalendarFailure(result.failure)) {
            if (isClosed || pollGeneration != _calendarPollGeneration) return;
            emit(
              state.copyWith(
                isCalendarLoading: false,
                calendarFailure: result.failure,
              ),
            );
            return;
          }
          continue;
      }
    }

    if (isClosed || pollGeneration != _calendarPollGeneration) return;
    emit(
      state.copyWith(
        isCalendarLoading: false,
        calendarFailure:
            lastFailure ??
            Failure(
              code: 'calendar.fulfillment_not_ready',
              errorMessage: 'Subscription calendar is being prepared',
              exception: const ApiException(
                errorType: ApiErrorType.conflict,
                backendErrorCode: 'calendar.fulfillment_not_ready',
                message: 'Subscription calendar is being prepared',
              ),
            ),
      ),
    );
  }

  Iterable<Duration> _pollingBackoff() sync* {
    if (pollingBackoffOverride != null) {
      yield* pollingBackoffOverride!();
      return;
    }
    yield Duration.zero;
    yield const Duration(seconds: 2);
    yield const Duration(seconds: 4);
    yield const Duration(seconds: 8);
  }

  bool _isCalendarFulfillmentNotReady(Failure failure) {
    return failure.code == 'calendar.fulfillment_not_ready' ||
        failure.exception.backendErrorCode == 'calendar.fulfillment_not_ready';
  }

  bool _isRetryableCalendarFailure(Failure failure) {
    final type = failure.exception.errorType;
    return type == ApiErrorType.conflict ||
        type == ApiErrorType.serverError ||
        type == ApiErrorType.internalServerError ||
        type == ApiErrorType.badGateway ||
        type == ApiErrorType.serviceUnavailable ||
        type == ApiErrorType.gatewayTimeout ||
        type == ApiErrorType.connectionTimeout ||
        type == ApiErrorType.receiveTimeout ||
        type == ApiErrorType.sendTimeout ||
        type == ApiErrorType.requestTimeout;
  }

  bool _isRetryablePaymentFailure(Failure failure) {
    final type = failure.exception.errorType;
    return type == ApiErrorType.connectionTimeout ||
        type == ApiErrorType.sendTimeout ||
        type == ApiErrorType.receiveTimeout ||
        type == ApiErrorType.serverError ||
        type == ApiErrorType.internalServerError ||
        type == ApiErrorType.badGateway ||
        type == ApiErrorType.serviceUnavailable ||
        type == ApiErrorType.gatewayTimeout ||
        type == ApiErrorType.noInternetConnection ||
        type == ApiErrorType.unknown;
  }
}
