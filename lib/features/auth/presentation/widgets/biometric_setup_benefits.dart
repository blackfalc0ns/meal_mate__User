import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class BiometricSetupBenefits extends StatelessWidget {
  const BiometricSetupBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final benefits = [
      (
        icon: Icons.shield_outlined,
        title: locale.biometric_benefit_security_title,
        subtitle: locale.biometric_benefit_security_subtitle,
      ),
      (
        icon: Icons.bolt_rounded,
        title: locale.biometric_benefit_speed_title,
        subtitle: locale.biometric_benefit_speed_subtitle,
      ),
      (
        icon: Icons.verified_user_outlined,
        title: locale.biometric_benefit_operations_title,
        subtitle: locale.biometric_benefit_operations_subtitle,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < benefits.length; i++) ...[
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: color.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Spacing.buttonSmallHeight,
                  height: Spacing.buttonSmallHeight,
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Spacing.buttonSmallRadius),
                  ),
                  child: Icon(
                    benefits[i].icon,
                    size: Spacing.iconSm + Spacing.xs,
                    color: color.primary,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefits[i].title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        benefits[i].subtitle,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ).copyWith(height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (i < benefits.length - 1) const SizedBox(height: Spacing.sm),
        ],
      ],
    );
  }
}
