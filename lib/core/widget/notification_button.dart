import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    super.key,
    this.onTap,
    this.hasNotification = false,
    this.iconColor,
    this.badgeColor,
    this.badgeBorderColor,
    this.size,
    this.iconSize,
  });

  final VoidCallback? onTap;
  final bool hasNotification;
  final Color? iconColor;
  final Color? badgeColor;
  final Color? badgeBorderColor;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final effectiveSize = size ?? 44.0;
    final effectiveIconSize = iconSize ?? Spacing.iconMd;
    final effectiveIconColor = iconColor ?? color.onSurface;
    final effectiveBadgeColor = badgeColor ?? color.secondary;
    final effectiveBadgeBorderColor = badgeBorderColor ?? color.surface;

    return Semantics(
      button: true,
      label: locale.notification_button_tooltip,
      child: Tooltip(
        message: locale.notification_button_tooltip,
        child: InkResponse(
          onTap:
              onTap ??
              () {
                unawaited(
                  Navigator.of(context).pushNamed(AppRoutes.notifications),
                );
              },
          radius: effectiveSize / 2,
          child: SizedBox.square(
            dimension: effectiveSize,
            child: Center(
              child: SizedBox.square(
                dimension: effectiveIconSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      Assets.notificationBell,
                      width: effectiveIconSize,
                      height: effectiveIconSize,
                      colorFilter: ColorFilter.mode(
                        effectiveIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    if (hasNotification)
                      PositionedDirectional(
                        top: -3,
                        start: Spacing.xxs,
                        child: Container(
                          width: Spacing.md,
                          height: Spacing.md,
                          decoration: BoxDecoration(
                            color: effectiveBadgeColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: effectiveBadgeBorderColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
