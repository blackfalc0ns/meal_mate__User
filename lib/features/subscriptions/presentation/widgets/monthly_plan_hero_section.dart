import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_background.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_summary.dart';

class MonthlyPlanHeroSection extends StatelessWidget {
  const MonthlyPlanHeroSection({
    super.key,
    required this.plan,
    required this.imageAsset,
    required this.onBack,
  });

  final MonthlyPlanDetailsEntity plan;
  final String imageAsset;
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

          return ColoredBox(
            color: color.surface,
            child: SizedBox(
              height: Spacing.monthlyPlanHeroHeight * scale,
              child: Stack(
                children: [
                  MonthlyPlanHeroBackground(
                    imageAsset: imageAsset,
                    scale: scale,
                    onBack: onBack,
                  ),
                  Positioned(
                    top:
                        (Spacing.monthlyPlanHeroSummaryTop - Spacing.xxxl) *
                        scale,
                    left: 0,
                    right: 0,
                    child: MonthlyPlanHeroSummary(plan: plan, scale: scale),
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
