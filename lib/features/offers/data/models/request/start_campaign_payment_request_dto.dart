import 'package:json_annotation/json_annotation.dart';

part 'start_campaign_payment_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class StartCampaignPaymentRequestDto {
  const StartCampaignPaymentRequestDto({
    required this.idempotencyKey,
    required this.callbackUrl,
    required this.errorUrl,
    this.paymentMethodId = 3,
  });

  final String idempotencyKey;
  final String callbackUrl;
  final String errorUrl;
  final int? paymentMethodId;

  Map<String, dynamic> toJson() => _$StartCampaignPaymentRequestDtoToJson(this);
}
