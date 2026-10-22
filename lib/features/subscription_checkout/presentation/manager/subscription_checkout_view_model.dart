import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_checkout_state.dart';

@injectable
class SubscriptionCheckoutViewModel extends Cubit<SubscriptionCheckoutState> {
  SubscriptionCheckoutViewModel(
    this._getPaymentMethodsUseCase,
    this._checkoutSubscriptionUseCase,
  ) : super(const SubscriptionCheckoutState());
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CheckoutSubscriptionUseCase _checkoutSubscriptionUseCase;
  int _methodsLoadGeneration = 0;
  String? _lastPurchaseFingerprint;
  String? _currentIdempotencyKey;

  void doIntent(SubscriptionCheckoutEvent event) {
    switch (event) {
      case LoadSubscriptionCheckoutEvent():
        unawaited(_load(event.args));
      case SelectCheckoutPaymentMethodEvent():
        if (!state.isCheckoutLoading &&
            state.checkout == null &&
            state.pendingSubscriptionId == null &&
            event.method.isAvailable &&
            event.method.id != null &&
            event.method.id! > 0) {
          emit(state.copyWith(selectedMethod: event.method));
        }
      case ResetSubscriptionCheckoutAfterFailureEvent():
        if (!state.isCheckoutLoading) {
          _lastPurchaseFingerprint = null;
          _currentIdempotencyKey = null;
          emit(
            state.copyWith(
              clearCheckout: true,
              clearPendingSubscriptionId: true,
              clearCheckoutFailure: true,
            ),
          );
        }
      case SubmitSubscriptionCheckoutEvent():
        unawaited(_checkout(event.args));
    }
  }

  Future<void> _load(SubscriptionCheckoutArgs args) async {
    if (state.isCheckoutLoading ||
        state.checkout != null ||
        state.pendingSubscriptionId != null) {
      return;
    }
    final currentGen = ++_methodsLoadGeneration;
    emit(
      state.copyWith(
        isMethodsLoading: true,
        methods: const [],
        clearSelectedMethod: true,
        clearMethodsFailure: true,
        clearCheckoutFailure: true,
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

  Future<void> _checkout(SubscriptionCheckoutArgs args) async {
    if (state.isCheckoutLoading ||
        state.checkout != null ||
        state.pendingSubscriptionId != null) {
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

    final fingerprint =
        '${args.summaryRequest.programId}|${args.summaryRequest.bundleId}|${args.summaryRequest.tier}|${args.summaryRequest.durationDays}|${args.summaryRequest.startDate}|${args.summaryRequest.includeFriday}|${args.summaryRequest.promoCode ?? ''}|${args.summaryRequest.offerId ?? ''}|${selectedMethod.id}';
    if (_lastPurchaseFingerprint != fingerprint ||
        _currentIdempotencyKey == null) {
      _lastPurchaseFingerprint = fingerprint;
      _currentIdempotencyKey = _generateCorrelationId();
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
      offerId: args.summaryRequest.offerId,
      idempotencyKey: _currentIdempotencyKey,
    );

    emit(
      state.copyWith(
        isCheckoutLoading: true,
        clearCheckout: true,
        clearCheckoutFailure: true,
        clearPendingSubscriptionId: true,
      ),
    );

    final result = await _checkoutSubscriptionUseCase(request);

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        final checkout = result.data;
        emit(
          state.copyWith(
            isCheckoutLoading: false,
            checkout: checkout,
            clearCheckoutFailure: true,
          ),
        );
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
