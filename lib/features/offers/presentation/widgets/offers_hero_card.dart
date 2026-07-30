import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersHeroCard extends StatelessWidget {
  const OffersHeroCard({super.key, required this.hero});

  final OffersHeroEntity hero;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AspectRatio(
      aspectRatio: Spacing.offersHeroAspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
          child: Image.asset(
            hero.imageAsset,
            fit: BoxFit.cover,
            width: double.infinity,
            semanticLabel: locale.nav_offers,
          ),
        ),
      ),
    );
  }
}
