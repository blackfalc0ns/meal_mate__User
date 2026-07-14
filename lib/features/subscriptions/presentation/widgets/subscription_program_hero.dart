import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionProgramHero extends StatelessWidget {
  const SubscriptionProgramHero({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(color: color.primaryContainer),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: Spacing.subscriptionProgramsHeroImageTop,
            left: 0,
            right: 0,
            height: Spacing.subscriptionProgramsHeroImageHeight,
            child: Image.asset(
              Assets.subscriptionProgramsHero,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              semanticLabel: locale.nav_subscription,
            ),
          ),
          Positioned(
            top: Spacing.xl,
            child: SvgPicture.asset(
              Assets.subscriptionProgramsLogo,
              width: Spacing.iconXl,
              height: Spacing.iconXl,
              semanticsLabel: locale.nav_subscription,
            ),
          ),
        ],
      ),
    );
  }
}
