import 'package:json_annotation/json_annotation.dart';

part 'subscription_pricing_preview_request_dto.g.dart';

@JsonSerializable()
class SubscriptionPricingPreviewRequestDto {
  const SubscriptionPricingPreviewRequestDto({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    this.offerId,
    this.promoCode,
    this.includeFriday = false,
    this.fridayDays = 0,
  });

  final dynamic programId;
  final dynamic bundleId;
  final dynamic tier;
  final int durationDays;
  final String? offerId;
  final String? promoCode;
  final bool includeFriday;
  final int? fridayDays;

  Map<String, dynamic> toJson() =>
      _$SubscriptionPricingPreviewRequestDtoToJson(this);

  factory SubscriptionPricingPreviewRequestDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SubscriptionPricingPreviewRequestDtoFromJson(json);
}
