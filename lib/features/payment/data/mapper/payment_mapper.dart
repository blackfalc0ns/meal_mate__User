import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_status_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

extension PaymentMethodResponseDtoMapper on PaymentMethodResponseDto {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: paymentMethodId ?? id ?? 0,
      type: _methodType,
      title: titleAr ?? titleEn ?? title ?? nameAr ?? nameEn ?? name ?? '',
      subtitle: descriptionAr ?? descriptionEn ?? description ?? '',
      isAvailable: isAvailable ?? false,
      walletBalance: walletBalance,
    );
  }

  PaymentMethodType get _methodType {
    final effectiveId = paymentMethodId ?? id;
    final normalizedCode = code?.trim().toUpperCase();

    final isCodePayzah = normalizedCode == 'PAYZAH';
    final isIdPayzah = effectiveId == 3;

    if (isCodePayzah && isIdPayzah) {
      return PaymentMethodType.payzah;
    }
    if (isCodePayzah && effectiveId != null && effectiveId != 3) {
      return PaymentMethodType.unknown;
    }
    if (isIdPayzah && normalizedCode != null && normalizedCode != 'PAYZAH') {
      return PaymentMethodType.unknown;
    }
    if (isCodePayzah || isIdPayzah) {
      return PaymentMethodType.payzah;
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

    if (value.contains('sandbox') ||
        value.contains('تجربة') ||
        value.contains('without_payment') ||
        (effectiveId != null && effectiveId < 0)) {
      return PaymentMethodType.sandbox;
    }
    if (value.contains('wallet') || normalizedCode == 'WALLET') {
      return PaymentMethodType.wallet;
    }
    if (value.contains('apple') || normalizedCode == 'APPLE_PAY') {
      return PaymentMethodType.applePay;
    }
    if (value.contains('visa') ||
        value.contains('master') ||
        normalizedCode == 'VISA' ||
        normalizedCode == 'MASTERCARD') {
      return PaymentMethodType.visa;
    }
    if (value.contains('mada') ||
        normalizedCode == 'MADA' ||
        normalizedCode == 'MD') {
      return PaymentMethodType.mada;
    }

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
    );
  }
}
