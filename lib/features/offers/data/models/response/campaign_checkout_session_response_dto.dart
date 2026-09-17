import 'package:json_annotation/json_annotation.dart';

part 'campaign_checkout_session_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CampaignCheckoutSessionResponseDto {
  const CampaignCheckoutSessionResponseDto({
    this.sessionId,
    this.campaignId,
    this.bundleId,
    this.customerId,
    this.durationDays,
    this.finalCustomerPrice,
    this.currency,
    this.expiresAtUtc,
    this.status,
  });

  final String? sessionId;
  final String? campaignId;
  final String? bundleId;
  final String? customerId;
  final int? durationDays;
  final double? finalCustomerPrice;
  final String? currency;
  final String? expiresAtUtc;
  final String? status;

  factory CampaignCheckoutSessionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CampaignCheckoutSessionResponseDtoFromJson(json);
}
