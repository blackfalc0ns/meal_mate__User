import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersFakeDataSource {
  const OffersFakeDataSource();

  OffersPageEntity getOffers() {
    return OffersPageEntity(
      hero: OffersHeroEntity(
        badgeLabel: 'لفترة محدودة',
        discountLabel: '20%',
        title: 'خصم على الباقات الشهرية',
        subtitle: 'باقات طازجة تناسب روتينك اليومي',
        description:
            'اختر الباقة المناسبة ليومك واستمتع بوجبات صحية مع توفير أكبر.',
        buttonLabel: 'استفد الآن',
        imageAsset: Assets.offerSaladBowl,
      ),
      filters: [
        OfferFilterEntity(label: 'الكل', isSelected: true),
        OfferFilterEntity(label: 'العروض'),
        OfferFilterEntity(label: 'المطاعم'),
        OfferFilterEntity(label: 'الوجبات'),
      ],
      featuredOffers: [
        OfferDealEntity(
          title: 'اشتراك شهر',
          subtitle: 'استمتع بتجربة غذائية متكاملة مع',
          discountLabel: '',
          badgeLabel: 'الأسبوع مجاني',
          buttonLabel: 'استفد الآن',
          deliveryLabel: 'ينتهي خلال: 02 يوم : 14 ساعة',
          reviewLabel: '',
          imageAsset: Assets.offerMealBoxes,
          logoAsset: Assets.offerBurgerKingLogo,
          accentColor: const Color(0xFF4FA35A),
          surfaceColor: const Color(0xFFF2FAEE),
        ),
        OfferDealEntity(
          title: 'جميع وجبات البروتين',
          subtitle: 'مثالية لبناء العضلات والنشاط',
          discountLabel: '%13 خصم',
          badgeLabel: '%13 خصم',
          buttonLabel: 'اطلب الآن',
          deliveryLabel: 'ينتهي خلال: 01 يوم : 09 ساعة',
          reviewLabel: '',
          imageAsset: Assets.offerGrilledPlate,
          logoAsset: Assets.offerMcdonaldsLogo,
          accentColor: const Color(0xFFF2C266),
          surfaceColor: const Color(0xFFFFF8EC),
        ),
        OfferDealEntity(
          title: 'اشتراك 3 أشهر',
          subtitle: 'نوفر لك تجربة كاملة مع وجبات',
          discountLabel: '%18 خصم',
          badgeLabel: '%18 خصم',
          buttonLabel: 'استفد الآن',
          deliveryLabel: 'ينتهي خلال: 04 يوم : 21 ساعة',
          reviewLabel: '',
          imageAsset: Assets.offerGiftBox,
          logoAsset: Assets.offerStarbucksLogo,
          accentColor: const Color(0xFFAA79DB),
          surfaceColor: const Color(0xFFF6F0FF),
        ),
      ],
      restaurantOffers: [
        OfferDealEntity(
          title: 'كنتاكي',
          subtitle: 'خصم %30 على جميع الأصناف',
          discountLabel: '%30 خصم',
          badgeLabel: '%30 خصم',
          buttonLabel: 'اطلب الآن',
          deliveryLabel: '3.5 كم',
          reviewLabel: '4.0',
          imageAsset: Assets.offerBurgerKingLogo,
          logoAsset: Assets.offerBurgerKingLogo,
          accentColor: const Color(0xFFF7CC25),
          surfaceColor: const Color(0xFFFFF2C8),
        ),
        OfferDealEntity(
          title: 'كنتاكي',
          subtitle: 'خصم %30 على جميع الأصناف',
          discountLabel: '%30 خصم',
          badgeLabel: '%30 خصم',
          buttonLabel: 'اطلب الآن',
          deliveryLabel: '3.0 كم',
          reviewLabel: '4.0',
          imageAsset: Assets.offerMealBoxes,
          logoAsset: Assets.offerMcdonaldsLogo,
          accentColor: const Color(0xFFE8415A),
          surfaceColor: const Color(0xFFFDE8EC),
        ),
        OfferDealEntity(
          title: 'كنتاكي',
          subtitle: 'خصم %30 على جميع الأصناف',
          discountLabel: '%30 خصم',
          badgeLabel: '%30 خصم',
          buttonLabel: 'اطلب الآن',
          deliveryLabel: '2.8 كم',
          reviewLabel: '4.0',
          imageAsset: Assets.offerGiftBox,
          logoAsset: Assets.offerStarbucksLogo,
          accentColor: const Color(0xFF31B26E),
          surfaceColor: const Color(0xFFE9FAF1),
        ),
      ],
      inviteBanner: InviteBannerEntity(
        title: 'ادعُ أصدقاءك واربح',
        subtitle: 'شارك أصدقاءك العرض واحصل على مكافأتك',
        buttonLabel: 'ادعُ الآن',
        imageAsset: Assets.offerGiftBox,
      ),
    );
  }
}
