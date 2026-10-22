import 'package:json_annotation/json_annotation.dart';

part 'family_pending_checkout_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyPendingCheckoutResponseDto {
  const FamilyPendingCheckoutResponseDto({
    this.familyGroupId,
    this.paymentAnchorSubscriptionId,
    this.paymentUrl,
    this.holdExpiresAtUtc,
    this.finalPrice,
    this.batchId,
    this.batchVersion,
  });

  final String? familyGroupId;
  final String? paymentAnchorSubscriptionId;
  final String? paymentUrl;
  final String? holdExpiresAtUtc;
  final double? finalPrice;
  final String? batchId;
  final int? batchVersion;

  factory FamilyPendingCheckoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyPendingCheckoutResponseDtoFromJson(json);
}
