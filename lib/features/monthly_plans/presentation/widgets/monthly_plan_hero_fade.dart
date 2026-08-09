import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanHeroFade extends StatelessWidget {
  const MonthlyPlanHeroFade({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: Spacing.monthlyPlanHeroFadeHeight,
      child: Semantics(
        label: locale.nav_subscription,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.surface.withValues(alpha: 0),
                color.surface.withValues(alpha: 0.64),
                color.surface,
                color.surface,
              ],
              stops: const [0.13, 0.41, 0.51, 0.98],
            ),
          ),
        ),
      ),
    );
  }
}
