import 'package:json_annotation/json_annotation.dart';

part 'locations_catalog_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class LocationsCatalogResponseDto {
  const LocationsCatalogResponseDto({
    this.countryId,
    this.countryCode,
    this.governorates,
  });

  final String? countryId;
  final String? countryCode;
  final List<LocationGovernorateResponseDto>? governorates;

  factory LocationsCatalogResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LocationsCatalogResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class LocationGovernorateResponseDto {
  const LocationGovernorateResponseDto({
    this.id,
    this.code,
    this.nameAr,
    this.nameEn,
    this.areas,
  });

  final String? id;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final List<LocationAreaResponseDto>? areas;

  factory LocationGovernorateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LocationGovernorateResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class LocationAreaResponseDto {
  const LocationAreaResponseDto({
    this.id,
    this.code,
    this.nameAr,
    this.nameEn,
    this.blocks,
  });

  final String? id;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final List<LocationBlockResponseDto>? blocks;

  factory LocationAreaResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LocationAreaResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class LocationBlockResponseDto {
  const LocationBlockResponseDto({
    this.id,
    this.code,
    this.nameAr,
    this.nameEn,
  });

  final String? id;
  final String? code;
  final String? nameAr;
  final String? nameEn;

  factory LocationBlockResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LocationBlockResponseDtoFromJson(json);
}
