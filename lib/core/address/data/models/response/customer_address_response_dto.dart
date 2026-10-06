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
    this.avenue,
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
    this.restaurantCoverageNotice,
    this.servingRestaurants,
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
  final String? avenue;
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
  @JsonKey(fromJson: _parseCoverageNotice)
  final CustomerAddressCoverageNoticeDto? restaurantCoverageNotice;
  @JsonKey(fromJson: _parseServingRestaurants)
  final List<ServingRestaurantDto>? servingRestaurants;

  static CustomerAddressCoverageNoticeDto? _parseCoverageNotice(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return CustomerAddressCoverageNoticeDto(ar: trimmed, en: trimmed);
    }
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      final ar =
          (map['ar'] as String?) ??
          (map['message'] as String?) ??
          (map['text'] as String?) ??
          (map['notice'] as String?);
      final en =
          (map['en'] as String?) ??
          (map['message'] as String?) ??
          (map['text'] as String?) ??
          (map['notice'] as String?);
      return CustomerAddressCoverageNoticeDto(ar: ar, en: en);
    }
    final str = value.toString().trim();
    return str.isEmpty
        ? null
        : CustomerAddressCoverageNoticeDto(ar: str, en: str);
  }

  static List<ServingRestaurantDto>? _parseServingRestaurants(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (e) => ServingRestaurantDto.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }
    return null;
  }

  factory CustomerAddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressResponseDtoFromJson(json);
}

class CustomerAddressCoverageNoticeDto {
  const CustomerAddressCoverageNoticeDto({this.ar, this.en});

  final String? ar;
  final String? en;

  factory CustomerAddressCoverageNoticeDto.fromJson(
    Map<String, dynamic> json,
  ) => CustomerAddressCoverageNoticeDto(
    ar:
        (json['ar'] as String?) ??
        (json['message'] as String?) ??
        (json['text'] as String?) ??
        (json['notice'] as String?),
    en:
        (json['en'] as String?) ??
        (json['message'] as String?) ??
        (json['text'] as String?) ??
        (json['notice'] as String?),
  );
}

class ServingRestaurantDto {
  const ServingRestaurantDto({
    this.id,
    this.nameAr,
    this.nameEn,
    this.name,
    this.logoUrl,
    this.rating,
  });

  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final String? logoUrl;
  final double? rating;

  factory ServingRestaurantDto.fromJson(Map<String, dynamic> json) =>
      ServingRestaurantDto(
        id: json['id'] as String?,
        nameAr:
            (json['nameAr'] as String?) ??
            (json['name'] as String?) ??
            (json['name_ar'] as String?),
        nameEn:
            (json['nameEn'] as String?) ??
            (json['name'] as String?) ??
            (json['name_en'] as String?),
        name: json['name'] as String?,
        logoUrl: (json['logoUrl'] as String?) ?? (json['logo'] as String?),
        rating: (json['rating'] as num?)?.toDouble(),
      );
}
