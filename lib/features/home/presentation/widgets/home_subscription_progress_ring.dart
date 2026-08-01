import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_progress_painter.dart';

class HomeSubscriptionProgressRing extends StatelessWidget {
  const HomeSubscriptionProgressRing({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final subscriptionProgress = 12 / 30;
    return SizedBox(
      width: Spacing.homeSubscriptionProgressWidth,
      height: Spacing.homeSubscriptionProgressHeight,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          PositionedDirectional(
            top: Spacing.homeSubscriptionRingTop,
            child: SizedBox(
              width: Spacing.homeSubscriptionRingHeight,
              height: Spacing.homeSubscriptionRingHeight,
              child: CustomPaint(
                painter: HomeSubscriptionProgressPainter(
                  progress: subscriptionProgress,
                  trackColor: color.primaryContainer,
                  progressColor: color.primary,
                  strokeWidth: Spacing.homeSubscriptionProgressStroke,
                  gapAngle: Spacing.homeSubscriptionProgressGap,
                ),
              ),
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
    );
  }
}
