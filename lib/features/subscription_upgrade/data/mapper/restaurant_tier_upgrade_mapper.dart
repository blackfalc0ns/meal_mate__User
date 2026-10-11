import 'package:meal_meat_user/features/subscription_upgrade/data/models/request/subscription_upgrade_request_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_request_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_status_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';

extension SubscriptionUpgradeOptionsResponseDtoMapper
    on SubscriptionUpgradeOptionsResponseDto {
  SubscriptionUpgradeOptionsEntity toEntity() {
    return SubscriptionUpgradeOptionsEntity(
      canUpgrade: canUpgrade ?? false,
      unavailableReason: unavailableReason,
      currentTier: currentTier ?? 'Basic',
      remainingServiceDays: remainingServiceDays ?? 0,
      totalServiceDays: totalServiceDays ?? 0,
      upgradeEndpoint: upgradeEndpoint ?? '',
      options: (options ?? const [])
          .map((option) => option.toEntity())
          .toList(),
      paymentMethods: (paymentMethods ?? const [])
          .map((method) => method.toEntity())
          .where((method) => method.id > 0)
          .toList(),
    );
  }
}

extension SubscriptionUpgradePaymentMethodResponseDtoMapper
    on SubscriptionUpgradePaymentMethodResponseDto {
  SubscriptionUpgradePaymentMethodEntity toEntity() {
    return SubscriptionUpgradePaymentMethodEntity(
      id: paymentMethodId ?? id ?? 0,
      code: code ?? '',
      title: nameAr ?? nameEn ?? name ?? '',
      integrationType: integrationType ?? '',
      serviceCharge: serviceCharge,
      totalAmount: totalAmount,
      currencyCode: currencyCode ?? 'KWD',
      isAvailable: isAvailable ?? false,
      unavailableReason: unavailableReason,
      imageUrl: imageUrl,
    );
  }
}

extension SubscriptionUpgradeOptionResponseDtoMapper
    on SubscriptionUpgradeOptionResponseDto {
  SubscriptionUpgradeOptionEntity toEntity() {
    return SubscriptionUpgradeOptionEntity(
      targetTier: targetTier ?? '',
      tierNameAr: tierNameAr ?? '',
      tierNameEn: tierNameEn ?? '',
      logoUrl: logoUrl,
      isCurrent: isCurrent ?? false,
      selectable: selectable ?? false,
      accessibleRestaurantCount: accessibleRestaurantCount ?? 0,
      currentRemainingCredit: currentRemainingCredit ?? 0.0,
      targetRemainingPrice: targetRemainingPrice ?? 0.0,
      gatewayRecovery: gatewayRecovery ?? 0.0,
      priceDifference: priceDifference ?? 0.0,
      currencyCode: currencyCode ?? 'KWD',
    );
  }
}

extension SubscriptionUpgradeTierResponseDtoMapper
    on SubscriptionUpgradeTierResponseDto {
  SubscriptionUpgradeTierEntity toEntity() {
    return SubscriptionUpgradeTierEntity(
      tier: tier ?? '',
      tierNameAr: tierNameAr ?? '',
      tierNameEn: tierNameEn ?? '',
      logoUrl: logoUrl,
      accessibleRestaurantCount: accessibleRestaurantCount ?? 0,
    );
  }
}

extension SubscriptionUpgradeRestaurantResponseDtoMapper
    on SubscriptionUpgradeRestaurantResponseDto {
  SubscriptionUpgradeRestaurantEntity toEntity() {
    return SubscriptionUpgradeRestaurantEntity(
      id: id ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl,
      rating: rating ?? 0,
      tier: tier ?? '',
    );
  }
}

