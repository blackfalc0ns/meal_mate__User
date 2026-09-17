import 'package:json_annotation/json_annotation.dart';

part 'evaluate_offer_discount_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class EvaluateOfferDiscountResponseDto {
  const EvaluateOfferDiscountResponseDto({
    this.offerId,
    this.offerName,
    this.isEligible,
    this.isApplicable,
    this.calculatedDiscountAmount,
    this.calculatedDiscountKwd,
    this.finalAmountKwd,
    this.ineligibilityReasons,
    this.reasonIfFailed,
    this.allowPromoCodeStacking,
  });

  final String? offerId;
  final String? offerName;
  final bool? isEligible;
  final bool? isApplicable;
  final double? calculatedDiscountAmount;
  final double? calculatedDiscountKwd;
  final double? finalAmountKwd;
  final List<String>? ineligibilityReasons;
  final String? reasonIfFailed;
  final bool? allowPromoCodeStacking;

  factory EvaluateOfferDiscountResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$EvaluateOfferDiscountResponseDtoFromJson(json);
}
