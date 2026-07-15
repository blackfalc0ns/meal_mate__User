import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanSubscribeBar extends StatelessWidget {
  const MonthlyPlanSubscribeBar({
    super.key,
    required this.plan,
    required this.onPressed,
  });

  final MonthlyPlanDetailsEntity plan;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Spacing.monthlyPlanSubscribeRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.primary.withValues(alpha: 0.82), color.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.22),
            blurRadius: Spacing.monthlyPlanSubscribeShadowBlur,
            offset: const Offset(0, Spacing.monthlyPlanSubscribeShadowOffset),
          ),
        ],
      ),
      child: Material(
        color: color.surface.withValues(alpha: 0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            Spacing.monthlyPlanSubscribeRadius,
          ),
          child: SizedBox(
            height: Spacing.monthlyPlanSubscribeHeight,
            child: Row(
              children: [
                const Spacer(flex: 5),
                Text(
                  locale.subscription_details_subscribe_now,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: Spacing.monthlyPlanSubscribeTitleSize,
                    color: color.onPrimary,
                  ).copyWith(height: 1),
                ),
                const Spacer(flex: 4),
                Container(
                  width: Spacing.monthlyPlanSubscribeDividerWidth,
                  height: Spacing.monthlyPlanSubscribeDividerHeight,
                  color: color.onPrimary,
                ),
                const Spacer(flex: 3),
                Icon(
                  Icons.monetization_on_rounded,
                  color: color.onPrimary,
                  size: Spacing.monthlyPlanSubscribeCoinSize,
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  plan.price,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: Spacing.monthlyPlanSubscribePriceSize,
                    color: color.onPrimary,
                  ).copyWith(height: 1),
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  plan.currency,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: Spacing.monthlyPlanSubscribeCurrencySize,
                    color: color.onPrimary,
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
