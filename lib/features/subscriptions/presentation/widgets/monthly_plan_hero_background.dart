import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_back_button.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_fade.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_image.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_logo.dart';

class MonthlyPlanHeroBackground extends StatelessWidget {
  const MonthlyPlanHeroBackground({
    super.key,
    required this.imageAsset,
    required this.scale,
    required this.onBack,
  });

  final String imageAsset;
  final double scale;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: SizedBox(
        height: Spacing.monthlyPlanHeroHeight * scale,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              MonthlyPlanHeroImage(imageAsset: imageAsset, scale: scale),
              MonthlyPlanHeroFade(scale: scale),
              MonthlyPlanHeroBackButton(scale: scale, onBack: onBack),
              Positioned(
                top: Spacing.monthlyPlanHeroLogoTop * scale,
                left: 0,
                right: 0,
                child: MonthlyPlanHeroLogo(scale: scale),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(color: color.surface.withValues(alpha: 0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
