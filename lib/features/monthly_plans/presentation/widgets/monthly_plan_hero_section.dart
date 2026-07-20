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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final scale = width / Spacing.monthlyPlanDesignWidth;
          final backgroundHeight =
              (Spacing.monthlyPlanHeroHeight +
                  (durationSelector == null ? 0 : Spacing.xxxl - Spacing.lg)) *
              scale;
          final durationSelectorHeight =
              (width - Spacing.monthlyPlanContentHorizontalPadding * 2) *
              Spacing.monthlyPlanDurationHeight /
              Spacing.monthlyPlanDurationCardWidth;
          final durationSelectorTop =
              backgroundHeight - durationSelectorHeight - Spacing.xs * scale;
          final heroHeight = durationSelector == null
              ? backgroundHeight
              : durationSelectorTop + durationSelectorHeight;

          return ColoredBox(
            color: color.surface,
            child: SizedBox(
              height: heroHeight,
              child: Stack(
                children: [
                  MonthlyPlanHeroBackground(
                    imageAsset: imageAsset,
                    scale: scale,
                    height: backgroundHeight,
                    onBack: onBack,
                  ),
                  Positioned(
                    top:
                        (Spacing.monthlyPlanHeroSummaryTop -
                            Spacing.xxxl -
                            Spacing.lg) *
                        scale,
                    left: 0,
                    right: 0,
                    child: MonthlyPlanHeroSummary(plan: plan, scale: scale),
                  ),
                  if (durationSelector != null)
                    PositionedDirectional(
                      top: durationSelectorTop,
                      start: Spacing.monthlyPlanContentHorizontalPadding,
                      end: Spacing.monthlyPlanContentHorizontalPadding,
                      child: durationSelector!,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