extension SubscriptionUpgradeSummaryResponseDtoMapper
    on SubscriptionUpgradeSummaryResponseDto {
  SubscriptionUpgradeSummaryEntity toEntity() {
    return SubscriptionUpgradeSummaryEntity(
      subscriptionId: subscriptionId ?? '',
      currentTier:
          currentTier?.toEntity() ??
          const SubscriptionUpgradeTierEntity(
            tier: '',
            tierNameAr: '',
            tierNameEn: '',
            accessibleRestaurantCount: 0,
          ),
      targetTier:
          targetTier?.toEntity() ??
          const SubscriptionUpgradeTierEntity(
            tier: '',
            tierNameAr: '',
            tierNameEn: '',
            accessibleRestaurantCount: 0,
          ),
      currentTierRestaurants: (currentTierRestaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .where((restaurant) => restaurant.id.isNotEmpty)
          .toList(),
      targetTierRestaurants: (targetTierRestaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .where((restaurant) => restaurant.id.isNotEmpty)
          .toList(),
      newlyAddedRestaurants: (newlyAddedRestaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .where((restaurant) => restaurant.id.isNotEmpty)
          .toList(),
      effectiveFromDate: effectiveFromDate ?? '',
      effectiveNoticeAr: effectiveNoticeAr ?? '',
      effectiveNoticeEn: effectiveNoticeEn ?? '',
      restaurantRepetition: SubscriptionUpgradeRestaurantRepetitionEntity(
        limit: restaurantRepetition?.limit ?? 0,
        restaurantCount: restaurantRepetition?.restaurantCount ?? 0,
        durationDays: restaurantRepetition?.durationDays ?? 0,
      ),
      currentRemainingCredit: currentRemainingCredit ?? 0,
      targetRemainingPrice: targetRemainingPrice ?? 0,
      priceDifference: priceDifference ?? 0,
      currencyCode: currencyCode ?? 'KWD',
      remainingServiceDays: remainingServiceDays ?? 0,
      totalServiceDays: totalServiceDays ?? 0,
      paymentMethods: (paymentMethods ?? const [])
          .map((method) => method.toEntity())
          .where((method) => method.id > 0)
          .toList(),
      upgradeEndpoint: upgradeEndpoint ?? '',
    );
  }
}

extension SubscriptionUpgradeRequestEntityMapper
    on SubscriptionUpgradeRequestEntity {
  SubscriptionUpgradeRequestDto toDto() {
    return SubscriptionUpgradeRequestDto(
      targetTier: targetTier,
      callbackUrl: callbackUrl,
      errorUrl: errorUrl,
      paymentMethodId: paymentMethodId,
      reason: reason,
    );
  }
}

extension SubscriptionUpgradeRequestResponseDtoMapper
    on SubscriptionUpgradeRequestResponseDto {
  SubscriptionUpgradeRequestResultEntity toEntity() {
    return SubscriptionUpgradeRequestResultEntity(
      upgradeId: upgradeId ?? '',
      subscriptionId: subscriptionId ?? '',
      fromTier: fromTier ?? '',
      toTier: toTier ?? '',
      amount: amount ?? 0.0,
      currencyCode: currencyCode ?? 'KWD',
      paymentUrl: paymentUrl,
      isPaid: isPaid ?? false,
      status: status ?? '',
      remainingServiceDays: remainingServiceDays ?? 0,
    );
  }
}

extension SubscriptionUpgradeStatusResponseDtoMapper
    on SubscriptionUpgradeStatusResponseDto {
  SubscriptionUpgradeStatusEntity toEntity() {
    return SubscriptionUpgradeStatusEntity(
      upgradeId: upgradeId ?? '',
      subscriptionId: subscriptionId ?? '',
      fromTier: fromTier ?? '',
      toTier: toTier ?? '',
      amount: amount ?? 0.0,
      currencyCode: currencyCode ?? 'KWD',
      status: status ?? '',
      isPaid: isPaid ?? false,
      isFailed: isFailed ?? false,
      effectiveAtUtc: effectiveAtUtc,
      paymentUrl: paymentUrl,
    );
  }
}

abstract class RestaurantTierUpgradeMapper {
  static SubscriptionUpgradeOptionsEntity toOptionsEntity(
    SubscriptionUpgradeOptionsResponseDto dto,
  ) => dto.toEntity();

  static SubscriptionUpgradePaymentMethodEntity toPaymentMethodEntity(
    SubscriptionUpgradePaymentMethodResponseDto dto,
  ) => dto.toEntity();

  static SubscriptionUpgradeSummaryEntity toSummaryEntity(
    SubscriptionUpgradeSummaryResponseDto dto,
  ) => dto.toEntity();

  static SubscriptionUpgradeOptionEntity toOptionEntity(
    SubscriptionUpgradeOptionResponseDto dto,
  ) => dto.toEntity();

  static SubscriptionUpgradeRequestDto toRequestDto(
    SubscriptionUpgradeRequestEntity entity,
  ) => entity.toDto();

  static SubscriptionUpgradeRequestResultEntity toRequestResultEntity(
    SubscriptionUpgradeRequestResponseDto dto,
  ) => dto.toEntity();

  static SubscriptionUpgradeStatusEntity toStatusEntity(
    SubscriptionUpgradeStatusResponseDto dto,
  ) => dto.toEntity();
}
