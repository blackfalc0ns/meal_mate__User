part of 'calendar_restaurant_picker_sheet.dart';

class CalendarArrowBubble extends StatelessWidget {
  const CalendarArrowBubble();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: 24.74,
      height: 24.74,
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        color: color.onSurface,
        size: 15,
      ),
    );
  }
}
