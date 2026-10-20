import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offers_hub_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_eligible_restaurant_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_calendar_entry_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/validate_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_evaluation_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_hub_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_eligible_restaurant_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_calendar_entry_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/validate_discount_result_entity.dart';

OfferPurchaseMode parseOfferPurchaseMode(String? raw) => switch (raw) {
  'DirectPurchase' => OfferPurchaseMode.directPurchase,
  'CouponOnly' => OfferPurchaseMode.couponOnly,
  _ => OfferPurchaseMode.unknown,
};

extension OfferResponseDtoMapper on OfferResponseDto {
  OfferEntity toEntity({DateTime? serverNowUtc}) {
    return OfferEntity(
      id: id ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      descriptionAr: descriptionAr ?? '',
      descriptionEn: descriptionEn ?? '',
      bannerImageUrl: bannerImageUrl,
      discountRate: discountRate,
      discountAmount: discountAmountKwd ?? discountAmount,
      startsAt: startsAtUtc != null ? DateTime.tryParse(startsAtUtc!) : null,
      endsAt: endsAtUtc != null ? DateTime.tryParse(endsAtUtc!) : null,
      serverNowUtc: serverNowUtc,
      serverObservedAtUtc: serverNowUtc != null ? DateTime.now().toUtc() : null,
      remainingSpots: remainingSpots,
      minSubscriptionDays: minSubscriptionDays,
      campaignId: campaignId,
      sourceType: sourceType,
      promoCode: promoCode,
      allowStacking: allowPromoCodeStacking ?? false,
      termsAndConditionsAr: termsAndConditionsAr,
      termsAndConditionsEn: termsAndConditionsEn,
      programIds: resolvedProgramIds ?? const [],
      bundleIds: resolvedBundleIds ?? const [],
      restaurantIds: resolvedRestaurantIds ?? const [],
      allowedDurationDays: allowedDurationDays ?? const [],
      isSaved: isSaved ?? false,
      isAvailable: isAvailable ?? true,
      purchaseMode: parseOfferPurchaseMode(purchaseMode),
    );
  }
}

extension EvaluateOfferDiscountResponseDtoMapper
    on EvaluateOfferDiscountResponseDto {
  OfferEvaluationEntity toEntity() {
    final reasons = <String>[];
    if (ineligibilityReasons != null) {
      reasons.addAll(ineligibilityReasons!);
    }
    if (reasonIfFailed != null && reasonIfFailed!.isNotEmpty) {
      if (!reasons.contains(reasonIfFailed)) {
        reasons.add(reasonIfFailed!);
      }
    }

    return OfferEvaluationEntity(
      offerId: offerId,
      offerName: offerName,
      isEligible: isEligible ?? isApplicable ?? false,
      calculatedDiscountAmount:
          calculatedDiscountAmount ?? calculatedDiscountKwd ?? 0.0,
      finalAmount: finalAmountKwd,
      ineligibilityReasons: reasons,
      allowPromoCodeStacking: allowPromoCodeStacking ?? false,
    );
  }
}

extension CampaignCheckoutSessionResponseDtoMapper
    on CampaignCheckoutSessionResponseDto {
  CampaignSessionEntity toEntity() {
    return CampaignSessionEntity(
      sessionId: sessionId ?? '',
      campaignId: campaignId ?? '',
      bundleId: bundleId ?? '',
      customerId: customerId ?? '',
      durationDays: durationDays ?? 26,
      finalCustomerPrice: finalCustomerPrice ?? 0.0,
      currency: currency ?? 'KWD',
      expiresAtUtc: expiresAtUtc != null
          ? DateTime.tryParse(expiresAtUtc!)
          : null,
      status: status ?? 'PendingPayment',
    );
  }
}

extension OffersHubResponseDtoMapper on OffersHubResponseDto {
  OffersHubEntity toEntity() {
    final serverTime = resolvedServerTimeUtc != null
        ? DateTime.tryParse(resolvedServerTimeUtc!)
        : null;

    return OffersHubEntity(
      heroOffers: resolvedHeroOffers
          .map((e) => e.toEntity(serverNowUtc: serverTime))
          .toList(),
      availableOffers: resolvedAvailableOffers
          .map((e) => e.toEntity(serverNowUtc: serverTime))
          .toList(),
      savedOffers:
          savedOffers
              ?.map((e) => e.toEntity(serverNowUtc: serverTime))
              .toList() ??
          const [],
      serverTimeUtc: serverTime,
    );
  }
}

extension OfferEligibleRestaurantDtoMapper on OfferEligibleRestaurantDto {
  OfferEligibleRestaurantEntity toEntity() {
    return OfferEligibleRestaurantEntity(
      id: id?.toString() ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      logoUrl: logoUrl,
      rating: rating,
    );
  }
}

extension OfferCalendarEntryDtoMapper on OfferCalendarEntryDto {
  OfferCalendarEntryEntity toEntity() {
    return OfferCalendarEntryEntity(
      id: id,
      offerId: offerId ?? '',
      scheduledDate: scheduledDate ?? '',
      status: status ?? 1,
      offer: offer?.toEntity(),
      createdAtUtc: createdAtUtc != null
          ? DateTime.tryParse(createdAtUtc!)
          : null,
    );
  }
}

extension ValidateDiscountResponseDtoMapper on ValidateDiscountResponseDto {
  ValidateDiscountResultEntity toEntity() {
    return ValidateDiscountResultEntity(
      isValid: isValid ?? false,
      code: code ?? '',
      codeType: codeType ?? 'Unknown',
      discountAmount: resolvedDiscountAmount,
      discountPercent: resolvedDiscountPercent,
      eligibilityCode: eligibilityCode,
      messageAr: resolvedMessageAr,
      messageEn: resolvedMessageEn,
      offerId: offerId,
      offerName: offerName,
    );
  }
}
