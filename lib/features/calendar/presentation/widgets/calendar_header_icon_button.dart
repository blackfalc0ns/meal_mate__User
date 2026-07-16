part of 'calendar_screen_header.dart';

class CalendarHeaderIconButton extends StatelessWidget {
  const CalendarHeaderIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.calendar_title,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          width: Spacing.iconMd,
          height: Spacing.iconMd,
        ),
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: color.onPrimary, size: Spacing.iconMd),
            if (showDot)
              Positioned(
                top: -Spacing.hairline,
                left: Spacing.calendarHeaderNotificationDotStart,
                child: Container(
                  width: Spacing.sm,
                  height: Spacing.sm,
                  decoration: BoxDecoration(
                    color: color.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
