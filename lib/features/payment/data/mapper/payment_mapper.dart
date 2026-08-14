import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

extension PaymentMethodResponseDtoMapper on PaymentMethodResponseDto {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: paymentMethodId ?? id ?? 0,
      type: _methodType,
      title: titleAr ?? titleEn ?? title ?? nameAr ?? nameEn ?? name ?? '',
      subtitle: descriptionAr ?? descriptionEn ?? description ?? '',
      walletBalance: walletBalance,
    );
  }

  PaymentMethodType get _methodType {
    final value = [
      code,
      name,
      nameAr,
      nameEn,
      title,
      titleAr,
      titleEn,
    ].whereType<String>().join(' ').toLowerCase();

    if (value.contains('wallet')) return PaymentMethodType.wallet;
    if (value.contains('apple')) return PaymentMethodType.applePay;
    if (value.contains('visa') || value.contains('master')) {
      return PaymentMethodType.visa;
    }
    return PaymentMethodType.mada;
  }
}

extension PaymentCheckoutRequestEntityMapper on PaymentCheckoutRequestEntity {
  PaymentCheckoutRequestDto toDto() {
    return PaymentCheckoutRequestDto(
      restaurantId: restaurantId,
      programId: programId,
      bundleId: bundleId,
      tier: tier,
      durationDays: durationDays,
      startDate: startDate,
      regionId: regionId,
      deliveryAddress: deliveryAddress,
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      includeFriday: includeFriday,
      paymentMethodId: paymentMethodId,
      correlationId: correlationId,
    );
  }
}

extension PaymentCheckoutResponseDtoMapper on PaymentCheckoutResponseDto {
  PaymentCheckoutEntity toEntity() {
    return PaymentCheckoutEntity(
      subscriptionId: subscriptionId ?? '',
      paymentUrl: paymentUrl ?? '',
      holdExpiresAtUtc: holdExpiresAtUtc ?? '',
      finalPrice: finalPrice ?? 0,
      priceSnapshotId: priceSnapshotId ?? '',
      restaurantPoolSnapshotId: restaurantPoolSnapshotId ?? '',
    );
  }
}
