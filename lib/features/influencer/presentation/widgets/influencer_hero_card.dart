import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';

class InfluencerHeroCard extends StatelessWidget {
  const InfluencerHeroCard({super.key, required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.radiusLg),
      child: AspectRatio(
        aspectRatio: 359 / 199.03,
        child: Image.asset(imageAsset, fit: BoxFit.cover),
      ),
    );
  }
}
