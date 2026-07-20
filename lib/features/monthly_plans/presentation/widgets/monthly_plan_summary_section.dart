import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanSummarySection extends StatelessWidget {
  const MonthlyPlanSummarySection({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: getBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size33,
              color: AppColors.quaternary500,
            ).copyWith(height: 1),
            children: [
              TextSpan(text: '${plan.titlePrefix} '),
              TextSpan(
                text: plan.titleHighlight,
                style: const TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.lg),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PlanMeta(icon: Icons.calendar_month_outlined, text: plan.duration),
            const SizedBox(
              height: 16,
              child: VerticalDivider(
                width: Spacing.lg,
                color: AppColors.appTextMuted,
              ),
            ),
            _PlanMeta(icon: Icons.restaurant_rounded, text: plan.mealsPerDay),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.brandDeepGreen,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.percent_rounded,
                color: AppColors.white,
                size: 18,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                plan.discountLabel,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size13,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanMeta extends StatelessWidget {
  const _PlanMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.appTextMuted),
        const SizedBox(width: Spacing.xs),
        Text(
          text,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size12,
            color: AppColors.appTextMuted,
          ),
        ),
      ],
    );
  }
}
