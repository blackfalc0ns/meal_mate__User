import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_fade.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_image.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_logo.dart';

class MonthlyPlanHeroBackground extends StatelessWidget {
  const MonthlyPlanHeroBackground({
    super.key,
    required this.imageAsset,
    this.imageUrl,
    required this.height,
    required this.onBack,
  });

  final String imageAsset;
  final String? imageUrl;
  final double height;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: SizedBox(
        height: height,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              MonthlyPlanHeroImage(imageAsset: imageAsset, imageUrl: imageUrl),
              const MonthlyPlanHeroFade(),
              CustomBackButton(
                onPressed: onBack,
                top: Spacing.monthlyPlanHeroLogoTop + Spacing.lg,
                end: Spacing.monthlyPlanHeroBackEnd,
                size: Spacing.monthlyPlanHeroBackSize,
                iconSize: Spacing.iconMd,
              ),
              const Positioned(
                top: Spacing.monthlyPlanHeroLogoTop,
                left: 0,
                right: 0,
                child: MonthlyPlanHeroLogo(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
