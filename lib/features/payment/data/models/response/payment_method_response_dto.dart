import 'package:json_annotation/json_annotation.dart';

part 'payment_method_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class PaymentMethodResponseDto {
  const PaymentMethodResponseDto({
    this.id,
    this.paymentMethodId,
    this.code,
    this.name,
    this.nameAr,
    this.nameEn,
    this.title,
    this.titleAr,
    this.titleEn,
    this.description,
    this.descriptionAr,
    this.descriptionEn,
    this.isAvailable,
    this.walletBalance,
  });

  final int? id;
  final int? paymentMethodId;
  final String? code;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? title;
  final String? titleAr;
  final String? titleEn;
  final String? description;
  final String? descriptionAr;
  final String? descriptionEn;
  final bool? isAvailable;
  final double? walletBalance;

  factory PaymentMethodResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodResponseDtoFromJson(json);
}
