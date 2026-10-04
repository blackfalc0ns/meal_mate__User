part of 'calendar_restaurant_picker_sheet.dart';

class CalendarArrowBubble extends StatelessWidget {
  const CalendarArrowBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      width: 24.74,
      height: 24.74,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: color.onSurface,
          size: 15,
        ),
      ),
    );
  }
}
