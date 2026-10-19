import 'package:json_annotation/json_annotation.dart';

part 'validate_discount_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ValidateDiscountResponseDto {
  const ValidateDiscountResponseDto({
    this.isValid,
    this.code,
    this.codeType,
    this.calculatedDiscountKwd,
    this.calculatedDiscountAmount,
    this.discountPercent,
    this.discountPercentage,
    this.discountAmount,
    this.eligibilityCode,
    this.failureReason,
    this.failureMessageAr,
    this.failureMessageEn,
    this.messageAr,
    this.messageEn,
    this.offerId,
    this.offerName,
  });

  final bool? isValid;
  final String? code;
  final String? codeType;
  final double? calculatedDiscountKwd;
  final double? calculatedDiscountAmount;
  final double? discountPercent;
  final double? discountPercentage;
  final double? discountAmount;
  final String? eligibilityCode;
  final String? failureReason;
  final String? failureMessageAr;
  final String? failureMessageEn;
  final String? messageAr;
  final String? messageEn;
  final String? offerId;
  final String? offerName;

  double get resolvedDiscountAmount =>
      calculatedDiscountKwd ??
      calculatedDiscountAmount ??
      discountAmount ??
      0.0;

  double? get resolvedDiscountPercent => discountPercent ?? discountPercentage;

  String? get resolvedMessageAr => failureMessageAr ?? messageAr;
  String? get resolvedMessageEn => failureMessageEn ?? messageEn;

  factory ValidateDiscountResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateDiscountResponseDtoFromJson(json);
}
