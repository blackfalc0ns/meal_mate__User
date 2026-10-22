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
    this.fulfillmentStatus,
    this.menuPlanVersionId,
    this.paymentDate,
    this.paymentId,
    this.serverTimeUtc,
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
  final String? fulfillmentStatus;
  final String? menuPlanVersionId;
  final String? paymentDate;
  final String? paymentId;
  final DateTime? serverTimeUtc;

  factory PaymentCheckoutResponseDto.fromJson(Map<String, dynamic> json) {
    final serverTime = json['serverTimeUtc'] ?? json['eligibilityCheckedAtUtc'];
    final dto = _$PaymentCheckoutResponseDtoFromJson(json);
    return serverTime != null && dto.serverTimeUtc == null
        ? PaymentCheckoutResponseDto(
            subscriptionId: dto.subscriptionId,
            paymentAnchorSubscriptionId: dto.paymentAnchorSubscriptionId,
            familyGroupId: dto.familyGroupId,
            paymentUrl: dto.paymentUrl,
            holdExpiresAtUtc: dto.holdExpiresAtUtc,
            chosenStartDate: dto.chosenStartDate,
            startDate: dto.startDate,
            finalPrice: dto.finalPrice,
            priceSnapshotId: dto.priceSnapshotId,
            restaurantPoolSnapshotId: dto.restaurantPoolSnapshotId,
            paymentStatus: dto.paymentStatus,
            fulfillmentStatus: dto.fulfillmentStatus,
            menuPlanVersionId: dto.menuPlanVersionId,
            paymentDate: dto.paymentDate,
            paymentId: dto.paymentId,
            serverTimeUtc: DateTime.tryParse(serverTime.toString()),
          )
        : dto;
  }
}
