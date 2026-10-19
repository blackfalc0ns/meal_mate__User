import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';

part 'offers_hub_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class OffersHubResponseDto {
  const OffersHubResponseDto({
    this.heroOffers,
    this.availableOffers,
    this.savedOffers,
    this.serverTimeUtc,
  });

  final List<OfferResponseDto>? heroOffers;
  final List<OfferResponseDto>? availableOffers;
  final List<OfferResponseDto>? savedOffers;
  final String? serverTimeUtc;

  factory OffersHubResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OffersHubResponseDtoFromJson(json);
}
