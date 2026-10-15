import 'package:json_annotation/json_annotation.dart';

part 'family_delivery_address_response_dto.g.dart';

@JsonSerializable()
class FamilyDeliveryAddressSnapshotResponseDto {
  const FamilyDeliveryAddressSnapshotResponseDto({
    this.subscriptionId,
    this.currentVersion,
    this.acceptedAddress,
    this.eligibleAddresses,
  });

  final String? subscriptionId;
  final int? currentVersion;
  final CustomerActiveDeliveryAddressDto? acceptedAddress;
  final List<FamilyDeliveryAddressChoiceDto>? eligibleAddresses;

  factory FamilyDeliveryAddressSnapshotResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyDeliveryAddressSnapshotResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyDeliveryAddressSnapshotResponseDtoToJson(this);
}

@JsonSerializable()
class FamilyDeliveryAddressChoiceDto {
  const FamilyDeliveryAddressChoiceDto({
    this.id,
    this.label,
    this.addressLine,
    this.regionId,
  });

  final String? id;
  final String? label;
  final String? addressLine;
  final String? regionId;

  factory FamilyDeliveryAddressChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyDeliveryAddressChoiceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyDeliveryAddressChoiceDtoToJson(this);
}

@JsonSerializable()
class CustomerActiveDeliveryAddressDto {
  const CustomerActiveDeliveryAddressDto({
    this.id,
    this.label,
    this.addressLine,
  });

  final String? id;
  final String? label;
  final String? addressLine;

  factory CustomerActiveDeliveryAddressDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CustomerActiveDeliveryAddressDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CustomerActiveDeliveryAddressDtoToJson(this);
}

@JsonSerializable()
class FamilyDeliveryAddressResultResponseDto {
  const FamilyDeliveryAddressResultResponseDto({
    this.subscriptionId,
    this.version,
    this.amendmentId,
    this.effectiveFromDate,
    this.affectedDayIds,
    this.skippedDayIds,
  });

  final String? subscriptionId;
  final int? version;
  final String? amendmentId;
  final String? effectiveFromDate;
  final List<String>? affectedDayIds;
  final List<String>? skippedDayIds;

  factory FamilyDeliveryAddressResultResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyDeliveryAddressResultResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyDeliveryAddressResultResponseDtoToJson(this);
}
