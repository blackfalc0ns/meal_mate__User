import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

class PaymentState {
  const PaymentState({
    this.isMethodsLoading = false,
    this.isAddressesLoading = false,
    this.isCheckoutLoading = false,
    this.isFulfillmentLoading = false,
    this.isFulfillmentSuccess = false,
    this.isPaymentFailed = false,
    this.methods = const [],
    this.selectedMethod,
    this.defaultAddress,
    this.checkout,
    this.methodsFailure,
    this.addressesFailure,
    this.checkoutFailure,
    this.fulfillmentFailure,
  });

  final bool isMethodsLoading;
  final bool isAddressesLoading;
  final bool isCheckoutLoading;
  final bool isFulfillmentLoading;
  final bool isFulfillmentSuccess;
  final bool isPaymentFailed;
  final List<PaymentMethodEntity> methods;
  final PaymentMethodEntity? selectedMethod;
  final CustomerAddressEntity? defaultAddress;
  final PaymentCheckoutEntity? checkout;
  final Failure? methodsFailure;
  final Failure? addressesFailure;
  final Failure? checkoutFailure;
  final Failure? fulfillmentFailure;

  bool get isLoading => isMethodsLoading || isAddressesLoading;

  bool get hasContent => methods.isNotEmpty;

  PaymentState copyWith({
    bool? isMethodsLoading,
    bool? isAddressesLoading,
    bool? isCheckoutLoading,
    bool? isFulfillmentLoading,
    bool? isFulfillmentSuccess,
    bool? isPaymentFailed,
    List<PaymentMethodEntity>? methods,
    PaymentMethodEntity? selectedMethod,
    CustomerAddressEntity? defaultAddress,
    PaymentCheckoutEntity? checkout,
    Failure? methodsFailure,
    Failure? addressesFailure,
    Failure? checkoutFailure,
    Failure? fulfillmentFailure,
    bool clearSelectedMethod = false,
    bool clearDefaultAddress = false,
    bool clearCheckout = false,
    bool clearMethodsFailure = false,
    bool clearAddressesFailure = false,
    bool clearCheckoutFailure = false,
    bool clearFulfillmentFailure = false,
  }) {
    return PaymentState(
      isMethodsLoading: isMethodsLoading ?? this.isMethodsLoading,
      isAddressesLoading: isAddressesLoading ?? this.isAddressesLoading,
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
      isFulfillmentLoading: isFulfillmentLoading ?? this.isFulfillmentLoading,
      isFulfillmentSuccess: isFulfillmentSuccess ?? this.isFulfillmentSuccess,
      isPaymentFailed: isPaymentFailed ?? this.isPaymentFailed,
      methods: methods ?? this.methods,
      selectedMethod: clearSelectedMethod
          ? null
          : selectedMethod ?? this.selectedMethod,
      defaultAddress: clearDefaultAddress
          ? null
          : defaultAddress ?? this.defaultAddress,
      checkout: clearCheckout ? null : checkout ?? this.checkout,
      methodsFailure: clearMethodsFailure
          ? null
          : methodsFailure ?? this.methodsFailure,
      addressesFailure: clearAddressesFailure
          ? null
          : addressesFailure ?? this.addressesFailure,
      checkoutFailure: clearCheckoutFailure
          ? null
          : checkoutFailure ?? this.checkoutFailure,
      fulfillmentFailure: clearFulfillmentFailure
          ? null
          : fulfillmentFailure ?? this.fulfillmentFailure,
    );
  }
}
