import 'package:json_annotation/json_annotation.dart';

part 'family_size_package_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilySizePackageResponseDto {
  const FamilySizePackageResponseDto({
    this.id,
    this.nameAr,
    this.nameEn,
    this.minMembers,
    this.maxMembers,
    this.discountPercent,
    this.sortOrder,
    this.imageStorageKey,
    this.imageUrl,
  });

  final String? id;
  final String? nameAr;
  final String? nameEn;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? minMembers;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? maxMembers;
  final double? discountPercent;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? sortOrder;
  final String? imageStorageKey;
  final String? imageUrl;

  factory FamilySizePackageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySizePackageResponseDtoFromJson(json);
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
