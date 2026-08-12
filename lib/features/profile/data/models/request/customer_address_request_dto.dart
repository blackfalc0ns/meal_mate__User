import 'package:json_annotation/json_annotation.dart';

part 'customer_address_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class CustomerAddressRequestDto {
  const CustomerAddressRequestDto({
    required this.label,
    required this.addressLine,
    this.regionId,
    this.governorate,
    this.area,
    this.block,
    this.street,
    this.building,
    this.unit,
    this.floor,
    this.latitude,
    this.longitude,
    this.notes,
    required this.isDefault,
    required this.notifyOnDelivery,
  });

  final String label;
  final String addressLine;
  final String? regionId;
  final String? governorate;
  final String? area;
  final String? block;
  final String? street;
  final String? building;
  final String? unit;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool isDefault;
  final bool notifyOnDelivery;

  Map<String, dynamic> toJson() => _$CustomerAddressRequestDtoToJson(this);
}
