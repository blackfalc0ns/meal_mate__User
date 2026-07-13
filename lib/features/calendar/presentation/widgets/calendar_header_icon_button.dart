part of 'calendar_screen_header.dart';

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
    final color = context.colorScheme;

    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 38, height: 38),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: color.onPrimary, size: 24),
          if (showDot)
            PositionedDirectional(
              top: -1,
              start: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
