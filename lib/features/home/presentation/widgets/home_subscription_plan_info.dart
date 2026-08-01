import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeSubscriptionPlanInfo extends StatelessWidget {
  const HomeSubscriptionPlanInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
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
              fontSize: FontSize.size10,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
