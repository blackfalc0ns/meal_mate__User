import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeSubscriptionCta extends StatelessWidget {
  const HomeSubscriptionCta({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Container(
      width: Spacing.homeSubscriptionCtaWidth,
      height: Spacing.homeSubscriptionCtaHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(Spacing.homeSubscriptionCtaRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locale.home_subscription_details,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size8,
              color: color.onPrimary,
            ),
          ),
          Transform.rotate(
            angle: math.pi,
            child: SvgPicture.asset(
              Assets.homeSubscriptionArrow,
              width: Spacing.homeSubscriptionArrowWidth,
              height: Spacing.homeSubscriptionArrowHeight,
            ),
          ),
        ],
      ),
    );
  }
}
