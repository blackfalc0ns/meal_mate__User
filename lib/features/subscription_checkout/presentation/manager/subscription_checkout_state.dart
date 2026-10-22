import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';

class SubscriptionCheckoutState {
  const SubscriptionCheckoutState({
    this.isMethodsLoading = false,
    this.isCheckoutLoading = false,
    this.methods = const [],
    this.selectedMethod,
    this.checkout,
    this.pendingSubscriptionId,
    this.methodsFailure,
    this.checkoutFailure,
  });
  final bool isMethodsLoading;
  final bool isCheckoutLoading;
  final List<PaymentMethodEntity> methods;
  final PaymentMethodEntity? selectedMethod;
  final PaymentCheckoutEntity? checkout;
  final String? pendingSubscriptionId;
  final Failure? methodsFailure;
  final Failure? checkoutFailure;
  bool get isLoading => isMethodsLoading;
  bool get hasContent => methods.isNotEmpty;

  bool get isCouponCheckoutFailure =>
      checkoutFailure != null &&
      [
        SubscriptionErrorCodes.couponRejected,
        SubscriptionErrorCodes.couponNoLongerValid,
        SubscriptionErrorCodes.couponFullDiscountUnsupported,
      ].any(
        (code) =>
            checkoutFailure!.code == code ||
            checkoutFailure!.exception.backendErrorCode == code,
      );

  bool get isAvailabilityChangedFailure =>
      checkoutFailure != null &&
      (checkoutFailure!.code == 'checkout.quote_changed' ||
          checkoutFailure!.exception.backendErrorCode ==
              'checkout.quote_changed' ||
          checkoutFailure!.code ==
              SubscriptionErrorCodes.restaurantNotEligible ||
          checkoutFailure!.code == 'restaurant.not_eligible' ||
          checkoutFailure!.code ==
              'subscription_flow.no_restaurants_for_selection' ||
          checkoutFailure!.exception.backendErrorCode ==
              SubscriptionErrorCodes.restaurantNotEligible ||
          checkoutFailure!.exception.backendErrorCode ==
              'restaurant.not_eligible');

  SubscriptionCheckoutState copyWith({
    bool? isMethodsLoading,
    bool? isCheckoutLoading,
    List<PaymentMethodEntity>? methods,
    PaymentMethodEntity? selectedMethod,
    PaymentCheckoutEntity? checkout,
    String? pendingSubscriptionId,
    Failure? methodsFailure,
    Failure? checkoutFailure,
    bool clearSelectedMethod = false,
    bool clearCheckout = false,
    bool clearPendingSubscriptionId = false,
    bool clearMethodsFailure = false,
    bool clearCheckoutFailure = false,
  }) {
    return SubscriptionCheckoutState(
      isMethodsLoading: isMethodsLoading ?? this.isMethodsLoading,
      isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
      methods: methods ?? this.methods,
      selectedMethod: clearSelectedMethod
          ? null
          : selectedMethod ?? this.selectedMethod,
      checkout: clearCheckout ? null : checkout ?? this.checkout,
      pendingSubscriptionId: clearPendingSubscriptionId
          ? null
          : pendingSubscriptionId ?? this.pendingSubscriptionId,
      methodsFailure: clearMethodsFailure
          ? null
          : methodsFailure ?? this.methodsFailure,
      checkoutFailure: clearCheckoutFailure
          ? null
          : checkoutFailure ?? this.checkoutFailure,
    );
  }
}
