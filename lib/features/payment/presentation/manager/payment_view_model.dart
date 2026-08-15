import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getPaymentMethodsUseCase,
    this._checkoutSubscriptionUseCase,
    this._getCustomerAddressesUseCase,
    this._getSubscriptionPaymentStatusUseCase,
  ) : super(const PaymentState());

  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CheckoutSubscriptionUseCase _checkoutSubscriptionUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;
  final GetSubscriptionPaymentStatusUseCase
  _getSubscriptionPaymentStatusUseCase;

  void doIntent(PaymentEvent event) {
    switch (event) {
      case LoadPaymentEvent():
        _load(event.args);
      case SelectPaymentMethodEvent():
        emit(state.copyWith(selectedMethod: event.method));
      case CheckoutPaymentEvent():
        _checkout(args: event.args, address: event.address);
      case VerifyPaymentFulfillmentEvent():
        _verifyFulfillment(event.subscriptionId);
      case MarkPaymentFailedEvent():
        emit(
          state.copyWith(
            isPaymentFailed: true,
            isFulfillmentLoading: false,
            isFulfillmentSuccess: false,
          ),
        );
    }
  }

  Future<void> _load(PaymentArgs args) async {
    emit(
      state.copyWith(
        isMethodsLoading: true,
        isAddressesLoading: true,
        clearSelectedMethod: true,
        clearDefaultAddress: true,
        clearMethodsFailure: true,
        clearAddressesFailure: true,
        clearCheckoutFailure: true,
        clearCheckout: true,
      ),
    );

    final methodsResult = await _getPaymentMethodsUseCase(
      amount: args.summary.finalPrice,
    );
    final addressesResult = await _getCustomerAddressesUseCase();

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

    switch (addressesResult) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isAddressesLoading: false,
            defaultAddress: _defaultAddress(addressesResult.data),
            clearAddressesFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isAddressesLoading: false,
            addressesFailure: addressesResult.failure,
          ),
        );
    }
  }

  Future<void> _checkout({
    required PaymentArgs args,
    required CustomerAddressEntity? address,
  }) async {
    final selectedMethod = state.selectedMethod;
    if (selectedMethod == null) return;

    final request = PaymentCheckoutRequestEntity(
      restaurantId: args.restaurantId,
      programId: args.summaryRequest.programId,
      bundleId: args.summaryRequest.bundleId,
      tier: args.summaryRequest.tier,
      durationDays: args.summaryRequest.durationDays,
      startDate: _checkoutStartDate(args),
      regionId: address?.regionId ?? '',
      deliveryAddress: address?.addressLine ?? '',
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

  CustomerAddressEntity? _defaultAddress(
    List<CustomerAddressEntity> addresses,
  ) {
    for (final address in addresses) {
      if (address.isDefault) return address;
    }
    return addresses.isEmpty ? null : addresses.first;
  }

  Future<void> _verifyFulfillment(String subscriptionId) async {
    if (subscriptionId.isEmpty) return;

    emit(
      state.copyWith(
        isFulfillmentLoading: true,
        isFulfillmentSuccess: false,
        isPaymentFailed: false,
        clearFulfillmentFailure: true,
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
    return paymentStatus.isPaid ||
        paymentStatus.paymentStatus.toLowerCase() == 'paid';
  }

  bool _isPaymentFailed(PaymentStatusEntity paymentStatus) {
    final status = paymentStatus.paymentStatus.toLowerCase();
    return paymentStatus.isFailed ||
        status == 'failed' ||
        status == 'canceled' ||
        status == 'cancelled';
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

  String _checkoutStartDate(PaymentArgs args) {
    if (args.summary.startDate.isNotEmpty) return args.summary.startDate;
    return args.summary.serviceDates.isEmpty
        ? ''
        : args.summary.serviceDates.first;
  }
}
