import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HealthGoalsBodyDataCard extends StatelessWidget {
  const HealthGoalsBodyDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.healthGoalsBodyCardHeight,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.healthGoalsCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: .07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                Assets.healthGoalBody,
                width: Spacing.iconSm,
                height: Spacing.iconSm,
              ),
              const SizedBox(width: Spacing.xs),

              Text(
                locale.health_goals_body_data,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _bodyMetric(
                  context,
                  label: locale.health_goals_height,
                  value: '175 سم',
                  asset: Assets.healthGoalHeight,
                ),
              ),
              VerticalDivider(color: color.primaryContainer),
              Expanded(
                child: _bodyMetric(
                  context,
                  label: locale.health_goals_current_weight,
                  value: '78 كجم',
                  asset: Assets.healthGoalCurrentWeight,
                ),
              ),
              VerticalDivider(color: color.primaryContainer),
              Expanded(
                child: _bodyMetric(
                  context,
                  label: locale.health_goals_target_weight,
                  value: '72 كجم',
                  asset: Assets.healthGoalTargetWeight,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _bodyMetric(
    BuildContext context, {
    required String label,
    required String value,
    required String asset,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset, width: Spacing.xl, height: Spacing.xl),
            const SizedBox(width: Spacing.xs),

            Text(
              value,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
              semanticsLabel: locale.health_goals_body_data,
            ),
          ],
        ),
      ],
    );
  }
}
