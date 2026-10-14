import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_theme_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
part 'subscription_tier_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTierResponseDto {
  const SubscriptionTierResponseDto({
    this.tier,
    this.nameAr,
    this.nameEn,
    this.name,
    this.logoUrl,
    this.descriptionAr,
    this.descriptionEn,
    this.description,
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
    this.theme,
    this.availability,
    this.canSelect,
    this.isAvailable,
    this.disabledReason,
    this.option,
    this.durationPrices,
  });

  final String? tier;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final String? logoUrl;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? description;
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
  final SubscriptionTierThemeResponseDto? theme;
  final SubscriptionAvailabilityResponseDto? availability;
  final bool? canSelect;
  final bool? isAvailable;
  final String? disabledReason;
  final SubscriptionTierResponseDto? option;
  final List<DurationPriceResponseDto>? durationPrices;

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

@JsonSerializable(createToJson: false)
class SubscriptionFridayAvailabilityResponseDto {
  const SubscriptionFridayAvailabilityResponseDto({
    this.isAvailable,
    this.restaurantCount,
    this.code,
    this.messageAr,
    this.messageEn,
    this.message,
    this.displayType,
  });

  final bool? isAvailable;
  final int? restaurantCount;
  final String? code;
  final String? messageAr;
  final String? messageEn;
  final String? message;
  final String? displayType;

  factory SubscriptionFridayAvailabilityResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionFridayAvailabilityResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionTiersPageResponseDto {
  const SubscriptionTiersPageResponseDto({
    this.programId,
    this.bundleId,
    this.hasDeliveryAddress,
    this.periodContextComplete,
    this.pagination,
    this.items,
    this.tiers,
  });

  final String? programId;
  final String? bundleId;
  final bool? hasDeliveryAddress;
  final bool? periodContextComplete;
  final PaginationResponseDto? pagination;
  final List<SubscriptionTierResponseDto>? items;
  final List<SubscriptionTierResponseDto>? tiers;

  List<SubscriptionTierResponseDto> get effectiveTiers =>
      items ?? tiers ?? const [];

  factory SubscriptionTiersPageResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionTiersPageResponseDtoFromJson(json);
}

class DurationPriceResponseDto {
  const DurationPriceResponseDto({
    this.durationDays,
    this.totalPrice,
    this.dailyPrice,
    this.currencyCode,
  });

  final int? durationDays;
  final double? totalPrice;
  final double? dailyPrice;
  final String? currencyCode;

  factory DurationPriceResponseDto.fromJson(Map<String, dynamic> json) =>
      DurationPriceResponseDto(
        durationDays: (json['durationDays'] as num?)?.toInt(),
        totalPrice: (json['totalPrice'] as num?)?.toDouble(),
        dailyPrice: (json['dailyPrice'] as num?)?.toDouble(),
        currencyCode: json['currencyCode'] as String?,
      );
}

