import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanHeroSummary extends StatelessWidget {
  const MonthlyPlanHeroSummary({
    super.key,
    required this.plan,
    required this.scale,
  });

  final MonthlyPlanDetailsEntity plan;
  final double scale;

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
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: Spacing.monthlyPlanHeroTitleSize * scale,
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
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: Spacing.monthlyPlanHeroTitleSize * scale,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Spacing.monthlyPlanPromotionGap * scale),
          Container(
            height: Spacing.monthlyPlanPromotionHeight * scale,
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.monthlyPlanPromotionPadding * scale,
            ),
            decoration: BoxDecoration(
              color: color.primary,
              borderRadius: BorderRadius.circular(
                Spacing.monthlyPlanPromotionRadius * scale,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.percent_rounded,
                  color: color.onPrimary,
                  size: Spacing.monthlyPlanPromotionIconSize * scale,
                ),
                SizedBox(width: Spacing.monthlyPlanPromotionGap * scale),
                Text(
                  plan.discountLabel,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: Spacing.monthlyPlanPromotionTextSize * scale,
                    color: color.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
