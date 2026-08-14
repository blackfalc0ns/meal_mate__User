import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/checkout_subscription_usecase.dart';
import 'package:meal_meat_user/features/payment/domain/usecase/get_payment_methods_usecase.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_event.dart';
import 'package:meal_meat_user/features/payment/presentation/manager/payment_state.dart';

@injectable
class PaymentViewModel extends Cubit<PaymentState> {
  PaymentViewModel(
    this._getPaymentMethodsUseCase,
    this._checkoutSubscriptionUseCase,
    this._getCustomerAddressesUseCase,
  ) : super(const PaymentState());

  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final CheckoutSubscriptionUseCase _checkoutSubscriptionUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;

  void doIntent(PaymentEvent event) {
    switch (event) {
      case LoadPaymentEvent():
        _load(event.args);
      case SelectPaymentMethodEvent():
        emit(state.copyWith(selectedMethod: event.method));
      case CheckoutPaymentEvent():
        _checkout(args: event.args, address: event.address);
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
            .where((method) => method.id > 0)
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
    required CustomerAddressEntity address,
  }) async {
    final selectedMethod = state.selectedMethod;
    if (selectedMethod == null) return;

    final request = PaymentCheckoutRequestEntity(
      restaurantId: args.restaurantId,
      programId: args.summaryRequest.programId,
      bundleId: args.summaryRequest.bundleId,
      tier: args.summaryRequest.tier,
      durationDays: args.summaryRequest.durationDays,
      startDate: args.summary.startDate,
      regionId: address.regionId ?? '',
      deliveryAddress: address.addressLine,
      callbackUrl: 'mealmate://payment/success',
      errorUrl: 'mealmate://payment/error',
      includeFriday: args.summaryRequest.includeFriday,
      paymentMethodId: selectedMethod.id,
      correlationId: DateTime.now().microsecondsSinceEpoch.toString(),
    );

    if (!request.isComplete) return;

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
}
