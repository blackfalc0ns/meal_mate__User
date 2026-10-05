import 'package:json_annotation/json_annotation.dart';

part 'subscription_coupon_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionCouponResponseDto {
  const SubscriptionCouponResponseDto({
    this.code,
    this.status,
    this.offerId,
    this.discountAmount,
    this.messageAr,
    this.messageEn,
  });

  final String? code;
  final String? status;
  final String? offerId;
  final double? discountAmount;
  final String? messageAr;
  final String? messageEn;

  factory SubscriptionCouponResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCouponResponseDtoFromJson(json);
}
