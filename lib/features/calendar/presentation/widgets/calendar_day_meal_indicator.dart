part of 'calendar_picker_panel.dart';

class CalendarDayMealIndicator extends StatelessWidget {
  const CalendarDayMealIndicator({
    super.key,
    required this.selected,
    required this.muted,
    required this.compact,
  });

  final bool selected;
  final bool muted;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final size = compact ? 6.0 : 9.5;

    if (selected) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.onPrimary, width: 1.2),
        ),
      );
    }

    if (muted) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color.primary),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.onSecondaryContainer, width: 1.0),
      ),
    );
  }
}
