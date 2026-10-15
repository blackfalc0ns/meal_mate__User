import 'package:json_annotation/json_annotation.dart';

part 'family_member_permissions_response_dto.g.dart';

@JsonSerializable()
class FamilyMemberPermissionsResponseDto {
  const FamilyMemberPermissionsResponseDto({
    this.memberId,
    this.editDailyMeals,
    this.changeDeliveryTime,
    this.viewProgram,
    this.changeProgram,
    this.editMealsAndDays,
    this.editAddress,
    this.unitExchange,
    this.changePassword,
    this.groups,
    this.version,
  });
  final String? memberId;
  final bool? editDailyMeals;
  final bool? changeDeliveryTime;
  final bool? viewProgram;
  final bool? changeProgram;
  final bool? editMealsAndDays;
  final bool? editAddress;
  final bool? unitExchange;
  final bool? changePassword;
  final List<FamilyPermissionGroupResponseDto>? groups;
  @JsonKey(readValue: _readVersion)
  final int? version;
  factory FamilyMemberPermissionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyMemberPermissionsResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$FamilyMemberPermissionsResponseDtoToJson(this);
}

Object? _readVersion(Map json, String key) {
  return json['version'] ?? json['currentVersion'];
}

@JsonSerializable()
class FamilyPermissionGroupResponseDto {
  const FamilyPermissionGroupResponseDto({
    this.code,
    this.labelAr,
    this.labelEn,
    this.permissions,
  });
  final String? code;
  final String? labelAr;
  final String? labelEn;
  final List<FamilyPermissionItemResponseDto>? permissions;
  factory FamilyPermissionGroupResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyPermissionGroupResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$FamilyPermissionGroupResponseDtoToJson(this);
}

@JsonSerializable()
class FamilyPermissionItemResponseDto {
  const FamilyPermissionItemResponseDto({
    this.key,
    this.labelAr,
    this.labelEn,
    this.descriptionAr,
    this.descriptionEn,
    this.value,
    this.isSupported,
    this.isManagerConfigurable,
    this.requiredPermissions,
  });
  final String? key;
  final String? labelAr;
  final String? labelEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final bool? value;
  final bool? isSupported;
  final bool? isManagerConfigurable;
  final List<String>? requiredPermissions;

  String localizedLabel(bool isArabic) {
    if (isArabic) {
      final ar = labelAr?.trim() ?? '';
      if (ar.isNotEmpty) return ar;
      final en = labelEn?.trim() ?? '';
      if (en.isNotEmpty) return en;
      return key ?? '';
    }
    final en = labelEn?.trim() ?? '';
    if (en.isNotEmpty) return en;
    final ar = labelAr?.trim() ?? '';
    if (ar.isNotEmpty) return ar;
    return key ?? '';
  }

  String localizedDescription(bool isArabic) {
    if (isArabic) {
      final ar = descriptionAr?.trim() ?? '';
      if (ar.isNotEmpty) return ar;
      return descriptionEn?.trim() ?? '';
    }
    final en = descriptionEn?.trim() ?? '';
    if (en.isNotEmpty) return en;
    return descriptionAr?.trim() ?? '';
  }

  factory FamilyPermissionItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyPermissionItemResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$FamilyPermissionItemResponseDtoToJson(this);
}
