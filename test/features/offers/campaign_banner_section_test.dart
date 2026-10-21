import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/data/mapper/offer_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';

void main() {
  test(
    'campaign sources are excluded while synced Offer remains purchasable',
    () {
      const coupon = OfferEntity(
        id: 'coupon',
        nameAr: '',
        nameEn: '',
        descriptionAr: '',
        descriptionEn: '',
        sourceType: 'Campaign',
        campaignId: 'c',
        promoCode: 'Save20',
        purchaseMode: OfferPurchaseMode.couponOnly,
      );
      const direct = OfferEntity(
        id: 'real-offer',
        nameAr: '',
        nameEn: '',
        descriptionAr: '',
        descriptionEn: '',
        sourceType: 'Offer',
        campaignId: 'c',
        purchaseMode: OfferPurchaseMode.directPurchase,
      );
      const state = OffersState(
        allOffers: [coupon, direct],
        filteredOffers: [coupon, direct],
      );
      expect(state.couponOffers, isEmpty);
      expect(state.readyOffers, [direct]);
      expect(state.campaignBanners, isEmpty);
      expect(direct.isCampaign, false);
    },
  );

  test('campaign source type survives response mapping', () {
    final response = OfferResponseDto.fromJson({
      'id': 'campaign-1',
      'sourceType': 'Campaign',
      'purchaseMode': 'CouponOnly',
    });

    expect(response.toEntity().isCampaign, isTrue);
  });

  test('campaign projections appear only in campaign banners', () {
    const campaign = OfferEntity(
      id: 'campaign-1',
      campaignId: 'campaign-1',
      nameAr: 'حملة',
      nameEn: 'Campaign',
      descriptionAr: '',
      descriptionEn: '',
      bannerImageUrl: 'https://example.com/banner.jpg',
      purchaseMode: OfferPurchaseMode.couponOnly,
    );
    const coupon = OfferEntity(
      id: 'coupon-1',
      promoCode: 'SAVE20',
      nameAr: 'كوبون',
      nameEn: 'Coupon',
      descriptionAr: '',
      descriptionEn: '',
      purchaseMode: OfferPurchaseMode.couponOnly,
    );
    const projectedCampaign = OfferEntity(
      id: 'campaign-2',
      sourceType: 'Campaign',
      nameAr: 'حملة ثانية',
      nameEn: 'Second campaign',
      descriptionAr: '',
      descriptionEn: '',
      purchaseMode: OfferPurchaseMode.couponOnly,
    );
    const state = OffersState(
      allOffers: [campaign, coupon, projectedCampaign],
      filteredOffers: [campaign, coupon, projectedCampaign],
    );

    expect(state.campaignBanners, [campaign]);
    expect(state.couponOffers, [coupon]);
  });
}
