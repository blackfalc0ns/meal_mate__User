import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HealthGoalsGoalSummaryCard extends StatelessWidget {
  const HealthGoalsGoalSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.healthGoalsGoalCardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.base,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.surface, color.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(Spacing.healthGoalsGoalCardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: Spacing.xs),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  locale.health_goals_current_goal,
                  textAlign: TextAlign.right,
                  style: getMediumStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
                Text(
                  locale.health_goals_weight_loss,
                  textAlign: TextAlign.right,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size19,
                    color: color.primary,
                  ),
                ),
                const Spacer(),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(
                      child: Text(
                        locale.health_goals_progress,
                        textAlign: TextAlign.center,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          locale.health_goals_target_weight,
                          textAlign: TextAlign.center,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size12,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        locale.health_goals_current_weight,
                        textAlign: TextAlign.center,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(
                      child: Text(
                        '60%',
                        textAlign: TextAlign.center,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: color.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '72 كجم',
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                            vertical: Spacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: color.surface,
                            border: Border.all(color: color.primary),
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusXs,
                            ),
                          ),
                          child: Text(
                            '78 كجم',
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  child: LinearProgressIndicator(
                    value: .6,
                    minHeight: Spacing.xs,
                    color: color.primary,
                    backgroundColor: color.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Image.asset(
              Assets.healthGoalTarget,
              fit: BoxFit.contain,
              alignment: Alignment.bottomLeft,
            ),
          ),
        ],
      ),
    );
  }
}
