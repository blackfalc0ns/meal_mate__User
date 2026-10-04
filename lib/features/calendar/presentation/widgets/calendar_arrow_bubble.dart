part of 'calendar_restaurant_picker_sheet.dart';

class CalendarArrowBubble extends StatelessWidget {
  const CalendarArrowBubble({super.key, this.isLocked = false});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 30,
      height: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            isLocked
                ? Icons.lock_outline_rounded
                : Icons.arrow_forward_ios_rounded,
            color: isLocked ? color.error : color.onSurface,
            size: Spacing.iconSm,
          ),
        ),
      ),
    );
  }
}
