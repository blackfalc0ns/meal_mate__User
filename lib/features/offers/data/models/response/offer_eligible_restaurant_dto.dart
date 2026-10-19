import 'package:json_annotation/json_annotation.dart';

part 'offer_eligible_restaurant_dto.g.dart';

@JsonSerializable(createToJson: false)
class OfferEligibleRestaurantDto {
  const OfferEligibleRestaurantDto({
    this.id,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.rating,
  });

  final dynamic id;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final double? rating;

  factory OfferEligibleRestaurantDto.fromJson(Map<String, dynamic> json) =>
      _$OfferEligibleRestaurantDtoFromJson(json);
}
