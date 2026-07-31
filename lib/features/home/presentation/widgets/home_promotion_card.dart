import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomePromotionCard extends StatelessWidget {
  const HomePromotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      height: Spacing.homePromotionHeight,
      child: Card(
        color: color.surface,
        clipBehavior: Clip.antiAlias,
        child: Semantics(
          label: locale.home_promo_discount,
          image: true,
          child: Image.asset(
            Assets.homePromotion,
            width: double.infinity,
            height: Spacing.homePromotionHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
