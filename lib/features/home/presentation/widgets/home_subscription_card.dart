import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeSubscriptionCard extends StatelessWidget {
  const HomeSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Center(
      child: SizedBox(
        width: Spacing.homeSubscriptionCardWidth,
        height: Spacing.homeSubscriptionCardHeight,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: AlignmentDirectional.topStart,
          child: SizedBox(
            width: Spacing.homeSubscriptionCardWidth,
            height: Spacing.homeSubscriptionCardHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(
                        Spacing.homeSubscriptionCardRadius,
                      ),
                      border: Border.all(
                        color: color.outlineVariant,
                        width: Spacing.homeSubscriptionCardBorder,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionSegmentTop,
                  start: Spacing.homeSubscriptionSegmentStart,
                  end: Spacing.homeSubscriptionSegmentEnd,
                  child: Container(
                    height: Spacing.homeSubscriptionSegmentHeight,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        Spacing.homeSubscriptionSegmentRadius,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: Spacing.homeSubscriptionSelectedSegmentWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.primary,
                              borderRadius: BorderRadius.circular(
                                Spacing.homeSubscriptionSegmentRadius,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  locale.home_subscription_tab,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size10,
                                    color: color.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: Spacing.xs),
                                SvgPicture.asset(
                                  Assets.homeSubscriptionCalendar,
                                  width: Spacing.homeSubscriptionPlanIconSize,
                                  height: Spacing.homeSubscriptionPlanIconSize,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locale.home_nutrition_tab,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: color.primary,
                                ),
                              ),
                              const SizedBox(width: Spacing.xs),
                              SvgPicture.asset(
                                Assets.homeSubscriptionHealth,
                                width: Spacing.homeSubscriptionPlanIconSize,
                                height: Spacing.homeSubscriptionPlanIconSize,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionPlanTop,
                  start: Spacing.homeSubscriptionPlanStart,
                  child: SizedBox(
                    width: Spacing.homeSubscriptionMetricsWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            width: Spacing.homeSubscriptionBadgeWidth,
                            height: Spacing.homeSubscriptionBadgeHeight,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              color: color.primaryContainer,
                              borderRadius: BorderRadius.circular(
                                Spacing.homeSubscriptionBadgeRadius,
                              ),
                            ),
                            child: Text(
                              locale.home_current_plan,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size7,
                                color: color.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.homeSubscriptionPlanGap),
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.homeSubscriptionPlan,
                              width: Spacing.homeSubscriptionPlanIconSize,
                              height: Spacing.homeSubscriptionPlanIconSize,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Flexible(
                              child: Text(
                                locale.home_weight_loss_program,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size12,
                                  color: color.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          locale.home_renewal_date,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionProgressTop,
                  start: Spacing.homeSubscriptionProgressStart,
                  child: SizedBox(
                    width: Spacing.homeSubscriptionProgressWidth,
                    height: Spacing.homeSubscriptionProgressHeight,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        PositionedDirectional(
                          top: Spacing.homeSubscriptionRingTop,
                          child: SvgPicture.asset(
                            Assets.homeSubscriptionProgress,
                            width: Spacing.homeSubscriptionProgressWidth,
                            height: Spacing.homeSubscriptionRingHeight,
                          ),
                        ),
                        PositionedDirectional(
                          top: Spacing.xl,
                          child: Column(
                            children: [
                              Text(
                                locale.home_subscription_days_value,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size30,
                                  color: color.onSurface,
                                ),
                              ),
                              Text(
                                locale.home_days_remaining_label,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size8,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.xs),
                              Text(
                                locale.home_subscription_days_total,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size7,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          bottom: Spacing.homeSubscriptionPlantBottom,
                          child: SvgPicture.asset(
                            Assets.homeSubscriptionPlant,
                            width: Spacing.homeSubscriptionPlantSize,
                            height: Spacing.homeSubscriptionPlantSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionMetricsTop,
                  start: Spacing.homeSubscriptionPlanStart,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            locale.home_average_calories,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size7,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            locale.home_average_calories_value,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                locale.home_calories_per_meal,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size6,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(width: Spacing.xs),
                              SvgPicture.asset(
                                Assets.homeSubscriptionFire,
                                width: Spacing.md,
                                height: Spacing.md,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: Spacing.homeSubscriptionMetricGap),
                      Column(
                        children: [
                          Text(
                            locale.home_completed_meals,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size7,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            locale.home_completed_meals_value,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            locale.home_completed_meals_total,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size6,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),
                          SvgPicture.asset(
                            Assets.homeSubscriptionCompletedProgress,
                            width:
                                Spacing.homeSubscriptionCompletedProgressWidth,
                            height:
                                Spacing.homeSubscriptionCompletedProgressHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionSummaryTop,
                  start: Spacing.homeSubscriptionSummaryStart,
                  child: Container(
                    width: Spacing.homeSubscriptionSummaryWidth,
                    height: Spacing.homeSubscriptionSummaryHeight,
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(
                        Spacing.homeSubscriptionSummaryRadius,
                      ),
                      border: Border.all(color: color.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: color.shadow.withValues(alpha: 0.10),
                          blurRadius: Spacing.md,
                          offset: const Offset(Spacing.xs, Spacing.xs),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _statusItem(
                                  context: context,
                                  icon: Assets.homeSubscriptionDayCalendar,
                                  label: locale.home_remaining_days,
                                  value: locale.home_subscription_days_value,
                                  subtitle:
                                      locale.home_subscription_days_total_alt,
                                ),
                              ),
                              _divider(color.outlineVariant),
                              Expanded(
                                child: _statusItem(
                                  context: context,
                                  icon: Assets.homeSubscriptionMeal,
                                  label: locale.home_selected_meals,
                                  value: locale.home_selected_meals_value,
                                  subtitle: locale.home_meal,
                                ),
                              ),
                              _divider(color.outlineVariant),
                              Expanded(
                                child: _statusItem(
                                  context: context,
                                  icon: Assets.homeSubscriptionMedal,
                                  label: locale.home_commitment,
                                  value: locale.home_commitment_value,
                                  subtitle: locale.home_excellent_performance,
                                ),
                              ),
                              _divider(color.outlineVariant),
                              Expanded(
                                child: _statusItem(
                                  context: context,
                                  icon: Assets.homeSubscriptionDelivery,
                                  label: locale.home_next_delivery,
                                  value: locale.home_tomorrow,
                                  subtitle: locale.home_before_noon,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: Spacing.homeSubscriptionSummaryFooterHeight,
                          alignment: AlignmentDirectional.center,
                          decoration: BoxDecoration(
                            color: color.primaryContainer,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(
                                Spacing.homeSubscriptionBadgeRadius,
                              ),
                            ),
                          ),
                          child: Text(
                            locale.home_on_track,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size7,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: Spacing.homeSubscriptionCtaTop,
                  start: Spacing.homeSubscriptionCtaStart,
                  child: Container(
                    width: Spacing.homeSubscriptionCtaWidth,
                    height: Spacing.homeSubscriptionCtaHeight,
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(
                        Spacing.homeSubscriptionCtaRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.rotate(
                          angle: math.pi,
                          child: SvgPicture.asset(
                            Assets.homeSubscriptionArrow,
                            width: Spacing.homeSubscriptionArrowWidth,
                            height: Spacing.homeSubscriptionArrowHeight,
                          ),
                        ),
                        Text(
                          locale.home_subscription_details,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: color.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusItem({
    required BuildContext context,
    required String icon,
    required String label,
    required String value,
    required String subtitle,
  }) {
    final color = context.colorScheme;
    return SizedBox(
      height: Spacing.homeSubscriptionStatusHeight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  icon,
                  width: Spacing.homeSubscriptionPlanIconSize,
                  height: Spacing.homeSubscriptionPlanIconSize,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size7,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size7,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(Color color) {
    return Container(
      width: Spacing.homeSubscriptionDividerWidth,
      height: Spacing.homeSubscriptionDividerHeight,
      color: color,
    );
  }
}
