import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
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
    this.pendingSubscriptionId,
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
  final String? pendingSubscriptionId;
  final PaymentStatusEntity? paymentStatus;
  final Failure? methodsFailure;
  final Failure? checkoutFailure;
  final Failure? fulfillmentFailure;
  final Failure? calendarFailure;

  bool get isLoading => isMethodsLoading;

  bool get hasContent => methods.isNotEmpty;

  bool get isCouponCheckoutFailure =>
      checkoutFailure != null &&
      (checkoutFailure!.code == SubscriptionErrorCodes.couponRejected ||
          checkoutFailure!.code == SubscriptionErrorCodes.couponNoLongerValid ||
          checkoutFailure!.code ==
              SubscriptionErrorCodes.couponFullDiscountUnsupported ||
          checkoutFailure!.exception.backendErrorCode ==
              SubscriptionErrorCodes.couponRejected ||
          checkoutFailure!.exception.backendErrorCode ==
              SubscriptionErrorCodes.couponNoLongerValid ||
          checkoutFailure!.exception.backendErrorCode ==
              SubscriptionErrorCodes.couponFullDiscountUnsupported);

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
    String? pendingSubscriptionId,
    PaymentStatusEntity? paymentStatus,
    Failure? methodsFailure,
    Failure? checkoutFailure,
    Failure? fulfillmentFailure,
    Failure? calendarFailure,
    bool clearSelectedMethod = false,
    bool clearCheckout = false,
    bool clearPendingSubscriptionId = false,
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
      pendingSubscriptionId: clearPendingSubscriptionId
          ? null
          : pendingSubscriptionId ?? this.pendingSubscriptionId,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentState &&
          runtimeType == other.runtimeType &&
          isMethodsLoading == other.isMethodsLoading &&
          isCheckoutLoading == other.isCheckoutLoading &&
          isFulfillmentLoading == other.isFulfillmentLoading &&
          isCalendarLoading == other.isCalendarLoading &&
          isFulfillmentSuccess == other.isFulfillmentSuccess &&
          isCalendarSuccess == other.isCalendarSuccess &&
          isPaymentFailed == other.isPaymentFailed &&
          selectedMethod?.id == other.selectedMethod?.id &&
          checkout?.subscriptionId == other.checkout?.subscriptionId &&
          pendingSubscriptionId == other.pendingSubscriptionId &&
          paymentStatus?.isPaid == other.paymentStatus?.isPaid &&
          methodsFailure == other.methodsFailure &&
          checkoutFailure == other.checkoutFailure &&
          fulfillmentFailure == other.fulfillmentFailure &&
          calendarFailure == other.calendarFailure &&
          methods.length == other.methods.length;

  @override
  int get hashCode => Object.hash(
    isMethodsLoading,
    isCheckoutLoading,
    isFulfillmentLoading,
    isCalendarLoading,
    isFulfillmentSuccess,
    isCalendarSuccess,
    isPaymentFailed,
    selectedMethod?.id,
    checkout?.subscriptionId,
    pendingSubscriptionId,
    paymentStatus?.isPaid,
    methodsFailure,
    checkoutFailure,
    fulfillmentFailure,
    calendarFailure,
    methods.length,
  );
}
