import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onNotificationPressed,
  });

  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.calendarHeaderHeight,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.primary,
          borderRadius: const BorderRadius.vertical(
            //   bottom: Radius.circular(Spacing.calendarHeaderRadius),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              PositionedDirectional(
                top: Spacing.xxl,
                end: Spacing.calendarHeaderHorizontalInset,
                child: IconButton(
                  onPressed: onNotificationPressed,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: color.onPrimary,
                        size: Spacing.iconLg,
                      ),
                      PositionedDirectional(
                        top: 2,
                        end: 3,
                        child: Container(
                          width: Spacing.sm,
                          height: Spacing.sm,
                          decoration: BoxDecoration(
                            color: color.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PositionedDirectional(
                top: Spacing.xl,
                start: 0,
                end: 0,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size22,
                    color: color.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
