import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';

class MonthlyPlanOverviewSection extends StatelessWidget {
  const MonthlyPlanOverviewSection({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Column(
      children: [
        Text(
          plan.description,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size15,
            color: color.onSurface,
          ).copyWith(height: 1.7),
        ),
        const SizedBox(height: Spacing.lg),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            locale.subscription_details_features_title,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size15,
              color: AppColors.primaryVariant,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        DecoratedBox(
          decoration: const BoxDecoration(color: AppColors.white),
          child: Column(
            children: [
              for (int index = 0; index < plan.features.length; index++) ...[
                _FeatureRow(feature: plan.features[index]),
                if (index != plan.features.length - 1)
                  const Divider(height: 1, color: Color(0xFFE7E9E6)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final MonthlyPlanFeatureEntity feature;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          const Icon(Icons.check_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              feature.title,
              textAlign: TextAlign.right,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EED8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              _iconFor(feature.iconName),
              size: 19,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'plant':
        return Icons.eco_outlined;
      case 'user':
        return Icons.person_outline_rounded;
      case 'plan':
        return Icons.assignment_outlined;
      case 'swap':
        return Icons.sync_rounded;
      case 'support':
        return Icons.headset_mic_outlined;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}
