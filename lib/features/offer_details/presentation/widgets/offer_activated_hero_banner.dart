import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OfferActivatedHeroBanner extends StatelessWidget {
  const OfferActivatedHeroBanner({super.key, required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Spacing.bottomSheetRadius),
        child: Image.asset(
          "assets/images/offers/banner_offfer.png",
          width: double.infinity,
          fit: BoxFit.cover,
          semanticLabel: locale.offer_activated_title,
          errorBuilder: (_, _, _) => ColoredBox(color: color.surface),
        ),
      ),
    );
  }
}
