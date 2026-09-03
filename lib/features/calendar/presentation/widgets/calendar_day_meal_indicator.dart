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

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: muted ? color.primary : null,
        border: muted
            ? null
            : Border.all(
                color: selected ? color.onPrimary : color.onSurface,
                width: 0.95,
              ),
      ),
    );
  }
}
