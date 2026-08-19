import 'package:json_annotation/json_annotation.dart';

part 'family_checkout_response_dto.g.dart';

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@JsonSerializable(createToJson: false)
class FamilyCheckoutResponseDto {
  const FamilyCheckoutResponseDto({
    this.familyGroupId,
    this.paymentAnchorSubscriptionId,
    this.paymentUrl,
    this.holdExpiresAtUtc,
    this.finalPrice,
  });

  final String? familyGroupId;
  final String? paymentAnchorSubscriptionId;
  final String? paymentUrl;
  final String? holdExpiresAtUtc;
  @JsonKey(fromJson: _parseDouble)
  final double? finalPrice;

  factory FamilyCheckoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyCheckoutResponseDtoFromJson(json);
}
