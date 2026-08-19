import 'package:json_annotation/json_annotation.dart';

part 'family_payment_method_response_dto.g.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

@JsonSerializable(createToJson: false)
class FamilyPaymentMethodResponseDto {
  const FamilyPaymentMethodResponseDto({
    this.paymentMethodId,
    this.code,
    this.nameAr,
    this.nameEn,
    this.integrationType,
    this.isAvailable,
    this.unavailableReason,
  });

  @JsonKey(fromJson: _parseInt)
  final int? paymentMethodId;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? integrationType;
  final bool? isAvailable;
  final String? unavailableReason;

  factory FamilyPaymentMethodResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyPaymentMethodResponseDtoFromJson(json);
}
