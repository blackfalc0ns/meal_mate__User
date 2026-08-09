import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_background.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_summary.dart';

class MonthlyPlanHeroSection extends StatelessWidget {
  const MonthlyPlanHeroSection({
    super.key,
    required this.plan,
    required this.imageAsset,
    this.durationSelector,
    required this.onBack,
  });

  final MonthlyPlanDetailsEntity plan;
  final String imageAsset;
  final Widget? durationSelector;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: ColoredBox(
        color: color.surface,
        child: SizedBox(
          height: durationSelector == null
              ? Spacing.monthlyPlanHeroHeight
              : Spacing.monthlyPlanDurationCardTop +
                    Spacing.monthlyPlanDurationHeight,
          child: Stack(
            children: [
              MonthlyPlanHeroBackground(
                imageAsset: imageAsset,
                height: Spacing.monthlyPlanHeroHeight,
                onBack: onBack,
              ),
              Positioned(
                top: Spacing.monthlyPlanHeroSummaryTop,
                left: 0,
                right: 0,
                child: MonthlyPlanHeroSummary(plan: plan),
              ),
              if (durationSelector != null)
                PositionedDirectional(
                  top: Spacing.monthlyPlanDurationCardTop,
                  start: Spacing.monthlyPlanDurationHorizontalPadding,
                  end: Spacing.monthlyPlanDurationHorizontalPadding,
                  child: durationSelector!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
