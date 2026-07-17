part of 'calendar_meal_picker_sheet.dart';

class CalendarSelectButton extends StatelessWidget {
  const CalendarSelectButton({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 22,
      height: 20,
      decoration: BoxDecoration(
        color: selected ? color.primary : color.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.primary, width: 1.4),
      ),
      alignment: Alignment.center,
      child: Icon(
        selected ? Icons.check_rounded : Icons.add_rounded,
        color: selected ? color.onPrimary : color.primary,
        size: 16,
      ),
    );
  }
}
