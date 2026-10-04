part of 'calendar_restaurant_picker_sheet.dart';

class CalendarArrowBubble extends StatelessWidget {
  const CalendarArrowBubble({super.key, this.isLocked = false});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: 24.74,
      height: 24.74,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isLocked
              ? Icons.lock_outline_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: isLocked ? color.error : color.onSurface,
          size: isLocked ? 13 : 13,
        ),
      ),
    );
  }
}
