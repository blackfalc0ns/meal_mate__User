import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

class PaymentState {
  const PaymentState({
    this.isMethodsLoading = false,
    this.isCheckoutLoading = false,
    this.isFulfillmentLoading = false,
    this.isCalendarLoading = false,
    this.isFulfillmentSuccess = false,
    this.isCalendarSuccess = false,
    this.isPaymentFailed = false,
    this.methods = const [],
    this.selectedMethod,
    this.checkout,
    this.paymentStatus,
    this.methodsFailure,
    this.checkoutFailure,
    this.fulfillmentFailure,
    this.calendarFailure,
  });

  final bool isMethodsLoading;
  final bool isCheckoutLoading;
  final bool isFulfillmentLoading;
  final bool isCalendarLoading;
  final bool isFulfillmentSuccess;
  final bool isCalendarSuccess;
  final bool isPaymentFailed;
  final List<PaymentMethodEntity> methods;
  final PaymentMethodEntity? selectedMethod;
  final PaymentCheckoutEntity? checkout;
  final PaymentStatusEntity? paymentStatus;
  final Failure? methodsFailure;
  final Failure? checkoutFailure;
  final Failure? fulfillmentFailure;
  final Failure? calendarFailure;

  bool get isLoading => isMethodsLoading;

  bool get hasContent => methods.isNotEmpty;

  PaymentState copyWith({
    bool? isMethodsLoading,
    bool? isCheckoutLoading,
    bool? isFulfillmentLoading,
    bool? isCalendarLoading,
    bool? isFulfillmentSuccess,
    bool? isCalendarSuccess,
    bool? isPaymentFailed,
    List<PaymentMethodEntity>? methods,
    PaymentMethodEntity? selectedMethod,
    PaymentCheckoutEntity? checkout,
    PaymentStatusEntity? paymentStatus,
    Failure? methodsFailure,
    Failure? checkoutFailure,
    Failure? fulfillmentFailure,
    Failure? calendarFailure,
    bool clearSelectedMethod = false,
    bool clearCheckout = false,
    bool clearPaymentStatus = false,
    bool clearMethodsFailure = false,
    bool clearCheckoutFailure = false,
    bool clearFulfillmentFailure = false,
    bool clearCalendarFailure = false,
  }) {
    return PaymentState(
      isMethodsLoading: isMethodsLoading ?? this.isMethodsLoading,
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
      isFulfillmentLoading: isFulfillmentLoading ?? this.isFulfillmentLoading,
      isCalendarLoading: isCalendarLoading ?? this.isCalendarLoading,
      isFulfillmentSuccess: isFulfillmentSuccess ?? this.isFulfillmentSuccess,
      isCalendarSuccess: isCalendarSuccess ?? this.isCalendarSuccess,
      isPaymentFailed: isPaymentFailed ?? this.isPaymentFailed,
      methods: methods ?? this.methods,
      selectedMethod: clearSelectedMethod
          ? null
          : selectedMethod ?? this.selectedMethod,
      checkout: clearCheckout ? null : checkout ?? this.checkout,
      paymentStatus: clearPaymentStatus
          ? null
          : paymentStatus ?? this.paymentStatus,
      methodsFailure: clearMethodsFailure
          ? null
          : methodsFailure ?? this.methodsFailure,
      checkoutFailure: clearCheckoutFailure
          ? null
          : checkoutFailure ?? this.checkoutFailure,
      fulfillmentFailure: clearFulfillmentFailure
          ? null
          : fulfillmentFailure ?? this.fulfillmentFailure,
      calendarFailure: clearCalendarFailure
          ? null
          : calendarFailure ?? this.calendarFailure,
    );
  }
}
