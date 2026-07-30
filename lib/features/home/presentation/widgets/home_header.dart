import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
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
          ColoredBox(color: color.primaryContainer),
          Positioned.fill(
            child: Opacity(
              opacity: .22,
              child: SvgPicture.asset(
                Assets.homeFigmaHeaderDoodle,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.homeHorizontalPadding,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_rounded,
                  color: color.onSurface,
                  size: Spacing.iconLg,
                ),
                const SizedBox(width: Spacing.md),
                CircleAvatar(
                  radius: Spacing.lg,
                  backgroundImage: const AssetImage(Assets.homeFigmaAvatar),
                ),
                const SizedBox(width: Spacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      locale.home_greeting,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.home_greeting_subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Badge(
                  smallSize: Spacing.sm,
                  child: CircleAvatar(
                    backgroundColor: color.surface,
                    child: Icon(
                      Icons.notifications_rounded,
                      color: color.onSurface,
                    ),
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
