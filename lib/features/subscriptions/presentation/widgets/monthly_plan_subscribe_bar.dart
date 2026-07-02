import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AppButton(
        text: plan.subscribeLabel,
        onPressed: onPressed,
        height: 61,
        borderRadius: 34,
        gradient: AppColors.primaryGradient,
        fontSize: FontSize.size28,
        fontWeight: FontWeight.w700,
        iconWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 1, height: 25, color: AppColors.white),
            const SizedBox(width: Spacing.lg),
            const Icon(
              Icons.monetization_on_rounded,
              color: AppColors.white,
              size: 24,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              '${plan.price} ${plan.currency}',
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size20,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
