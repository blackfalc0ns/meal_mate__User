import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
part 'calendar_header_icon_button.dart';

class CalendarScreenHeader extends StatelessWidget {
  const CalendarScreenHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 116,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.primary,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: topInset + 25,
              left: 22,
              right: 22,
              child: SizedBox(
                height: Spacing.iconXl,
                child: Row(
                  children: [
                    _HeaderIconButton(
                      icon: Icons.notifications_rounded,
                      onPressed: () {},
                      showDot: true,
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: 25,
                        color: color.onPrimary,
                      ),
                    ),
                    const Spacer(),
                    _HeaderIconButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: onBack,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
