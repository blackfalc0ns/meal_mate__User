import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';

part 'address_coverage_preview_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class AddressCoveragePreviewResponseDto {
  const AddressCoveragePreviewResponseDto({
    this.canSetAsDefault = true,
    this.isCurrentSubscriptionRestaurantCovered = true,
    this.uncoveredRestaurantNameAr,
    this.uncoveredRestaurantNameEn,
    this.conflictMessage,
    this.resolvedRegionId,
    this.resolvedRegionNameAr,
    this.resolvedRegionNameEn,
    this.governorate,
    this.area,
    this.block,
    this.latitude,
    this.longitude,
    this.hasActiveSubscription = false,
    this.restaurantCoverageNotice,
    this.servingRestaurants = const [],
  });

  final bool canSetAsDefault;
  final bool isCurrentSubscriptionRestaurantCovered;
  final String? uncoveredRestaurantNameAr;
  final String? uncoveredRestaurantNameEn;
  final String? conflictMessage;
  final String? resolvedRegionId;
  final String? resolvedRegionNameAr;
  final String? resolvedRegionNameEn;
  final String? governorate;
  final String? area;
  final String? block;
  final double? latitude;
  final double? longitude;
  final bool hasActiveSubscription;
  @JsonKey(fromJson: _parseCoverageNotice)
  final CustomerAddressCoverageNoticeDto? restaurantCoverageNotice;
  @JsonKey(fromJson: _parseServingRestaurants)
  final List<ServingRestaurantDto> servingRestaurants;

  static CustomerAddressCoverageNoticeDto? _parseCoverageNotice(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return CustomerAddressCoverageNoticeDto.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    final str = value.toString().trim();
    return str.isEmpty
        ? null
        : CustomerAddressCoverageNoticeDto(ar: str, en: str);
  }

  static List<ServingRestaurantDto> _parseServingRestaurants(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (e) => ServingRestaurantDto.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }
    return const [];
  }

  factory AddressCoveragePreviewResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$AddressCoveragePreviewResponseDtoFromJson(json);
}
