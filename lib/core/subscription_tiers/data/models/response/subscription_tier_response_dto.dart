import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';

part 'subscription_tier_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTierResponseDto {
  const SubscriptionTierResponseDto({
    this.tier,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.descriptionAr,
    this.descriptionEn,
    this.restaurantCount,
    this.restaurants,
    this.durationDays,
    this.totalPrice,
    this.dailyPrice,
    this.priceDifference,
    this.currencyCode,
    this.selectionCount,
    this.isRecommended,
    this.includeFriday,
    this.fridayDays,
    this.totalServiceDays,
    this.fridayAvailability,
  });

  final String? tier;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final String? descriptionAr;
  final String? descriptionEn;
  final int? restaurantCount;
  final List<SubscriptionTierRestaurantResponseDto>? restaurants;
  final int? durationDays;
  final double? totalPrice;
  final double? dailyPrice;
  final double? priceDifference;
  final String? currencyCode;
  final int? selectionCount;
  final bool? isRecommended;
  final bool? includeFriday;
  final int? fridayDays;
  final int? totalServiceDays;
  final SubscriptionFridayAvailabilityResponseDto? fridayAvailability;

  factory SubscriptionTierResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTierResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionTierRestaurantResponseDto {
  const SubscriptionTierRestaurantResponseDto({
    this.restaurantId,
    this.logoUrl,
  });

  final String? restaurantId;
  final String? logoUrl;

  factory SubscriptionTierRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionTierRestaurantResponseDtoFromJson(json);
}
