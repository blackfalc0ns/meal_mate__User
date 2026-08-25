import 'package:json_annotation/json_annotation.dart';

part 'payment_checkout_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class PaymentCheckoutResponseDto {
  const PaymentCheckoutResponseDto({
    this.subscriptionId,
    this.paymentAnchorSubscriptionId,
    this.familyGroupId,
    this.paymentUrl,
    this.holdExpiresAtUtc,
    this.chosenStartDate,
    this.startDate,
    this.finalPrice,
    this.priceSnapshotId,
    this.restaurantPoolSnapshotId,
    this.paymentStatus,
  });

  final String? subscriptionId;
  final String? paymentAnchorSubscriptionId;
  final String? familyGroupId;
  final String? paymentUrl;
  final String? holdExpiresAtUtc;
  final String? chosenStartDate;
  final String? startDate;
  final double? finalPrice;
  final String? priceSnapshotId;
  final String? restaurantPoolSnapshotId;
  final String? paymentStatus;

  factory PaymentCheckoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentCheckoutResponseDtoFromJson(json);
}
