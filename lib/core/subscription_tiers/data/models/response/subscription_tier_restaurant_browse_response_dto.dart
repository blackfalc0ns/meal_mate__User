import 'package:json_annotation/json_annotation.dart';

part 'subscription_tier_restaurant_browse_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTierRestaurantBrowseResponseDto {
  const SubscriptionTierRestaurantBrowseResponseDto({
    this.restaurantId,
    this.name,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.rating,
    this.mealCount,
    this.bundleMealCount,
    this.tier,
    this.tierName,
    this.tierNameAr,
    this.tierNameEn,
    this.tierLogoUrl,
    this.classifications,
  });

  final String? restaurantId;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final double? rating;
  final int? mealCount;
  final int? bundleMealCount;
  final String? tier;
  final String? tierName;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? tierLogoUrl;
  final List<SubscriptionTierRestaurantClassificationResponseDto>?
  classifications;

  factory SubscriptionTierRestaurantBrowseResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionTierRestaurantBrowseResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionTierRestaurantClassificationResponseDto {
  const SubscriptionTierRestaurantClassificationResponseDto({
    this.logoUrl,
    this.tier,
  });

  final String? logoUrl;
  final String? tier;

  factory SubscriptionTierRestaurantClassificationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionTierRestaurantClassificationResponseDtoFromJson(json);
}
