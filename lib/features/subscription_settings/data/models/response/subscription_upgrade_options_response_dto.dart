import 'package:json_annotation/json_annotation.dart';

part 'subscription_upgrade_options_response_dto.g.dart';

@JsonSerializable()
class SubscriptionUpgradeOptionsResponseDto {
  const SubscriptionUpgradeOptionsResponseDto({
    this.canUpgrade,
    this.unavailableReason,
    this.currentTier,
    this.remainingServiceDays,
    this.totalServiceDays,
    this.upgradeEndpoint,
    this.options,
  });

  final bool? canUpgrade;
  final String? unavailableReason;
  final String? currentTier;
  final int? remainingServiceDays;
  final int? totalServiceDays;
  final String? upgradeEndpoint;
  final List<SubscriptionUpgradeOptionResponseDto>? options;

  factory SubscriptionUpgradeOptionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeOptionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeOptionsResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionUpgradeOptionResponseDto {
  const SubscriptionUpgradeOptionResponseDto({
    this.targetTier,
    this.tierNameAr,
    this.tierNameEn,
    this.logoUrl,
    this.isCurrent,
    this.selectable,
    this.accessibleRestaurantCount,
    this.currentRemainingCredit,
    this.targetRemainingPrice,
    this.gatewayRecovery,
    this.priceDifference,
    this.currencyCode,
  });

  final String? targetTier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? logoUrl;
  final bool? isCurrent;
  final bool? selectable;
  final int? accessibleRestaurantCount;
  final double? currentRemainingCredit;
  final double? targetRemainingPrice;
  final double? gatewayRecovery;
  final double? priceDifference;
  final String? currencyCode;

  factory SubscriptionUpgradeOptionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeOptionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeOptionResponseDtoToJson(this);
}
