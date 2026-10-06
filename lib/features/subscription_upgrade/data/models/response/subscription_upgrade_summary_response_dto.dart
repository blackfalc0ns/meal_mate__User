import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';

part 'subscription_upgrade_summary_response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class SubscriptionUpgradeSummaryResponseDto {
  const SubscriptionUpgradeSummaryResponseDto({
    this.subscriptionId,
    this.currentTier,
    this.targetTier,
    this.currentTierRestaurants,
    this.targetTierRestaurants,
    this.newlyAddedRestaurants,
    this.effectiveFromDate,
    this.effectiveNoticeAr,
    this.effectiveNoticeEn,
    this.restaurantRepetition,
    this.currentRemainingCredit,
    this.targetRemainingPrice,
    this.priceDifference,
    this.currencyCode,
    this.remainingServiceDays,
    this.totalServiceDays,
    this.paymentMethods,
    this.upgradeEndpoint,
  });

  final String? subscriptionId;
  final SubscriptionUpgradeTierResponseDto? currentTier;
  final SubscriptionUpgradeTierResponseDto? targetTier;
  final List<SubscriptionUpgradeRestaurantResponseDto>? currentTierRestaurants;
  final List<SubscriptionUpgradeRestaurantResponseDto>? targetTierRestaurants;
  final List<SubscriptionUpgradeRestaurantResponseDto>? newlyAddedRestaurants;
  final String? effectiveFromDate;
  final String? effectiveNoticeAr;
  final String? effectiveNoticeEn;
  final SubscriptionUpgradeRestaurantRepetitionResponseDto?
  restaurantRepetition;
  final double? currentRemainingCredit;
  final double? targetRemainingPrice;
  final double? priceDifference;
  final String? currencyCode;
  final int? remainingServiceDays;
  final int? totalServiceDays;
  final List<SubscriptionUpgradePaymentMethodResponseDto>? paymentMethods;
  final String? upgradeEndpoint;

  factory SubscriptionUpgradeSummaryResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeSummaryResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeSummaryResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionUpgradeTierResponseDto {
  const SubscriptionUpgradeTierResponseDto({
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.logoUrl,
    this.accessibleRestaurantCount,
  });

  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? logoUrl;
  final int? accessibleRestaurantCount;

  factory SubscriptionUpgradeTierResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeTierResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeTierResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionUpgradeRestaurantResponseDto {
  const SubscriptionUpgradeRestaurantResponseDto({
    this.id,
    this.nameAr,
    this.nameEn,
    this.logoUrl,
    this.rating,
    this.tier,
  });

  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? logoUrl;
  final double? rating;
  final String? tier;

  factory SubscriptionUpgradeRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeRestaurantResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeRestaurantResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionUpgradeRestaurantRepetitionResponseDto {
  const SubscriptionUpgradeRestaurantRepetitionResponseDto({
    this.limit,
    this.restaurantCount,
    this.durationDays,
  });

  final int? limit;
  final int? restaurantCount;
  final int? durationDays;

  factory SubscriptionUpgradeRestaurantRepetitionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeRestaurantRepetitionResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeRestaurantRepetitionResponseDtoToJson(this);
}
