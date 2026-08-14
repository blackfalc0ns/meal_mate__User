import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

extension SubscriptionSummaryResponseDtoMapper
    on SubscriptionSummaryResponseDto {
  SubscriptionSummaryEntity toEntity() {
    return SubscriptionSummaryEntity(
      programId: programId ?? '',
      programNameAr: programNameAr ?? '',
      programNameEn: programNameEn ?? '',
      bundleId: bundleId ?? '',
      bundleNameAr: bundleNameAr ?? '',
      bundleNameEn: bundleNameEn ?? '',
      imageUrl: imageUrl,
      restaurantId: restaurantId,
      restaurantNameAr: restaurantNameAr,
      restaurantNameEn: restaurantNameEn,
      restaurantCount: restaurantCount ?? 0,
      tier: tier ?? '',
      durationDays: durationDays ?? 0,
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      serviceDates: serviceDates ?? const [],
      slotRequirements: (slotRequirements ?? const [])
          .map((requirement) => requirement.toEntity())
          .toList(),
      basePrice: basePrice ?? 0,
      campaignDiscount: campaignDiscount ?? 0,
      promoDiscount: promoDiscount ?? 0,
      walletCredit: walletCredit ?? 0,
      gatewayFee: gatewayFee ?? 0,
      finalPrice: finalPrice ?? 0,
      currencyCode: currencyCode ?? '',
      termsAcceptanceRequired: termsAcceptanceRequired ?? false,
      checkoutEndpoint: checkoutEndpoint ?? '',
      includeFriday: includeFriday ?? false,
      fridayDays: fridayDays ?? 0,
      totalServiceDays: totalServiceDays ?? 0,
    );
  }
}

extension SubscriptionSummarySlotRequirementResponseDtoMapper
    on SubscriptionSummarySlotRequirementResponseDto {
  SubscriptionSummarySlotRequirementEntity toEntity() {
    return SubscriptionSummarySlotRequirementEntity(
      slot: slot ?? '',
      count: count ?? 0,
    );
  }
}
