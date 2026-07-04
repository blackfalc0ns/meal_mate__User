import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
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
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                const Spacer(flex: 5),
                Text(
                  locale.subscription_details_subscribe_now,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 35,
                    color: AppColors.white,
                  ).copyWith(height: 1),
                ),
                const Spacer(flex: 4),
                Container(width: 1.2, height: 29, color: AppColors.white),
                const Spacer(flex: 3),
                const Icon(
                  Icons.monetization_on_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  plan.price,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 24,
                    color: AppColors.white,
                  ).copyWith(height: 1),
                ),
                const SizedBox(width: 4),
                Text(
                  plan.currency,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 11,
                    color: AppColors.white,
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
