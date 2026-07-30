import 'package:flutter/material.dart';

class OffersPageEntity {
  const OffersPageEntity({
    required this.hero,
    required this.featuredSectionTitle,
    required this.filters,
    required this.featuredOffers,
    required this.couponBanner,
    required this.inviteBanner,
  });

  final OffersHeroEntity hero;
  final String featuredSectionTitle;
  final List<OfferFilterEntity> filters;
  final List<OfferDealEntity> featuredOffers;
  final OfferCouponBannerEntity couponBanner;
  final InviteBannerEntity inviteBanner;
}

class OffersHeroEntity {
  const OffersHeroEntity({
    required this.badgeLabel,
    required this.discountLabel,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLabel,
    required this.imageAsset,
  });

  final String badgeLabel;
  final String discountLabel;
  final String title;
  final String subtitle;
  final String description;
  final String buttonLabel;
  final String imageAsset;
}

class OfferFilterEntity {
  const OfferFilterEntity({
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
}

class OfferDealEntity {
  const OfferDealEntity({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.discountLabel,
    required this.badgeLabel,
    required this.buttonLabel,
    this.deliveryPrefixLabel,
    required this.deliveryLabel,
    required this.reviewLabel,
    required this.imageAsset,
    required this.logoAsset,
    required this.accentColor,
    required this.surfaceColor,
    required this.footerColor,
    this.detailTitle,
    this.detailSubtitle,
    this.couponCode,
    this.expiryText,
    this.conditionsText,
    this.noteText,
  });

  final OfferCategory category;
  final String title;
  final String subtitle;
  final String discountLabel;
  final String badgeLabel;
  final String buttonLabel;
  final String? deliveryPrefixLabel;
  final String deliveryLabel;
  final String reviewLabel;
  final String imageAsset;
  final String logoAsset;
  final Color accentColor;
  final Color surfaceColor;
  final Color footerColor;
  final String? detailTitle;
  final String? detailSubtitle;
  final String? couponCode;
  final String? expiryText;
  final String? conditionsText;
  final String? noteText;
}

enum OfferCategory { offer, restaurant, meal }

class OfferCouponBannerEntity {
  const OfferCouponBannerEntity({
    required this.imageAsset,
    required this.titlePrefix,
    required this.highlight,
    required this.titleSuffix,
    required this.secondLine,
    required this.buttonLabel,
  });

  final String imageAsset;
  final String titlePrefix;
  final String highlight;
  final String titleSuffix;
  final String secondLine;
  final String buttonLabel;
}

class InviteBannerEntity {
  const InviteBannerEntity({
    required this.bannerImageAsset,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.imageAsset,
    required this.trailingImageAsset,
  });

  final String bannerImageAsset;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final String imageAsset;
  final String trailingImageAsset;
}
