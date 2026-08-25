import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getPaymentMethodsUseCase,
    this._checkoutSubscriptionUseCase,
    this._getSubscriptionPaymentStatusUseCase,
    this._getSubscriptionCalendarUseCase,
  ) : super(const PaymentState());

  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CheckoutSubscriptionUseCase _checkoutSubscriptionUseCase;
  final GetSubscriptionPaymentStatusUseCase
  _getSubscriptionPaymentStatusUseCase;
  final GetSubscriptionCalendarUseCase _getSubscriptionCalendarUseCase;

  void doIntent(PaymentEvent event) {
    switch (event) {
      case LoadPaymentEvent():
        _load(event.args);
      case SelectPaymentMethodEvent():
        emit(state.copyWith(selectedMethod: event.method));
      case CheckoutPaymentEvent():
        _checkout(event.args);
      case VerifyPaymentFulfillmentEvent():
        _verifyFulfillment(event.subscriptionId);
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
        _pollCalendar(event.subscriptionId);
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
                  method.id > 0 &&
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
      case ApiErrorResult():
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

    for (final delay in const [
      Duration.zero,
      Duration(seconds: 2),
      Duration(seconds: 4),
      Duration(seconds: 8),
      Duration(seconds: 8),
      Duration(seconds: 8),
      Duration(seconds: 10),
      Duration(seconds: 10),
      Duration(seconds: 10),
    ]) {
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }

      final result = await _getSubscriptionPaymentStatusUseCase(subscriptionId);

      switch (result) {
        case ApiSuccessResult():
          if (_isPaymentPaid(result.data)) {
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

  Future<void> _pollCalendar(String subscriptionId) async {
    if (subscriptionId.isEmpty) return;

    emit(
      state.copyWith(
        isCalendarLoading: true,
        isCalendarSuccess: false,
        clearCalendarFailure: true,
      ),
    );

    for (final delay in const [
      Duration.zero,
      Duration(seconds: 2),
      Duration(seconds: 4),
      Duration(seconds: 8),
      Duration(seconds: 8),
      Duration(seconds: 8),
      Duration(seconds: 10),
      Duration(seconds: 10),
      Duration(seconds: 10),
    ]) {
      if (delay != Duration.zero) {
        await Future<void>.delayed(delay);
      }

      final result = await _getSubscriptionCalendarUseCase(subscriptionId);

      switch (result) {
        case ApiSuccessResult():
          emit(
            state.copyWith(
              isCalendarLoading: false,
              isCalendarSuccess: true,
              clearCalendarFailure: true,
            ),
          );
          return;
        case ApiErrorResult():
          if (delay == const Duration(seconds: 10)) {
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

    emit(state.copyWith(isCalendarLoading: false));
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
