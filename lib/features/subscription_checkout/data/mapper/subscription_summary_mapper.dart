import 'package:meal_meat_user/core/network/mapper/pagination_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_coupon_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

import '../models/response/subscription_readiness_response_dto.dart';

extension SubscriptionReadinessResponseDtoMapper
    on SubscriptionReadinessResponseDto {
  SubscriptionReadinessEntity toEntity() {
    return SubscriptionReadinessEntity(
      isComplete: isComplete ?? false,
      canOpenSummary: canOpenSummary ?? false,
      canCheckout: canCheckout ?? false,
      nextAction: nextAction ?? '',
      warningAr: warningAr ?? '',
      warningEn: warningEn ?? '',
      checkoutBlockReason: checkoutBlockReason,
      program: program?.toEntity(),
      address: address?.toEntity(),
      deliveringRestaurantCount: deliveringRestaurantCount ?? 0,
      items: (items ?? const []).map((item) => item.toEntity()).toList(),
      restaurants: (restaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .toList(),
    );
  }
}

extension SubscriptionReadinessProgramResponseDtoMapper
    on SubscriptionReadinessProgramResponseDto {
  SubscriptionReadinessProgramEntity toEntity() {
    return SubscriptionReadinessProgramEntity(
      programId: programId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
    );
  }
}

extension SubscriptionReadinessAddressResponseDtoMapper
    on SubscriptionReadinessAddressResponseDto {
  SubscriptionReadinessAddressEntity toEntity() {
    return SubscriptionReadinessAddressEntity(
      id: id ?? '',
      label: label ?? '',
      addressLine: addressLine ?? '',
      governorate: governorate,
      area: area,
      block: block,
      regionId: regionId,
      governorateNameAr: governorateNameAr,
      governorateNameEn: governorateNameEn,
      areaNameAr: areaNameAr,
      areaNameEn: areaNameEn,
      blockNameAr: blockNameAr,
      blockNameEn: blockNameEn,
    );
  }
}

extension SubscriptionReadinessItemResponseDtoMapper
    on SubscriptionReadinessItemResponseDto {
  SubscriptionReadinessItemEntity toEntity() {
    return SubscriptionReadinessItemEntity(
      code: code ?? '',
      isComplete: isComplete ?? false,
      titleAr: titleAr ?? '',
      titleEn: titleEn ?? '',
      actionScreen: actionScreen ?? code ?? '',
      endpoint: endpoint,
    );
  }
}

extension SubscriptionReadinessRestaurantResponseDtoMapper
    on SubscriptionReadinessRestaurantResponseDto {
  SubscriptionReadinessRestaurantEntity toEntity() {
    return SubscriptionReadinessRestaurantEntity(
      restaurantId: restaurantId ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl,
      tier: tier ?? '',
    );
  }
}

extension SubscriptionSummaryResponseDtoMapper
    on SubscriptionSummaryResponseDto {
  SubscriptionSummaryEntity toEntity() {
    return SubscriptionSummaryEntity(
      programId: programId ?? '',
      programNameAr: programNameAr ?? programName ?? '',
      programNameEn: programNameEn ?? programName ?? '',
      programImageUrl: programImageUrl,
      bundleId: bundleId ?? '',
      bundleNameAr: bundleNameAr ?? bundleName ?? '',
      bundleNameEn: bundleNameEn ?? bundleName ?? '',
      imageUrl: imageUrl,
      restaurantId: restaurantId,
      restaurantNameAr: restaurantNameAr,
      restaurantNameEn: restaurantNameEn,
      restaurantCount: restaurantCount ?? 0,
      tier: tier ?? '',
      tierNameAr: tierNameAr ?? tierName ?? '',
      tierNameEn: tierNameEn ?? tierName ?? '',
      durationDays: durationDays ?? 0,
      chosenStartDate: chosenStartDate ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      serviceDates: serviceDates ?? const [],
      restaurantRepetition: restaurantRepetition?.toEntity(),
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
      canCheckout: canCheckout ?? false,
      checkoutBlockReason: checkoutBlockReason,
      address: address?.toEntity(),
      restaurants: (restaurants ?? const [])
          .map((restaurant) => restaurant.toEntity())
          .toList(),
      termsAcceptanceRequired: termsAcceptanceRequired ?? false,
      checkoutEndpoint: checkoutEndpoint ?? '',
      includeFriday: includeFriday ?? false,
      fridayDays: fridayDays ?? 0,
      totalServiceDays: totalServiceDays ?? 0,
      includes:
          includes?.toEntity() ??
          const SubscriptionSummaryIncludesEntity(
            titleAr: '',
            titleEn: '',
            items: [],
          ),
      coupon: coupon?.toEntity(),
      restaurantsPagination: restaurantsPagination?.toEntity(),
      availability: availability?.toEntity(),
    );
  }
}

extension SubscriptionSummaryRestaurantRepetitionResponseDtoMapper
    on SubscriptionSummaryRestaurantRepetitionResponseDto {
  SubscriptionSummaryRestaurantRepetitionEntity toEntity() {
    return SubscriptionSummaryRestaurantRepetitionEntity(
      limit: limit ?? 0,
      restaurantCount: restaurantCount ?? 0,
      durationDays: durationDays ?? 0,
    );
  }
}

extension SubscriptionSummaryAddressResponseDtoMapper
    on SubscriptionSummaryAddressResponseDto {
  SubscriptionSummaryAddressEntity toEntity() {
    return SubscriptionSummaryAddressEntity(
      id: id ?? '',
      label: label ?? '',
      addressLine: addressLine ?? '',
      governorate: governorate,
      area: area,
      block: block,
      regionId: regionId,
      governorateNameAr: governorateNameAr ?? governorateName,
      governorateNameEn: governorateNameEn ?? governorateName,
      areaNameAr: areaNameAr ?? areaName,
      areaNameEn: areaNameEn ?? areaName,
      blockNameAr: blockNameAr ?? blockName,
      blockNameEn: blockNameEn ?? blockName,
    );
  }
}

extension SubscriptionSummaryRestaurantResponseDtoMapper
    on SubscriptionSummaryRestaurantResponseDto {
  SubscriptionSummaryRestaurantEntity toEntity() {
    return SubscriptionSummaryRestaurantEntity(
      restaurantId: restaurantId ?? '',
      nameAr: nameAr ?? name ?? '',
      nameEn: nameEn ?? name ?? '',
      logoUrl: logoUrl,
      tier: tier ?? '',
    );
  }
}

extension SubscriptionSummarySlotRequirementResponseDtoMapper
    on SubscriptionSummarySlotRequirementResponseDto {
  SubscriptionSummarySlotRequirementEntity toEntity() {
    return SubscriptionSummarySlotRequirementEntity(
      slot: slot ?? '',
      nameAr: nameAr ?? name ?? '',
      nameEn: nameEn ?? name ?? '',
      count: count ?? 0,
    );
  }
}

extension SubscriptionSummaryIncludesResponseDtoMapper
    on SubscriptionSummaryIncludesResponseDto {
  SubscriptionSummaryIncludesEntity toEntity() {
    return SubscriptionSummaryIncludesEntity(
      titleAr: titleAr ?? title ?? '',
      titleEn: titleEn ?? title ?? '',
      items: (items ?? const []).map((item) => item.toEntity()).toList(),
    );
  }
}

extension SubscriptionSummaryIncludeItemResponseDtoMapper
    on SubscriptionSummaryIncludeItemResponseDto {
  SubscriptionSummaryIncludeItemEntity toEntity() {
    return SubscriptionSummaryIncludeItemEntity(
      code: code ?? '',
      textAr: textAr ?? text ?? '',
      textEn: textEn ?? text ?? '',
    );
  }
}
