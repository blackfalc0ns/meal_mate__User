import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberCalendarMonthNavButton extends StatelessWidget {
  const FamilyMemberCalendarMonthNavButton({
    super.key,
    required this.icon,
    required this.isEnabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: isEnabled
          ? color.primary
          : color.outlineVariant.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: isEnabled ? onPressed : null,
        child: SizedBox(
          width: Spacing.familyMemberCalendarMonthHeight,
          height: Spacing.familyMemberCalendarMonthHeight,
          child: Center(
            child: Icon(
              icon,
              size: Spacing.iconMd,
              color: isEnabled ? color.onPrimary : color.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
