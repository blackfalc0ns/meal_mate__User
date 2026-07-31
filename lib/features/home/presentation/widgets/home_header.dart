import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      height: Spacing.homeHeaderHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.homeHeaderGradient),
          ),
          Positioned.fill(
            child: ClipRRect(
              child: Opacity(
                opacity: 1,
                child: SvgPicture.asset(
                  Assets.homeFigmaHeaderDoodle,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeHeaderContentTop,
            start: Spacing.homeHorizontalPadding,
            end: Spacing.homeHorizontalPadding,
            child: SizedBox(
              height: Spacing.homeHeaderAvatarSize,
              child: Row(
                children: [
                  SizedBox(
                    width: Spacing.homeHeaderMenuWidth,
                    height: Spacing.homeHeaderMenuHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _menuLine(context, Spacing.homeHeaderMenuWidth),
                        _menuLine(context, Spacing.base),
                        _menuLine(context, Spacing.homeHeaderMenuWidth),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Image.asset(
                    Assets.homeFigmaAvatar,
                    width: Spacing.homeHeaderAvatarSize,
                    height: Spacing.homeHeaderAvatarSize,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        locale.home_greeting,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: 13.176,
                          color: color.onSurface,
                        ),
                      ),
                      Text(
                        locale.home_greeting_subtitle,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: 9.94,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeHeaderNotificationTop,
            end: Spacing.homeHorizontalPadding,
            child: SizedBox(
              width: Spacing.homeHeaderNotificationSize,
              height: Spacing.homeHeaderNotificationSize,
              child: Badge(
                smallSize: Spacing.sm,
                child: CircleAvatar(
                  backgroundColor: color.surface,
                  child: SvgPicture.asset(
                    Assets.notificationBold,
                    width: Spacing.iconMd,
                    height: Spacing.iconMd,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuLine(BuildContext context, double width) {
    final color = context.colorScheme;
    return Container(
      width: width,
      height: Spacing.xs,
      decoration: BoxDecoration(
        color: color.onSurface,
        borderRadius: BorderRadius.circular(Spacing.radiusXs),
      ),
    );
  }
}
