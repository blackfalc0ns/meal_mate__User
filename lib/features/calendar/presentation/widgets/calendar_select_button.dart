part of 'calendar_meal_picker_sheet.dart';

class CalendarSelectButton extends StatelessWidget {
  const CalendarSelectButton({required this.selected, this.enabled = true});

  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 22,
      height: 20,
      decoration: BoxDecoration(
        color: selected
            ? color.primary
            : enabled
            ? color.surface.withValues(alpha: 0)
            : color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: enabled ? color.primary : color.outlineVariant,
          width: 1.4,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        selected
            ? Icons.check_rounded
            : enabled
            ? Icons.add_rounded
            : Icons.block_rounded,
        color: selected
            ? color.onPrimary
            : enabled
            ? color.primary
            : color.onSurfaceVariant,
        size: 16,
      ),
    );
  }
}
