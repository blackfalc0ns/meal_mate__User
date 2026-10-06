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
    this.paymentMethods,
  });

  final bool? canUpgrade;
  final String? unavailableReason;
  final String? currentTier;
  final int? remainingServiceDays;
  final int? totalServiceDays;
  final String? upgradeEndpoint;
  final List<SubscriptionUpgradeOptionResponseDto>? options;
  final List<SubscriptionUpgradePaymentMethodResponseDto>? paymentMethods;

  factory SubscriptionUpgradeOptionsResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradeOptionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradeOptionsResponseDtoToJson(this);
}

@JsonSerializable()
class SubscriptionUpgradePaymentMethodResponseDto {
  const SubscriptionUpgradePaymentMethodResponseDto({
    this.id,
    this.paymentMethodId,
    this.code,
    this.name,
    this.nameAr,
    this.nameEn,
    this.integrationType,
    this.serviceCharge,
    this.totalAmount,
    this.currencyCode,
    this.isAvailable,
    this.unavailableReason,
    this.imageUrl,
  });

  final int? id;
  final int? paymentMethodId;
  final String? code;
  final String? name;
  final String? nameAr;
  final String? nameEn;
  final String? integrationType;
  final double? serviceCharge;
  final double? totalAmount;
  final String? currencyCode;
  final bool? isAvailable;
  final String? unavailableReason;
  final String? imageUrl;

  factory SubscriptionUpgradePaymentMethodResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionUpgradePaymentMethodResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SubscriptionUpgradePaymentMethodResponseDtoToJson(this);
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
