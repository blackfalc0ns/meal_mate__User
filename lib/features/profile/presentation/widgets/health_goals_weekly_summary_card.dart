import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HealthGoalsWeeklySummaryCard extends StatelessWidget {
  const HealthGoalsWeeklySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.healthGoalsWeeklyCardHeight,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.healthGoalsWeeklySummaryBackground,
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.healthGoalTrend,
                  width: Spacing.iconMd,
                  height: Spacing.iconMd,
                ),
                const SizedBox(width: Spacing.xs),

                Text(
                  locale.health_goals_weekly_summary,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: Spacing.xxl,
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '45 يوم',
                              style: getBoldStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                            Text(
                              locale.health_goals_continuous,
                              style: getBoldStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size13,
                                color: color.onSurface,
                              ),
                            ),
                            SizedBox(height: Spacing.xs),
                            FittedBox(
                              child: Text(
                                locale.health_goals_keep_progress,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size11,
                                  color: color.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),

                      Container(
                        width: Spacing.healthGoalsWeeklyMetricIconContainerSize,
                        height:
                            Spacing.healthGoalsWeeklyMetricIconContainerSize,
                        decoration: BoxDecoration(
                          color: color.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          Assets.healthGoalFire,
                          width: Spacing.md,
                          height: Spacing.md,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: VerticalDivider(
                    color: color.primaryContainer,
                    indent: Spacing.sm,
                    endIndent: Spacing.sm,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '4.2 كجم',
                              style: getBoldStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size13,
                                color: color.primary,
                              ),
                            ),
                            Text(
                              locale.health_goals_decrease,
                              style: getBoldStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size11,
                                color: color.onSurface,
                              ),
                            ),
                            Text(
                              locale.health_goals_since_plan_start,
                              style: getMediumStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size10,
                                color: color.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),

                      Container(
                        width: Spacing.healthGoalsWeeklyMetricIconContainerSize,
                        height:
                            Spacing.healthGoalsWeeklyMetricIconContainerSize,
                        decoration: BoxDecoration(
                          color: color.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          Assets.healthGoalArrowDown,
                          width: Spacing.md,
                          height: Spacing.md,
                        ),
                      ),
                    ],
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
