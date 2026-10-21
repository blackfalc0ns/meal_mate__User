import 'package:json_annotation/json_annotation.dart';

part 'create_campaign_checkout_session_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class CreateCampaignCheckoutSessionRequestDto {
  const CreateCampaignCheckoutSessionRequestDto({
    this.idempotencyKey,
    this.quoteId,
    required this.campaignId,
    required this.bundleId,
    required this.customerId,
    required this.durationDays,
    this.requestedServiceDates,
    this.deliveryGovernorate,
  });

  final String? idempotencyKey;
  final String? quoteId;
  final String campaignId;
  final String bundleId;
  final String customerId;
  final int durationDays;
  final List<String>? requestedServiceDates;
  final String? deliveryGovernorate;

  Map<String, dynamic> toJson() =>
      _$CreateCampaignCheckoutSessionRequestDtoToJson(this);
}
