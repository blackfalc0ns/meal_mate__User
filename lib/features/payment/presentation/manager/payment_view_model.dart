import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';

class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getPaymentMethodsUseCase,
    this._checkoutSubscriptionUseCase,
    this._getSubscriptionPaymentStatusUseCase,
    this._getSubscriptionCalendarUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
    this._sharedPrefHelper, {
    this._paymentAttemptStore,
    this._tokenService,
    this._getSubscriptionBillingUseCase,
    this.pollingBackoffOverride,
  }) : super(const PaymentState());

  final Iterable<Duration> Function()? pollingBackoffOverride;

  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CheckoutSubscriptionUseCase _checkoutSubscriptionUseCase;
  final GetSubscriptionPaymentStatusUseCase
  _getSubscriptionPaymentStatusUseCase;
  final GetSubscriptionCalendarUseCase _getSubscriptionCalendarUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper _sharedPrefHelper;
  final PaymentAttemptStore? _paymentAttemptStore;
  final TokenService? _tokenService;
  final GetSubscriptionBillingUseCase? _getSubscriptionBillingUseCase;

  int _methodsLoadGeneration = 0;
  int _fulfillmentGeneration = 0;

  void doIntent(PaymentEvent event) {
    switch (event) {
      case LoadPaymentEvent():
        unawaited(_load(event.args));
      case SelectPaymentMethodEvent():
        if (event.method.isAvailable &&
            event.method.id != null &&
            event.method.id! > 0) {
          emit(state.copyWith(selectedMethod: event.method));
        }
      case CheckoutPaymentEvent():
        unawaited(_checkout(event.args));
      case InitCheckoutSessionEvent():
        unawaited(_initCheckoutSession(event.checkout));
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

  Future<void> _initCheckoutSession(PaymentCheckoutEntity checkout) async {
    final customerId = await _tokenService?.getCurrentUserId() ?? '';
    PaymentAttempt? attempt;
    if (customerId.isNotEmpty) {
      attempt = await _paymentAttemptStore?.readForCustomer(customerId);
    }
    final isReview = attempt?.reviewRequired ?? false;
    final handle = (checkout.paymentId?.isNotEmpty == true)
        ? checkout.paymentId!
        : (attempt?.paymentId ?? '');

    emit(
      state.copyWith(
        checkout: checkout,
        attemptHandle: handle.isNotEmpty ? handle : null,
        isReviewRequired: isReview,
      ),
    );
  }

  Future<void> _load(PaymentArgs args) async {
    final currentGen = ++_methodsLoadGeneration;
    emit(
      state.copyWith(
        isMethodsLoading: true,
        methods: const [],
        clearSelectedMethod: true,
        clearMethodsFailure: true,
        clearCheckoutFailure: true,
        clearFulfillmentFailure: true,
        clearCalendarFailure: true,
        clearCheckout: true,
        clearPendingSubscriptionId: true,
      ),
    );

    final methodsResult = await _getPaymentMethodsUseCase(
      amount: args.summary.finalPrice,
    );

    if (isClosed || currentGen != _methodsLoadGeneration) return;

    switch (methodsResult) {
      case ApiSuccessResult():
        final methods = methodsResult.data;
        if (isClosed || currentGen != _methodsLoadGeneration) return;
        PaymentMethodEntity? defaultMethod;
        for (final m in methods) {
          if (m.isAvailable && m.id != null && m.id! > 0) {
            defaultMethod = m;
            break;
          }
        }
        emit(
          state.copyWith(
            isMethodsLoading: false,
            methods: methods,
            selectedMethod: defaultMethod,
            clearMethodsFailure: true,
          ),
        );
      case ApiErrorResult():
        if (isClosed || currentGen != _methodsLoadGeneration) return;
        emit(
          state.copyWith(
            isMethodsLoading: false,
            methods: const [],
            clearSelectedMethod: true,
            methodsFailure: methodsResult.failure,
          ),
        );
    }
  }

  Future<void> _checkout(PaymentArgs args) async {
    if (state.isCheckoutLoading ||
        state.isFulfillmentLoading ||
        state.isReviewRequired) {
      return;
    }
    if (!args.summary.canCheckout) {
      return;
    }
    final selectedMethod = state.selectedMethod;
    if (selectedMethod == null ||
        !selectedMethod.isAvailable ||
        selectedMethod.id == null ||
        selectedMethod.id! <= 0) {
      return;
    }

    if (args.summary.finalPrice <= 0) {
      emit(
        state.copyWith(
          isCheckoutLoading: false,
          checkoutFailure: ServerFailure(
            code: SubscriptionErrorCodes.couponFullDiscountUnsupported,
            errorMessage:
                'Zero-amount checkout is currently unsupported. Remove this code or use another code.',
            exception: const ApiException(
              message:
                  'Zero-amount checkout is currently unsupported. Remove this code or use another code.',
              statusCode: 400,
              errorType: ApiErrorType.badRequest,
              backendErrorCode:
                  SubscriptionErrorCodes.couponFullDiscountUnsupported,
            ),
          ),
        ),
      );
      return;
    }

    final request = PaymentCheckoutRequestEntity(
      programId: args.summaryRequest.programId,
      bundleId: args.summaryRequest.bundleId,
      tier: args.summaryRequest.tier,
      durationDays: args.summaryRequest.durationDays,
      startDate: args.summaryRequest.startDate,
      callbackUrl: 'mealmate://checkout/success',
      errorUrl: 'mealmate://checkout/error',
      includeFriday: args.summaryRequest.includeFriday,
      paymentMethodId: selectedMethod.id!,
      correlationId: _generateCorrelationId(),
      promoCode: args.summaryRequest.promoCode,
    );

    emit(
      state.copyWith(
        isCheckoutLoading: true,
        clearCheckout: true,
        clearCheckoutFailure: true,
        clearFulfillmentFailure: true,
        clearCalendarFailure: true,
        clearPendingSubscriptionId: true,
      ),
    );

    final result = await _checkoutSubscriptionUseCase(request);

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final checkout = result.data;
        final customerId = await _tokenService?.getCurrentUserId() ?? '';
        if (customerId.isNotEmpty) {
          final attempt = PaymentAttempt(
            schemaVersion: 1,
            ownerCustomerId: customerId,
            subscriptionId: checkout.subscriptionId,
            paymentId: checkout.paymentId ?? '',
            createdAtUtc: DateTime.now().toUtc(),
            reviewRequired: false,
          );
          try {
            await _paymentAttemptStore?.save(attempt);
          } catch (_) {
            if (isClosed) return;
            emit(
              state.copyWith(
                isCheckoutLoading: false,
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
        }

        emit(
          state.copyWith(
            isCheckoutLoading: false,
            checkout: checkout,
            attemptHandle: (checkout.paymentId?.isNotEmpty == true)
                ? checkout.paymentId
                : null,
            clearCheckoutFailure: true,
          ),
        );
        if (checkout.paymentUrl.isEmpty && checkout.subscriptionId.isNotEmpty) {
          await _verifyFulfillment(checkout.subscriptionId);
        }
      case ApiErrorResult():
        final pendingSubscriptionId = _pendingSubscriptionIdFromFailure(
          result.failure,
        );
        if (pendingSubscriptionId != null && pendingSubscriptionId.isNotEmpty) {
          emit(
            state.copyWith(
              isCheckoutLoading: false,
              pendingSubscriptionId: pendingSubscriptionId,
              clearCheckoutFailure: true,
            ),
          );
          await _verifyFulfillment(pendingSubscriptionId);
          return;
        }

        emit(
          state.copyWith(
            isCheckoutLoading: false,
            checkoutFailure: result.failure,
          ),
        );
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
      if (storedAttempt != null) {
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
              (state.isReviewRequired && !status.isPaid && !status.isFailed)) {
            final customerId = await _tokenService?.getCurrentUserId() ?? '';
            if (customerId.isNotEmpty) {
              final attempt = await _paymentAttemptStore?.readForCustomer(
                customerId,
              );
              if (attempt != null) {
                await _paymentAttemptStore?.save(
                  attempt.copyWith(reviewRequired: true),
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

          if (normalizedStatus == 'paymentfailed' || status.isFailed) {
            final customerId = await _tokenService?.getCurrentUserId() ?? '';
            if (customerId.isNotEmpty) {
              final attempt = await _paymentAttemptStore?.readForCustomer(
                customerId,
              );
              if (attempt != null) {
                await _paymentAttemptStore?.save(
                  attempt.copyWith(
                    reviewRequired: false,
                    lastPresentedFinalStatus: 'failed',
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
            final subResult = await _getCurrentCustomerSubscriptionUseCase();
            if (isClosed || currentGen != _fulfillmentGeneration) return;

            if (subResult
                is ApiSuccessResult<SubscriptionBillingCurrentEntity>) {
              final currentSub = subResult.data.subscription;
              final subStatus = currentSub?.status.trim().toLowerCase() ?? '';
              if (currentSub != null &&
                  (subStatus == 'active' || subStatus == 'scheduled')) {
                final customerId =
                    await _tokenService?.getCurrentUserId() ?? '';
                if (customerId.isNotEmpty) {
                  final attempt = await _paymentAttemptStore?.readForCustomer(
                    customerId,
                  );
                  if (attempt != null) {
                    await _paymentAttemptStore?.save(
                      attempt.copyWith(
                        reviewRequired: false,
                        lastPresentedFinalStatus: 'active',
                      ),
                    );
                  }
                }
                await _syncCurrentSubscriptionCache();
                if (isClosed || currentGen != _fulfillmentGeneration) return;
                emit(
                  state.copyWith(
                    isFulfillmentLoading: false,
                    isFulfillmentSuccess: true,
                    isPaidProcessing: false,
                    isPaymentFailed: false,
                    isReviewRequired: false,
                    paymentStatus: status,
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

  Future<void> _syncCurrentSubscriptionCache() async {
    final result = await _getCurrentCustomerSubscriptionUseCase();
    switch (result) {
      case ApiSuccessResult():
        final subscriptionId = result.data.subscription?.subscriptionId ?? '';
        if (subscriptionId.isEmpty) {
          await _sharedPrefHelper.removeData(
            key: StorageKeys.currentSubscriptionId,
          );
          return;
        }
        await _sharedPrefHelper.saveData(
          key: StorageKeys.currentSubscriptionId,
          val: subscriptionId,
        );
      case ApiErrorResult():
        await _sharedPrefHelper.removeData(
          key: StorageKeys.currentSubscriptionId,
        );
    }
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

  String? _pendingSubscriptionIdFromFailure(Failure failure) {
    if (failure.code != SubscriptionErrorCodes.existingSubscription) {
      return null;
    }
    final response = failure.exception.response;
    if (response is Map) {
      final value = response['subscriptionId'];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  String _generateCorrelationId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String hex(int value) => value.toRadixString(16).padLeft(2, '0');
    final chars = bytes.map(hex).join();

    return '${chars.substring(0, 8)}-'
        '${chars.substring(8, 12)}-'
        '${chars.substring(12, 16)}-'
        '${chars.substring(16, 20)}-'
        '${chars.substring(20)}';
  }
}
