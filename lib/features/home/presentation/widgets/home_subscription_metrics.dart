import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeSubscriptionMetrics extends StatelessWidget {
  const HomeSubscriptionMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              locale.home_average_calories,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
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
                    fontSize: FontSize.size9,
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
                fontSize: FontSize.size9,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            SvgPicture.asset(
              Assets.homeSubscriptionCompletedProgress,
              width: Spacing.homeSubscriptionCompletedProgressWidth,
              height: Spacing.homeSubscriptionCompletedProgressHeight,
            ),
          ],
        ),
      ],
    );
  }
}
