import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/constants/keys.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_current_customer_subscription_usecase.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getPaymentMethodsUseCase,
    this._checkoutSubscriptionUseCase,
    this._getSubscriptionPaymentStatusUseCase,
    this._getSubscriptionCalendarUseCase,
    this._getCurrentCustomerSubscriptionUseCase,
    this._sharedPrefHelper,
  ) : super(const PaymentState());

  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CheckoutSubscriptionUseCase _checkoutSubscriptionUseCase;
  final GetSubscriptionPaymentStatusUseCase
  _getSubscriptionPaymentStatusUseCase;
  final GetSubscriptionCalendarUseCase _getSubscriptionCalendarUseCase;
  final GetCurrentCustomerSubscriptionUseCase
  _getCurrentCustomerSubscriptionUseCase;
  final SharedPrefHelper _sharedPrefHelper;

  void doIntent(PaymentEvent event) {
    switch (event) {
      case LoadPaymentEvent():
        unawaited(_load(event.args));
      case SelectPaymentMethodEvent():
        emit(state.copyWith(selectedMethod: event.method));
      case CheckoutPaymentEvent():
        unawaited(_checkout(event.args));
      case VerifyPaymentFulfillmentEvent():
        unawaited(_verifyFulfillment(event.subscriptionId));
      case MarkPaymentFailedEvent():
        emit(
          state.copyWith(
            isPaymentFailed: true,
            isFulfillmentLoading: false,
            isCalendarLoading: false,
            isFulfillmentSuccess: false,
            isCalendarSuccess: false,
          ),
        );
      case PollSubscriptionCalendarEvent():
        unawaited(_pollCalendar(event.subscriptionId));
    }
  }

  Future<void> _load(PaymentArgs args) async {
    emit(
      state.copyWith(
        isMethodsLoading: true,
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

    switch (methodsResult) {
      case ApiSuccessResult():
        final methods = methodsResult.data
            .where(
              (method) =>
                  method.id != 0 &&
                  method.isAvailable &&
                  method.type != PaymentMethodType.wallet,
            )
            .toList();
        emit(
          state.copyWith(
            isMethodsLoading: false,
            methods: methods,
            selectedMethod: methods.isEmpty ? null : methods.first,
            clearMethodsFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isMethodsLoading: false,
            methodsFailure: methodsResult.failure,
          ),
        );
    }
  }

  Future<void> _checkout(PaymentArgs args) async {
    final selectedMethod = state.selectedMethod;
    if (selectedMethod == null) return;

    final request = PaymentCheckoutRequestEntity(
      programId: args.summaryRequest.programId,
      bundleId: args.summaryRequest.bundleId,
      tier: args.summaryRequest.tier,
      durationDays: args.summaryRequest.durationDays,
      startDate: args.summaryRequest.startDate,
      callbackUrl: 'mealmate://payment/success',
      errorUrl: 'mealmate://payment/error',
      includeFriday: args.summaryRequest.includeFriday,
      paymentMethodId: selectedMethod.id,
      correlationId: _generateCorrelationId(),
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

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isCheckoutLoading: false,
            checkout: result.data,
            clearCheckoutFailure: true,
          ),
        );
        if (result.data.paymentUrl.isEmpty &&
            result.data.subscriptionId.isNotEmpty) {
          await _verifyFulfillment(result.data.subscriptionId);
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

  Future<void> _verifyFulfillment(String subscriptionId) async {
    if (subscriptionId.isEmpty) return;

    emit(
      state.copyWith(
        isFulfillmentLoading: true,
        isFulfillmentSuccess: false,
        isCalendarLoading: false,
        isCalendarSuccess: false,
        isPaymentFailed: false,
        clearFulfillmentFailure: true,
        clearCalendarFailure: true,
      ),
    );

    for (final delay in _pollingBackoff()) {
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }

      final result = await _getSubscriptionPaymentStatusUseCase(subscriptionId);

      switch (result) {
        case ApiSuccessResult():
          if (_isPaymentPaid(result.data)) {
            await _syncCurrentSubscriptionCache();
            emit(
              state.copyWith(
                isFulfillmentLoading: false,
                isFulfillmentSuccess: true,
                isPaymentFailed: false,
                paymentStatus: result.data,
                clearFulfillmentFailure: true,
              ),
            );
            return;
          }

          if (_isPaymentFailed(result.data)) {
            emit(
              state.copyWith(
                isFulfillmentLoading: false,
                isFulfillmentSuccess: false,
                isPaymentFailed: true,
                paymentStatus: result.data,
                clearFulfillmentFailure: true,
              ),
            );
            return;
          }

          continue;
        case ApiErrorResult():
          emit(
            state.copyWith(
              isFulfillmentLoading: false,
              fulfillmentFailure: result.failure,
            ),
          );
          return;
      }
    }

    emit(state.copyWith(isFulfillmentLoading: false));
  }

  bool _isPaymentPaid(PaymentStatusEntity paymentStatus) {
    return paymentStatus.isPaid;
  }

  bool _isPaymentFailed(PaymentStatusEntity paymentStatus) {
    return paymentStatus.isFailed;
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

  Future<void> _pollCalendar(String subscriptionId) async {
    if (subscriptionId.isEmpty) return;
    if (state.isCalendarLoading || state.isCalendarSuccess) return;

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

      final result = await _getSubscriptionCalendarUseCase(subscriptionId);

      switch (result) {
        case ApiSuccessResult():
          await _sharedPrefHelper.saveData(
            key: StorageKeys.currentSubscriptionId,
            val: subscriptionId,
          );
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

    emit(
      state.copyWith(isCalendarLoading: false, calendarFailure: lastFailure),
    );
  }

  Iterable<Duration> _pollingBackoff() sync* {
    yield Duration.zero;
    yield const Duration(seconds: 2);
    yield const Duration(seconds: 5);
    var elapsed = 7;
    while (elapsed < 120) {
      yield const Duration(seconds: 10);
      elapsed += 10;
    }
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

  String? _pendingSubscriptionIdFromFailure(Failure failure) {
    if (failure.code != 'checkout.existing_subscription') return null;
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
