import 'package:flutter/material.dart';

class OffersPageEntity {
  const OffersPageEntity({
    required this.hero,
    required this.filters,
    required this.featuredOffers,
    required this.restaurantOffers,
    required this.inviteBanner,
  });

  final OffersHeroEntity hero;
  final List<OfferFilterEntity> filters;
  final List<OfferDealEntity> featuredOffers;
  final List<OfferDealEntity> restaurantOffers;
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
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;
}

class OfferDealEntity {
  const OfferDealEntity({
    required this.title,
    required this.subtitle,
    required this.discountLabel,
    required this.badgeLabel,
    required this.buttonLabel,
    required this.deliveryLabel,
    required this.reviewLabel,
    required this.imageAsset,
    required this.logoAsset,
    required this.accentColor,
    required this.surfaceColor,
  });

  final String title;
  final String subtitle;
  final String discountLabel;
  final String badgeLabel;
  final String buttonLabel;
  final String deliveryLabel;
  final String reviewLabel;
  final String imageAsset;
  final String logoAsset;
  final Color accentColor;
  final Color surfaceColor;
}

class InviteBannerEntity {
  const InviteBannerEntity({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final String imageAsset;
}
