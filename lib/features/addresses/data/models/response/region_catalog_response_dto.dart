import 'package:json_annotation/json_annotation.dart';

part 'region_catalog_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class RegionCatalogResponseDto {
  const RegionCatalogResponseDto({
    this.id,
    this.code,
    this.nameAr,
    this.nameEn,
    this.regions,
  });

  final String? id;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final List<LocationRegionResponseDto>? regions;

  factory RegionCatalogResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegionCatalogResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class LocationRegionResponseDto {
  const LocationRegionResponseDto({
    this.id,
    this.countryId,
    this.code,
    this.nameAr,
    this.nameEn,
    this.type,
    this.parentId,
    this.isActive,
  });

  final String? id;
  final String? countryId;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final int? type;
  final String? parentId;
  final bool? isActive;

  factory LocationRegionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LocationRegionResponseDtoFromJson(json);
}
