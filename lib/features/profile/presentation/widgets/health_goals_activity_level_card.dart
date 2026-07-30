import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HealthGoalsActivityLevelCard extends StatelessWidget {
  const HealthGoalsActivityLevelCard({
    super.key,
    required this.selectedActivity,
    required this.onActivitySelected,
  });

  final int selectedActivity;
  final ValueChanged<int> onActivitySelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final labels = [
      locale.health_goals_activity_low,
      locale.health_goals_activity_medium,
      locale.health_goals_activity_active,
      locale.health_goals_activity_high,
    ];
    const assets = [
      Assets.healthGoalRunning,
      Assets.healthGoalWalking,
      Assets.healthGoalJogging,
      Assets.healthGoalWeightlifting,
    ];

    return Container(
      height: Spacing.healthGoalsActivityCardAdjustedHeight,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.healthGoalsCardRadius),
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: .07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                Assets.healthGoalRunning,
                width: Spacing.iconMd,
                height: Spacing.iconMd,
              ),
              const SizedBox(width: Spacing.xs),

              Text(
                locale.health_goals_activity_level,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(labels.length, (index) {
                final selected = index == selectedActivity;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: index == labels.length - 1 ? 0 : Spacing.xss,
                    ),
                    child: InkWell(
                      onTap: () => onActivitySelected(index),
                      borderRadius: BorderRadius.circular(
                        Spacing.healthGoalsGoalCardRadius,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected ? color.primary : color.surface,
                          borderRadius: BorderRadius.circular(
                            Spacing.healthGoalsGoalCardRadius,
                          ),
                          border: Border.all(
                            color: selected
                                ? color.primary
                                : color.outlineVariant,
                            width: Spacing.border,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              selected ? Assets.healthGoalCheck : assets[index],
                              width: Spacing.lg,
                              height: Spacing.lg,
                            ),
                            const SizedBox(height: Spacing.xs),
                            Text(
                              labels[index],
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: selected
                                    ? color.onPrimary
                                    : color.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
