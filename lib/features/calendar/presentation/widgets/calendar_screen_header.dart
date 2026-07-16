import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
part 'calendar_header_icon_button.dart';

class CalendarScreenHeader extends StatelessWidget {
  const CalendarScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.calendarHeaderHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color.primary),
        child: Stack(
          children: [
            Positioned(
              top: Spacing.calendarHeaderTitleTop,
              left: 0,
              right: 0,
              child: SizedBox(
                height: Spacing.iconXl,
                child: Center(
                  child: Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size25,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Spacing.calendarHeaderIconTop,
              left: Spacing.calendarHeaderHorizontalInset,
              child: Semantics(
                label: locale.calendar_title,
                child: CalendarHeaderIconButton(
                  icon: Icons.notifications_rounded,
                  onPressed: () {},
                  showDot: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
