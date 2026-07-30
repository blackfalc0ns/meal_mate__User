import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionDetailsHeader extends StatelessWidget {
  const SubscriptionDetailsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.lg,
        right: Spacing.lg,
        top: Spacing.xl,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: Spacing.xxxl,
            child: IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: color.onSurface,
                size: Spacing.iconMd,
                semanticLabel: locale.go_back,
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.subscriptionProgramsLogo,
                    width: Spacing.xxl,
                    semanticsLabel: locale.nav_subscription,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.app_brand_name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size18,
                      color: color.primary,
                    ),
                  ),
                ],
              ),
              Text(
                locale.app_brand_tagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox.square(dimension: Spacing.xxxl),
        ],
      ),
    );
  }
}
