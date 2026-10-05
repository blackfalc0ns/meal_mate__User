import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_coupon_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_coupon_entity.dart';

extension SubscriptionCouponResponseDtoMapper on SubscriptionCouponResponseDto {
  SubscriptionCouponEntity toEntity() {
    final rawStatusString = status?.trim() ?? '';
    return SubscriptionCouponEntity(
      code: code?.trim() ?? '',
      rawStatus: rawStatusString,
      status: SubscriptionCouponStatus.fromRaw(rawStatusString),
      offerId: offerId,
      discountAmount: discountAmount ?? 0.0,
      messageAr: messageAr,
      messageEn: messageEn,
    );
  }
}

extension CouponFailureExtractor on Failure {
  SubscriptionCouponEntity? extractCoupon() {
    final res = exception.response;
    if (res is Map<String, dynamic>) {
      final couponJson = res['coupon'];
      if (couponJson is Map<String, dynamic>) {
        return SubscriptionCouponResponseDto.fromJson(couponJson).toEntity();
      }
    } else if (res is Map) {
      final couponJson = res['coupon'];
      if (couponJson is Map) {
        return SubscriptionCouponResponseDto.fromJson(
          Map<String, dynamic>.from(couponJson),
        ).toEntity();
      }
    }
    return null;
  }
}
