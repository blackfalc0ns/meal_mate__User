import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';

class OfferDetailsHeroCard extends StatelessWidget {
  const OfferDetailsHeroCard({super.key, required this.details});

  final OfferDetailsData details;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Image.asset(
      details.heroImageAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      semanticLabel: locale.nav_offers,
    );
  }
}
