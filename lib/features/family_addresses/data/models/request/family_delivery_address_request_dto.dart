import 'package:json_annotation/json_annotation.dart';

part 'family_delivery_address_request_dto.g.dart';

@JsonSerializable()
class FamilyDeliveryAddressRequestDto {
  const FamilyDeliveryAddressRequestDto({
    required this.addressId,
    required this.effectiveFromDate,
    required this.expectedVersion,
  });

  final String addressId;
  final String effectiveFromDate;
  final int expectedVersion;

  factory FamilyDeliveryAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyDeliveryAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyDeliveryAddressRequestDtoToJson(this);
}
