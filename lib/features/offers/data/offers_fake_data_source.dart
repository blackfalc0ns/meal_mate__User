import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersFakeDataSource {
  const OffersFakeDataSource();

  OffersPageEntity getOffers(AppLocalizations locale) {
    return OffersPageEntity(
      hero: OffersHeroEntity(
        badgeLabel: locale.offers_hero_badge,
        discountLabel: locale.offers_hero_discount,
        title: locale.offers_hero_title,
        subtitle: locale.offers_hero_subtitle,
        description: locale.offers_hero_description,
        buttonLabel: locale.offers_hero_button,
        imageAsset: AssetsFake.offersFigmaHeroMeal,
      ),
      filters: [
        OfferFilterEntity(
          label: locale.offers_filter_all,
          icon: Icons.local_fire_department_rounded,
          isSelected: true,
        ),
        OfferFilterEntity(
          label: locale.offers_filter_offers,
          icon: Icons.wallet_membership_rounded,
        ),
        OfferFilterEntity(
          label: locale.offers_filter_restaurants,
          icon: Icons.local_offer_rounded,
        ),
        OfferFilterEntity(
          label: locale.offers_filter_meals,
          icon: Icons.schedule_rounded,
        ),
        OfferFilterEntity(
          label: locale.offers_filter_gifts,
          icon: Icons.card_giftcard_rounded,
        ),
      ],
      featuredOffers: [
        OfferDealEntity(
          category: OfferCategory.offer,
          title: locale.offers_featured_burger_title,
          subtitle: locale.offers_featured_burger_subtitle,
          discountLabel: locale.offers_featured_burger_discount,
          badgeLabel: locale.offers_featured_burger_badge,
          buttonLabel: locale.offers_featured_button,
          deliveryPrefixLabel: locale.offers_countdown_label,
          deliveryLabel: locale.offers_featured_burger_delivery,
          reviewLabel: locale.offers_featured_burger_reviews,
          imageAsset: AssetsFake.offersFigmaMonthlyBox,
          logoAsset: AssetsFake.offersFigmaMonthlyBox,
          accentColor: AppColors.primary400,
          surfaceColor: AppColors.appSurface,
          footerColor: AppColors.primary400,
          detailTitle: locale.offers_featured_burger_title,
          detailSubtitle: locale.offers_featured_burger_subtitle,
          couponCode: 'SAVE30',
          expiryText: locale.offers_countdown_value,
          conditionsText: locale.offer_details_info_summary,
          noteText: locale.offers_hero_description,
        ),
        OfferDealEntity(
          category: OfferCategory.meal,
          title: locale.offers_featured_salad_title,
          subtitle: locale.offers_featured_salad_subtitle,
          discountLabel: locale.offers_featured_salad_discount,
          badgeLabel: locale.offers_featured_salad_discount,
          buttonLabel: locale.offers_featured_button,
          deliveryPrefixLabel: locale.offers_countdown_label,
          deliveryLabel: locale.offers_featured_salad_delivery,
          reviewLabel: locale.offers_featured_salad_reviews,
          imageAsset: AssetsFake.offersFigmaProteinPlate,
          logoAsset: AssetsFake.offersFigmaProteinPlate,
          accentColor: AppColors.secondary,
          surfaceColor: AppColors.appSurface,
          footerColor: AppColors.secondary,
          detailTitle: locale.offers_featured_salad_title,
          detailSubtitle: locale.offers_featured_salad_subtitle,
          couponCode: 'PRO30',
          expiryText: locale.offers_countdown_value,
          conditionsText: locale.offer_details_info_summary,
          noteText: locale.offers_hero_description,
        ),
        OfferDealEntity(
          category: OfferCategory.offer,
          title: locale.offers_featured_gift_title,
          subtitle: locale.offers_featured_gift_subtitle,
          discountLabel: locale.offers_featured_gift_discount,
          badgeLabel: locale.offers_featured_gift_badge,
          buttonLabel: locale.offers_featured_button,
          deliveryPrefixLabel: locale.offers_countdown_label,
          deliveryLabel: locale.offers_featured_gift_delivery,
          reviewLabel: locale.offers_featured_gift_reviews,
          imageAsset: AssetsFake.offersFigmaGiftBox,
          logoAsset: AssetsFake.offersFigmaGiftBox,
          accentColor: AppColors.primary400,
          surfaceColor: AppColors.appSurface,
          footerColor: AppColors.primary400,
          detailTitle: locale.offers_featured_gift_title,
          detailSubtitle: locale.offers_featured_gift_subtitle,
          couponCode: 'GIFT30',
          expiryText: locale.offers_countdown_value,
          conditionsText: locale.offer_details_info_summary,
          noteText: locale.offers_hero_description,
        ),
      ],
      couponBanner: OfferCouponBannerEntity(
        titlePrefix: locale.offers_coupon_prefix,
        highlight: locale.offers_coupon_highlight,
        titleSuffix: locale.offers_coupon_suffix,
        secondLine: locale.offers_coupon_second_line,
        buttonLabel: locale.offers_coupon_button,
      ),
      inviteBanner: InviteBannerEntity(
        title: locale.offers_invite_title,
        subtitle: locale.offers_invite_subtitle,
        buttonLabel: locale.offers_invite_button,
        imageAsset: AssetsFake.offersFigmaInvitePeople,
        trailingImageAsset: AssetsFake.offersFigmaInviteGift,
      ),
    );
  }
}
