import 'package:json_annotation/json_annotation.dart';

part 'payment_checkout_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class PaymentCheckoutResponseDto {
  const PaymentCheckoutResponseDto({
    this.subscriptionId,
    this.paymentUrl,
    this.holdExpiresAtUtc,
    this.finalPrice,
    this.priceSnapshotId,
    this.restaurantPoolSnapshotId,
  });

  final String? subscriptionId;
  final String? paymentUrl;
  final String? holdExpiresAtUtc;
  final double? finalPrice;
  final String? priceSnapshotId;
  final String? restaurantPoolSnapshotId;

  factory PaymentCheckoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentCheckoutResponseDtoFromJson(json);
}
