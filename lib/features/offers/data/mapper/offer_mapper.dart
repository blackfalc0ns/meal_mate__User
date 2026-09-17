import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_session_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_evaluation_entity.dart';

extension OfferResponseDtoMapper on OfferResponseDto {
  OfferEntity toEntity() {
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
      remainingSpots: remainingSpots,
      minSubscriptionDays: minSubscriptionDays,
      campaignId: campaignId,
      promoCode: promoCode,
      allowStacking: allowPromoCodeStacking ?? false,
      termsAndConditionsAr: termsAndConditionsAr,
      termsAndConditionsEn: termsAndConditionsEn,
      programIds: programIds ?? const [],
      bundleIds: bundleIds ?? const [],
      restaurantIds: restaurantIds ?? const [],
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
