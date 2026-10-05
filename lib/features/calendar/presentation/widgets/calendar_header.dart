import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.title,
    this.onNotificationPressed,
    this.hasNotification = false,
  });

  final String title;
  final VoidCallback? onNotificationPressed;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.calendarHeaderHeight,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color.primary),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.calendarHeaderHorizontalInset,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size22,
                    color: color.onPrimary,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: NotificationButton(
                    onTap: onNotificationPressed,
                    hasNotification: hasNotification,
                    iconColor: color.onPrimary,
                    badgeBorderColor: color.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
