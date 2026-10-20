import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

void main() {
  group('OfferMapper and OfferEntity Tests', () {
    test('OfferResponseDto toEntity mapping with full values', () {
      const dto = OfferResponseDto(
        id: 'offer-1',
        nameAr: 'عرض رمضان',
        nameEn: 'Ramadan Offer',
        descriptionAr: 'خصم 20% على الوجبات',
        descriptionEn: '20% off all meals',
        promoCode: 'RAMADAN20',
        discountRate: 0.20,
        discountAmount: 10.0,
        startsAtUtc: '2026-03-01T00:00:00Z',
        endsAtUtc: '2027-04-01T00:00:00Z',
        allowPromoCodeStacking: true,
        campaignId: 'camp-123',
        minSubscriptionDays: 26,
        remainingSpots: 5,
        totalUsageLimit: 50,
      );

      final entity = dto.toEntity();

      expect(entity.id, 'offer-1');
      expect(entity.title('ar'), 'عرض رمضان');
      expect(entity.title('en'), 'Ramadan Offer');
      expect(entity.description('ar'), 'خصم 20% على الوجبات');
      expect(entity.promoCode, 'RAMADAN20');
      expect(entity.discountRate, 0.20);
      expect(entity.discountAmount, 10.0);
      expect(entity.formattedDiscount(), '20%');
      expect(entity.campaignId, 'camp-123');
      expect(entity.minSubscriptionDays, 26);
      expect(entity.remainingSpots, 5);
      expect(entity.isSoldOut, false);
      expect(entity.isExpired, false);
    });

    test('maps server allowed durations without inventing package options', () {
      const dto = OfferResponseDto(
        id: 'offer-durations',
        allowedDurationDays: [30, 60, 90],
      );

      final entity = dto.toEntity();

      expect(entity.allowedDurationDays, [30, 60, 90]);
    });

    test('OfferResponseDto toEntity mapping with null/fallback values', () {
      const dto = OfferResponseDto(id: 'offer-2');
      final entity = dto.toEntity();

      expect(entity.id, 'offer-2');
      expect(entity.nameAr, '');
      expect(entity.nameEn, '');
      expect(entity.formattedDiscount(), '');
      expect(entity.isExpired, false);
      expect(entity.isSoldOut, false);
    });

    test('OfferEntity sold out when remainingSpots is 0', () {
      const entity = OfferEntity(
        id: 'offer-sold-out',
        nameAr: 'عرض منتهي',
        nameEn: 'Sold Out Offer',
        descriptionAr: 'منتهي',
        descriptionEn: 'Sold out',
        remainingSpots: 0,
      );

      expect(entity.isSoldOut, true);
    });

    test('OfferEntity isExpired when endsAt is in the past', () {
      final entity = OfferEntity(
        id: 'offer-past',
        nameAr: 'عرض قديم',
        nameEn: 'Old Offer',
        descriptionAr: 'قديم',
        descriptionEn: 'Old',
        endsAt: DateTime.now().toUtc().subtract(const Duration(days: 1)),
      );

      expect(entity.isExpired, true);
    });

    test('EvaluateOfferDiscountResponseDto toEntity mapping', () {
      const dto = EvaluateOfferDiscountResponseDto(
        isEligible: true,
        isApplicable: true,
        calculatedDiscountAmount: 5.500,
        calculatedDiscountKwd: 5.500,
        finalAmountKwd: 30.000,
        offerId: 'off-1',
        offerName: 'خصم خاص',
        ineligibilityReasons: ['Eligible coupon'],
        allowPromoCodeStacking: true,
      );

      final entity = dto.toEntity();

      expect(entity.isEligible, true);
      expect(entity.calculatedDiscountAmount, 5.500);
      expect(entity.finalAmount, 30.000);
      expect(entity.offerId, 'off-1');
      expect(entity.firstReason, 'Eligible coupon');
    });

    test('OfferResponseDto maps purchaseMode correctly', () {
      expect(
        OfferResponseDto.fromJson({'purchaseMode': 'DirectPurchase'})
            .toEntity()
            .purchaseMode,
        OfferPurchaseMode.directPurchase,
      );
      expect(
        OfferResponseDto.fromJson({'purchaseMode': 'CouponOnly'})
            .toEntity()
            .purchaseMode,
        OfferPurchaseMode.couponOnly,
      );
      expect(
        OfferResponseDto.fromJson({'purchaseMode': null})
            .toEntity()
            .purchaseMode,
        OfferPurchaseMode.unknown,
      );
      expect(
        OfferResponseDto.fromJson({'purchaseMode': 'FutureMode'})
            .toEntity()
            .purchaseMode,
        OfferPurchaseMode.unknown,
      );
      expect(
        const OfferResponseDto().toEntity().purchaseMode,
        OfferPurchaseMode.unknown,
      );
    });

    test('OfferEntity purchaseMode getters and copyWith', () {
      const direct = OfferEntity(
        id: '1',
        nameAr: 'أ',
        nameEn: 'A',
        descriptionAr: 'و',
        descriptionEn: 'D',
        purchaseMode: OfferPurchaseMode.directPurchase,
      );
      expect(direct.isDirectPurchase, true);
      expect(direct.isCouponOnly, false);

      const coupon = OfferEntity(
        id: '2',
        nameAr: 'ب',
        nameEn: 'B',
        descriptionAr: 'و',
        descriptionEn: 'D',
        purchaseMode: OfferPurchaseMode.couponOnly,
      );
      expect(coupon.isDirectPurchase, false);
      expect(coupon.isCouponOnly, true);

      const unknown = OfferEntity(
        id: '3',
        nameAr: 'ج',
        nameEn: 'C',
        descriptionAr: 'و',
        descriptionEn: 'D',
        purchaseMode: OfferPurchaseMode.unknown,
      );
      expect(unknown.isDirectPurchase, false);
      expect(unknown.isCouponOnly, false);

      final copied = direct.copyWith(nameEn: 'Updated');
      expect(copied.purchaseMode, OfferPurchaseMode.directPurchase);
      expect(copied.isDirectPurchase, true);

      final changedMode = direct.copyWith(purchaseMode: OfferPurchaseMode.couponOnly);
      expect(changedMode.purchaseMode, OfferPurchaseMode.couponOnly);
      expect(changedMode.isCouponOnly, true);
    });
  });
}
