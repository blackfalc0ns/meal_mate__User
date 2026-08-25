import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    assert(locale.localeName.isNotEmpty);

    return SizedBox(
      height: Spacing.calendarHeaderHeight,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.primary,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(Spacing.calendarHeaderRadius),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              PositionedDirectional(
                top: Spacing.lg,
                start: Spacing.calendarHeaderHorizontalInset,
                child: Icon(
                  Icons.notifications_rounded,
                  color: color.onPrimary,
                  size: Spacing.iconLg,
                ),
              ),
              PositionedDirectional(
                top: Spacing.lg,
                end: Spacing.calendarHeaderHorizontalInset,
                child: Icon(
                  Icons.volume_mute_rounded,
                  color: color.onPrimary,
                  size: Spacing.iconLg,
                ),
              ),
              PositionedDirectional(
                top: Spacing.xxxl,
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
