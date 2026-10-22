import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';

class PaymentState {
  const PaymentState({
    this.isSessionInitializing = false,
    this.isSessionReady = false,
    this.isFulfillmentLoading = false,
    this.isCalendarLoading = false,
    this.isFulfillmentSuccess = false,
    this.isCalendarSuccess = false,
    this.isPaymentFailed = false,
    this.isReviewRequired = false,
    this.isPaymentPending = false,
    this.isPaidProcessing = false,
    this.attemptHandle,
    this.checkout,
    this.pendingSubscriptionId,
    this.paymentStatus,
    this.checkoutFailure,
    this.fulfillmentFailure,
    this.calendarFailure,
    this.confirmation,
    this.isHoldRenewing = false,
    this.flowType = 'individual',
  });

  final SubscriptionConfirmationEntity? confirmation;
  final bool isSessionInitializing;
  final bool isSessionReady;
  final bool isFulfillmentLoading;
  final bool isCalendarLoading;
  final bool isFulfillmentSuccess;
  final bool isCalendarSuccess;
  final bool isPaymentFailed;
  final bool isReviewRequired;
  final bool isPaymentPending;
  final bool isPaidProcessing;
  final String? attemptHandle;
  final PaymentCheckoutEntity? checkout;
  final String? pendingSubscriptionId;
  final PaymentStatusEntity? paymentStatus;
  final Failure? checkoutFailure;
  final Failure? fulfillmentFailure;
  final Failure? calendarFailure;
  final bool isHoldRenewing;
  final String flowType;

  bool get isFamily => flowType == 'family';

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

  bool get isCalendarFulfillmentNotReady =>
      calendarFailure != null &&
      (calendarFailure!.code == 'calendar.fulfillment_not_ready' ||
          calendarFailure!.exception.backendErrorCode ==
              'calendar.fulfillment_not_ready');

  PaymentState copyWith({
    bool? isHoldRenewing,
    bool? isSessionInitializing,
    bool? isSessionReady,
    bool? isFulfillmentLoading,
    bool? isCalendarLoading,
    bool? isFulfillmentSuccess,
    bool? isCalendarSuccess,
    bool? isPaymentFailed,
    bool? isReviewRequired,
    bool? isPaymentPending,
    bool? isPaidProcessing,
    String? attemptHandle,
    PaymentCheckoutEntity? checkout,
    String? pendingSubscriptionId,
    PaymentStatusEntity? paymentStatus,
    Failure? checkoutFailure,
    Failure? fulfillmentFailure,
    Failure? calendarFailure,
    SubscriptionConfirmationEntity? confirmation,
    String? flowType,
    bool clearCheckout = false,
    bool clearPendingSubscriptionId = false,
    bool clearPaymentStatus = false,
    bool clearCheckoutFailure = false,
    bool clearFulfillmentFailure = false,
    bool clearCalendarFailure = false,
    bool clearAttemptHandle = false,
    bool clearConfirmation = false,
  }) {
    return PaymentState(
      isHoldRenewing: isHoldRenewing ?? this.isHoldRenewing,
      isSessionInitializing:
          isSessionInitializing ?? this.isSessionInitializing,
      isSessionReady: isSessionReady ?? this.isSessionReady,
      isFulfillmentLoading: isFulfillmentLoading ?? this.isFulfillmentLoading,
      isCalendarLoading: isCalendarLoading ?? this.isCalendarLoading,
      isFulfillmentSuccess: isFulfillmentSuccess ?? this.isFulfillmentSuccess,
      isCalendarSuccess: isCalendarSuccess ?? this.isCalendarSuccess,
      isPaymentFailed: isPaymentFailed ?? this.isPaymentFailed,
      isReviewRequired: isReviewRequired ?? this.isReviewRequired,
      isPaymentPending: isPaymentPending ?? this.isPaymentPending,
      isPaidProcessing: isPaidProcessing ?? this.isPaidProcessing,
      attemptHandle: clearAttemptHandle
          ? null
          : attemptHandle ?? this.attemptHandle,
      checkout: clearCheckout ? null : checkout ?? this.checkout,
      pendingSubscriptionId: clearPendingSubscriptionId
          ? null
          : pendingSubscriptionId ?? this.pendingSubscriptionId,
      paymentStatus: clearPaymentStatus
          ? null
          : paymentStatus ?? this.paymentStatus,
      checkoutFailure: clearCheckoutFailure
          ? null
          : checkoutFailure ?? this.checkoutFailure,
      fulfillmentFailure: clearFulfillmentFailure
          ? null
          : fulfillmentFailure ?? this.fulfillmentFailure,
      calendarFailure: clearCalendarFailure
          ? null
          : calendarFailure ?? this.calendarFailure,
      confirmation: clearConfirmation
          ? null
          : confirmation ?? this.confirmation,
      flowType: flowType ?? this.flowType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentState &&
          runtimeType == other.runtimeType &&
          isHoldRenewing == other.isHoldRenewing &&
          isSessionInitializing == other.isSessionInitializing &&
          isSessionReady == other.isSessionReady &&
          isFulfillmentLoading == other.isFulfillmentLoading &&
          isCalendarLoading == other.isCalendarLoading &&
          isFulfillmentSuccess == other.isFulfillmentSuccess &&
          isCalendarSuccess == other.isCalendarSuccess &&
          isPaymentFailed == other.isPaymentFailed &&
          isReviewRequired == other.isReviewRequired &&
          isPaymentPending == other.isPaymentPending &&
          isPaidProcessing == other.isPaidProcessing &&
          attemptHandle == other.attemptHandle &&
          checkout == other.checkout &&
          pendingSubscriptionId == other.pendingSubscriptionId &&
          paymentStatus?.isPaid == other.paymentStatus?.isPaid &&
          checkoutFailure == other.checkoutFailure &&
          fulfillmentFailure == other.fulfillmentFailure &&
          calendarFailure == other.calendarFailure;

  @override
  int get hashCode => Object.hashAll([
    isHoldRenewing,
    isSessionInitializing,
    isSessionReady,
    isFulfillmentLoading,
    isCalendarLoading,
    isFulfillmentSuccess,
    isCalendarSuccess,
    isPaymentFailed,
    isReviewRequired,
    isPaymentPending,
    isPaidProcessing,
    attemptHandle,
    checkout?.subscriptionId,
    pendingSubscriptionId,
    paymentStatus?.isPaid,
    checkoutFailure,
    fulfillmentFailure,
    calendarFailure,
  ]);
}
