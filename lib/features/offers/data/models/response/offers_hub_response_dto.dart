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
    this.offers,
    this.serverNowUtc,
  });

  final List<OfferResponseDto>? heroOffers;
  final List<OfferResponseDto>? availableOffers;
  final List<OfferResponseDto>? savedOffers;
  final String? serverTimeUtc;
  final List<OfferResponseDto>? offers;
  final String? serverNowUtc;

  List<OfferResponseDto> get resolvedAvailableOffers =>
      availableOffers ?? offers ?? const [];

  List<OfferResponseDto> get resolvedHeroOffers {
    if (heroOffers != null && heroOffers!.isNotEmpty) {
      return heroOffers!;
    }
    final all = resolvedAvailableOffers;
    final withBanner = all
        .where((o) => o.bannerImageUrl != null && o.bannerImageUrl!.isNotEmpty)
        .toList();
    if (withBanner.isNotEmpty) return withBanner;
    return all.isNotEmpty ? [all.first] : const [];
  }

  String? get resolvedServerTimeUtc => serverNowUtc ?? serverTimeUtc;

  factory OffersHubResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OffersHubResponseDtoFromJson(json);
}
