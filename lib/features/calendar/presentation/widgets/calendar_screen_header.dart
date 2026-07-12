import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

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
        decoration: const BoxDecoration(
          color: Color(0xFF137A43),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: topInset + 25,
              left: 22,
              right: 22,
              child: SizedBox(
                height: 48,
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

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 38, height: 38),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: AppColors.white, size: 24),
          if (showDot)
            PositionedDirectional(
              top: -1,
              end: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
