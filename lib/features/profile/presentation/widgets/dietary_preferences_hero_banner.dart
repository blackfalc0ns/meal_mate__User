import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class DietaryPreferencesHeroBanner extends StatelessWidget {
  const DietaryPreferencesHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ClipRRect(
      borderRadius: BorderRadius.circular(Spacing.dietaryHeroRadius),
      child: Image.asset(
        Assets.dietaryPreferencesHero,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        semanticLabel: locale.profile_dietary_preferences,
        errorBuilder: (_, _, _) => ColoredBox(color: color.primaryContainer),
      ),
    );
  }
}
