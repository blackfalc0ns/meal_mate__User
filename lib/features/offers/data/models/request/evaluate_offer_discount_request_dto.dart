import 'package:json_annotation/json_annotation.dart';

part 'evaluate_offer_discount_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class EvaluateOfferDiscountRequestDto {
  const EvaluateOfferDiscountRequestDto({
    this.offerId,
    required this.customerId,
    this.cartAmount = 0.0,
    this.durationDays = 26,
    this.deliveryGovernorate,
    this.programId,
    this.bundleId,
    this.restaurantId,
    this.hasPromoCode = false,
    this.promoCode,
  });

  final String? offerId;
  final String customerId;
  final double cartAmount;
  final int durationDays;
  final String? deliveryGovernorate;
  final String? programId;
  final String? bundleId;
  final String? restaurantId;
  final bool hasPromoCode;
  final String? promoCode;

  Map<String, dynamic> toJson() =>
      _$EvaluateOfferDiscountRequestDtoToJson(this);
}
