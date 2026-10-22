import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_status_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

extension PaymentCheckoutResponseDtoMapper on PaymentCheckoutResponseDto {
  PaymentCheckoutEntity toEntity() {
    return PaymentCheckoutEntity(
      subscriptionId: subscriptionId ?? paymentAnchorSubscriptionId ?? '',
      paymentUrl: paymentUrl ?? '',
      holdExpiresAtUtc: holdExpiresAtUtc ?? '',
      serverTimeUtc: serverTimeUtc,
      chosenStartDate: chosenStartDate ?? '',
      startDate: startDate ?? '',
      finalPrice: finalPrice ?? 0,
      priceSnapshotId: priceSnapshotId ?? '',
      restaurantPoolSnapshotId: restaurantPoolSnapshotId ?? '',
      paymentStatus: paymentStatus ?? '',
      fulfillmentStatus: fulfillmentStatus,
      menuPlanVersionId: menuPlanVersionId,
      paymentDate: paymentDate,
      paymentId: paymentId,
    );
  }
}

extension PaymentStatusResponseDtoMapper on PaymentStatusResponseDto {
  PaymentStatusEntity toEntity() {
    return PaymentStatusEntity(
      paymentStatus: paymentStatus ?? '',
      isPaid: isPaid ?? false,
      isFailed: isFailed ?? false,
      amount: amount ?? 0,
      currencyCode: currencyCode ?? '',
      isFulfillmentReady: isFulfillmentReady,
      fulfillmentStatus: fulfillmentStatus,
    );
  }
}
