import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanHeroSummary extends StatelessWidget {
  const MonthlyPlanHeroSummary({
    super.key,
    this.titlePrefix,
    this.titleHighlight,
    this.plan,
  });

  final String? titlePrefix;
  final String? titleHighlight;
  final MonthlyPlanDetailsEntity? plan;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final effectiveTitlePrefix = titlePrefix ?? plan?.titlePrefix ?? '';
    final effectiveTitleHighlight =
        titleHighlight ?? plan?.titleHighlight ?? '';

    return Semantics(
      label: locale.nav_subscription,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (effectiveTitlePrefix.isNotEmpty)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  effectiveTitlePrefix,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size24,
                    color: color.onSurface,
                  ),
                ),
              ),
            if (effectiveTitleHighlight.isNotEmpty) ...[
              const SizedBox(height: Spacing.xxs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  effectiveTitleHighlight,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size20,
                    color: color.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
