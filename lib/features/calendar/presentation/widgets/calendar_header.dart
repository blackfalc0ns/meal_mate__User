import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.title,
    this.onNotificationPressed,
  });

  final String title;
  final VoidCallback? onNotificationPressed;

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
                  child: IconButton(
                    onPressed: onNotificationPressed,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: color.onPrimary,
                          size: Spacing.iconLg,
                        ),
                        PositionedDirectional(
                          top: 1,
                          end: 1,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
