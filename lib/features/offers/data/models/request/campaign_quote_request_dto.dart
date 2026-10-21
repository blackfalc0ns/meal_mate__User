import 'package:json_annotation/json_annotation.dart';
part 'campaign_quote_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class CampaignQuoteRequestDto {
  const CampaignQuoteRequestDto({
    required this.customerId,
    required this.campaignId,
    required this.programId,
    required this.campaignBundleId,
    required this.durationDays,
    required this.startDate,
    required this.addressId,
    this.promoCode,
  });
  final String customerId;
  final String campaignId;
  final String programId;
  final String campaignBundleId;
  final int durationDays;
  final String startDate;
  final String addressId;
  final String? promoCode;
  Map<String, dynamic> toJson() => _$CampaignQuoteRequestDtoToJson(this);
}
