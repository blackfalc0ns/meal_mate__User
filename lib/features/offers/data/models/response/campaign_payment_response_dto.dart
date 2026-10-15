import 'package:json_annotation/json_annotation.dart';

part 'campaign_payment_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CampaignPaymentResponseDto {
  const CampaignPaymentResponseDto({
    this.sessionId,
    this.paymentId,
    this.paymentUrl,
    this.amount,
    this.currency,
    this.status,
    this.expiresAtUtc,
    this.isPaid,
    this.isFailed,
    this.subscriptionId,
  });

  final String? sessionId;
  final String? paymentId;
  final String? paymentUrl;
  final double? amount;
  final String? currency;
  final String? status;
  final String? expiresAtUtc;
  final bool? isPaid;
  final bool? isFailed;
  final String? subscriptionId;

  factory CampaignPaymentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CampaignPaymentResponseDtoFromJson(json);
}
