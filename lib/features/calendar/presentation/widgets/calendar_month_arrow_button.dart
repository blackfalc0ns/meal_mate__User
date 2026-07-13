part of 'calendar_picker_panel.dart';

class CalendarMonthArrowButton extends StatelessWidget {
  const CalendarMonthArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 18, height: 18),
      icon: DecoratedBox(
        decoration: BoxDecoration(color: color.primary, shape: BoxShape.circle),
        child: Icon(icon, color: color.onPrimary, size: 17),
      ),
    );
  }
}
