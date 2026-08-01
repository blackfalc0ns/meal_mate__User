import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';

class OfferDetailsHeroCard extends StatelessWidget {
  const OfferDetailsHeroCard({super.key, required this.details});

  final OfferDetailsData details;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: Spacing.offerDetailsHeroWidthFactor,
      child: AspectRatio(
        aspectRatio: Spacing.offerDetailsHeroAspectRatio,
        child: Image.asset(
          details.heroImageAsset,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
