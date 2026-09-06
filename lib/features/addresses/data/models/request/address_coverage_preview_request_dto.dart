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
  });

  final String? regionId;
  final String? blockRegionId;
  final double? latitude;
  final double? longitude;
  final String? governorate;
  final String? area;
  final String? block;
  final bool isDefault;

  Map<String, dynamic> toJson() =>
      _$AddressCoveragePreviewRequestDtoToJson(this);
}
