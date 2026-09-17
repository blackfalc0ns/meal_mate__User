import 'package:json_annotation/json_annotation.dart';

part 'address_coverage_preview_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class AddressCoveragePreviewRequestDto {
  const AddressCoveragePreviewRequestDto({
    this.regionId,
    this.blockRegionId,
    this.latitude,
    this.longitude,
    this.governorate,
    this.area,
    this.block,
    this.isDefault = true,
    this.page,
    this.pageSize,
  });

  final String? regionId;
  final String? blockRegionId;
  final double? latitude;
  final double? longitude;
  final String? governorate;
  final String? area;
  final String? block;
  final bool isDefault;
  final int? page;
  final int? pageSize;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'regionId': regionId,
    'blockRegionId': blockRegionId,
    'latitude': latitude,
    'longitude': longitude,
    'governorate': governorate,
    'area': area,
    'block': block,
    'isDefault': isDefault,
    if (page != null) 'page': page,
    if (pageSize != null) 'pageSize': pageSize,
  };
}
