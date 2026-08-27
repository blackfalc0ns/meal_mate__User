import 'package:json_annotation/json_annotation.dart';

part 'customer_address_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CustomerAddressResponseDto {
  const CustomerAddressResponseDto({
    this.addressId,
    this.id,
    this.label,
    this.addressLine,
    this.regionId,
    this.governorate,
    this.area,
    this.block,
    this.blockRegionId,
    this.street,
    this.building,
    this.unit,
    this.floor,
    this.latitude,
    this.longitude,
    this.notes,
    this.isDefault,
    this.isDeliveryActive,
    this.deliveryEffectiveFromUtc,
    this.deliveryChangeNotice,
    this.notifyOnDelivery,
  });

  final String? addressId;
  final String? id;
  final String? label;
  final String? addressLine;
  final String? regionId;
  final String? governorate;
  final String? area;
  final String? block;
  final String? blockRegionId;
  final String? street;
  final String? building;
  final String? unit;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool? isDefault;
  final bool? isDeliveryActive;
  final DateTime? deliveryEffectiveFromUtc;
  final String? deliveryChangeNotice;
  final bool? notifyOnDelivery;

  factory CustomerAddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressResponseDtoFromJson(json);
}
