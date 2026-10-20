import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_status_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

extension PaymentMethodResponseDtoMapper on PaymentMethodResponseDto {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: paymentMethodId ?? id,
      type: _methodType,
      title: nameAr ?? nameEn ?? name ?? titleAr ?? titleEn ?? title ?? '',
      subtitle:
          descriptionAr ??
          descriptionEn ??
          description ??
          (unavailableReason ?? ''),
      isAvailable: isAvailable ?? false,
      code: code,
      integrationType: integrationType,
      serviceCharge: serviceCharge,
      totalAmount: totalAmount,
      currencyCode: currencyCode,
      unavailableReason: unavailableReason,
      imageUrl: imageUrl,
      walletBalance: walletBalance,
    );
  }

  PaymentMethodType get _methodType {
    final normalizedCode = code?.trim().toUpperCase();
    final normalizedIntegration = integrationType?.trim().toUpperCase();

    // Hosted Payzah is identified by code or integrationType, NOT hardcoded ID 3.
    if (normalizedCode == 'PAYZAH' ||
        normalizedIntegration == 'PAYZAH_HOSTED') {
      return PaymentMethodType.payzah;
    }

    if (normalizedCode == 'MEALMATE_WALLET' || normalizedCode == 'WALLET') {
      return PaymentMethodType.wallet;
    }

    final value = [
      code,
      name,
      nameAr,
      nameEn,
      title,
      titleAr,
      titleEn,
    ].whereType<String>().join(' ').toLowerCase();

    if (value.contains('payzah')) {
      return PaymentMethodType.payzah;
    }
    if (value.contains('wallet')) {
      return PaymentMethodType.wallet;
    }

    // Legacy sandbox and unknown providers map to unknown
    return PaymentMethodType.unknown;
  }
}

extension PaymentCheckoutRequestEntityMapper on PaymentCheckoutRequestEntity {
  PaymentCheckoutRequestDto toDto() {
    return PaymentCheckoutRequestDto(
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      startDate: startDate,
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      includeFriday: includeFriday,
      paymentMethodId: paymentMethodId,
      correlationId: correlationId,
      promoCode: promoCode,
      offerId: offerId,
      idempotencyKey: idempotencyKey,
      quoteId: quoteId,
    );
  }
}

extension PaymentCheckoutResponseDtoMapper on PaymentCheckoutResponseDto {
  PaymentCheckoutEntity toEntity() {
    return PaymentCheckoutEntity(
      subscriptionId: subscriptionId ?? paymentAnchorSubscriptionId ?? '',
      paymentUrl: paymentUrl ?? '',
      holdExpiresAtUtc: holdExpiresAtUtc ?? '',
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
