import 'package:meal_meat_user/features/offers/data/models/response/offer_purchase_options_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';

extension OfferPurchaseOptionsResponseMapper
    on OfferPurchaseOptionsResponseDto {
  OfferPurchaseOptionsEntity toEntity({String? fallbackOfferId}) =>
      OfferPurchaseOptionsEntity(
        offerId: offerId ?? fallbackOfferId ?? '',
        subscriptionType: subscriptionType ?? '',
        serverNowUtc: DateTime.tryParse(serverNowUtc ?? ''),
        familyFlowDestination: familyFlowDestination,
        blockingReasons: (blockingReasons ?? const [])
            .map((e) => e.toEntity())
            .toList(),
        options: (options ?? const [])
            .map((e) => e.toEntity())
            .where(
              (e) =>
                  e.programId.isNotEmpty &&
                  e.bundleId.isNotEmpty &&
                  e.tier.isNotEmpty &&
                  e.durationDays > 0 &&
                  e.startDate.isNotEmpty,
            )
            .toList(),
      );
}

extension OfferPurchaseBlockingReasonMapper on OfferPurchaseBlockingReasonDto {
  OfferPurchaseBlockingReasonEntity toEntity() =>
      OfferPurchaseBlockingReasonEntity(
        code: code ?? '',
        messageAr: messageAr,
        messageEn: messageEn,
        field: field,
      );
}

extension OfferPurchaseOptionMapper on OfferPurchaseOptionDto {
  OfferPurchaseOptionEntity toEntity() => OfferPurchaseOptionEntity(
    programId: programId ?? '',
    bundleId: bundleId ?? '',
    tier: tier ?? '',
    durationDays: durationDays ?? 0,
    startDate: startDate ?? '',
    includeFriday: includeFriday ?? false,
    canCheckout: canCheckout ?? false,
    programNameAr: programNameAr,
    programNameEn: programNameEn,
    bundleNameAr: bundleNameAr,
    bundleNameEn: bundleNameEn,
    tierNameAr: tierNameAr,
    tierNameEn: tierNameEn,
    imageUrl: imageUrl,
    endDate: endDate,
    totalServiceDays: totalServiceDays,
    mealsPerDay: mealsPerDay,
    basePrice: basePrice,
    finalPrice: finalPrice,
    currencyCode: currencyCode,
    blockingReasons: (blockingReasons ?? const [])
        .map((e) => e.toEntity())
        .toList(),
  );
}
