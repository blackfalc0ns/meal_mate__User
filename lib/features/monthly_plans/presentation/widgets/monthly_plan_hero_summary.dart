import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanHeroSummary extends StatelessWidget {
  const MonthlyPlanHeroSummary({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:
                  getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: Spacing.monthlyPlanHeroTitleSize,
                    color: color.onSurface,
                  ).copyWith(
                    height:
                        Spacing.monthlyPlanHeroTitleLineHeight /
                        Spacing.monthlyPlanHeroTitleSize,
                  ),
              children: [
                TextSpan(text: '${plan.titlePrefix} '),
                TextSpan(
                  text: plan.titleHighlight,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: Spacing.monthlyPlanHeroTitleSize,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),
          if (plan.discountLabel.isNotEmpty) ...[
            const SizedBox(height: Spacing.monthlyPlanPromotionGap),
            Container(
              constraints: const BoxConstraints(
                minHeight: Spacing.monthlyPlanPromotionHeight,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.monthlyPlanPromotionPadding,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.primary,
                borderRadius: BorderRadius.circular(
                  Spacing.monthlyPlanPromotionRadius,
                ),
              ),
              child: Text(
                plan.discountLabel,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: Spacing.monthlyPlanPromotionTextSize,
                  color: color.onPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
